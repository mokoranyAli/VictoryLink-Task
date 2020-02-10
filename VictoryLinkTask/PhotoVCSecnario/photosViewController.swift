//
//  photosViewController.swift
//  VictoryLinkTask
//
//  Created by Mohamed Korany Ali on 2/10/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import UIKit

protocol LatLongDelegate {

func updateLatLong(lat:Double , long:Double)
    
}




class photosViewController: UIViewController , LatLongDelegate{
  
    fileprivate let Manger = FlickerAPI()
    fileprivate var searchPhotos = [Photo]()
    fileprivate let imageProvider = ImageProvider()
    fileprivate var pageCount = 0

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func updateLatLong(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
    

    
    var lat:Double? = nil
    var long:Double? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
       showActivityIndicator()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        fetchSearchImages()
        
        
        
    }
    
    
    func fetchSearchImages(){
                pageCount+=1   //Count increment here
        
        
        
        
        Manger.requestFor(searchType: .Coordinates(lat: self.lat!, long: self.long!), with: 1, decode: { json -> Photos? in
            guard let flickerResult = json as? Photos else { return  nil }
            return flickerResult
        }) { [unowned self] result in
            DispatchQueue.main.async {
                
                switch result{
                case .success(let value):
                  // print(value)
                    
                    self.searchPhotos = value.photos.photo
                    self.collectionView.reloadData()
                    self.hideActivityIndicator()
                    
                case .failure(let error):
                    print(error.debugDescription)
                    guard self.Manger.requestCancelStatus == false else { return }
                    
                }
            }
        }
    }

}



extension photosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      
            
               return CGSize(width: 120 , height: 100);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


extension photosViewController: UICollectionViewDataSource, RequestImages{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.searchPhotos.count ?? 0
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
                guard searchPhotos.count != 0 else {
                    return cell
                }
                let model = searchPhotos[indexPath.row]
                guard let mediaUrl = model.getImagePath() else {
                    return cell
                }
                //print(model.owner)
                print(model.title)
                print(model.owner)
               
                
                let image = imageProvider.cache.object(forKey: URL(string: mediaUrl)! as NSURL)
               cell.imageResult.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.imageResult.image = image
                if image == nil {
                    imageProvider.requestImage(from :URL(string: mediaUrl)!, completion: { image -> Void in
                        let indexPath_ = collectionView.indexPath(for: cell)
                        if indexPath == indexPath_ {
                            cell.imageResult.image = image
                        }
                    })
                }
        return cell
    }
    
}
