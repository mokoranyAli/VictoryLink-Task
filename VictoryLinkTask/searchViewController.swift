//
//  searchViewController.swift
//  VictoryLinkTask
//
//  Created by Mohamed Korany Ali on 2/10/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import UIKit
import MapKit


class searchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    var request:MKLocalSearch.Request?
    
    var photoVCDelegate:LatLongDelegate?
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var placesTableView: UITableView!
    var places = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchBar.becomeFirstResponder()
        
        
    }
    
    func updateMapItems(items: [Any]) {
        self.places = items as! [MKMapItem]
        self.placesTableView.reloadData()
    }
    
    
    func performSearch(text: String) {
        request = MKLocalSearch.Request()
        request?.naturalLanguageQuery = text
        
        let search = MKLocalSearch(request: request!)
        search.start { [weak self] (response, error) in
            
            guard self != nil else { return }
            
            
            guard let response = response else {
                return
            }
            guard let mySelf = self else{return}
            
            mySelf.places = response.mapItems
            mySelf.placesTableView.reloadData()
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let placemark = places[indexPath.row].placemark
        cell.textLabel?.text = placemark.title
        cell.detailTextLabel?.text = placemark.subtitle
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(photosViewController.self)") as! photosViewController
        self.photoVCDelegate = vc as? LatLongDelegate
         self.photoVCDelegate?.updateLatLong(lat: places[indexPath.row].placemark.coordinate.latitude, long: places[indexPath.row].placemark.coordinate.longitude)
        self.present(vc, animated: true, completion: nil)
       
        
        
    }
}




extension searchViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else { return }
        performSearch(text: text)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return }
        performSearch(text: text)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        dismiss(animated: true, completion: nil)
        print("done")
    }
}
