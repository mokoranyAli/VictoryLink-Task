//
//  homeViewController.swift
//  VictoryLinkTask
//
//  Created by Mohamed Korany Ali on 2/10/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import UIKit
import MapKit

class homeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var photoVCDelegate:LatLongDelegate?
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        showSearchController()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isToolbarHidden = false
        let menu = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action:#selector(didMenuSelected))
        self.navigationItem.leftBarButtonItem  = menu

        self.navigationItem.setHidesBackButton(true, animated: true);
        
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongpressed(sender:))))
    }
    
    @objc func didMenuSelected() {
        print("handle menu")
    }
    
    
    @objc func didLongpressed(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
           annotation.coordinate = locationCoordinate
           mapView.addAnnotation(annotation)
        
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(photosViewController.self)") as! photosViewController
        self.photoVCDelegate = vc 
        self.photoVCDelegate?.updateLatLong(lat: locationCoordinate.latitude, long: locationCoordinate.longitude)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    func showSearchController() {
        let searchController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(searchViewController.self)") as! searchViewController
        
        self.present(searchController, animated: true, completion: nil)
    }
    
    
}
