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
  
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func updateLatLong(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
    

    
    var lat:Double? = nil
    var long:Double? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
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
        
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! PhotoCell
        
       
        return cell
    }
    
}
