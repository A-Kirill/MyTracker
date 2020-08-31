//
//  MapViewController.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 30.08.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    private let defaultСoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private let defaultZoom: Float = 17
    
    private var marker: GMSMarker?
    private var locationManager: CLLocationManager?
    private var geocoder = CLGeocoder()

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        configureLocationManager()
    }

    func configureMap() {
        //Create camera
        let camera = GMSCameraPosition.camera(withTarget: defaultСoordinate, zoom: defaultZoom)
        //Set camera to map
        mapView.camera = camera
        mapView.mapType = .hybrid
        
        mapView.delegate = self
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
    
    // Check status CLAuthorizationStatus
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            // The user denied authorization
            let alert = UIAlertController(title: "Location Services Off", message: "Turn on Location Services in Settings > Privacy to allow Maps to determine your current location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else if status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways {
            // The user accepted authorization
            print("The user accepted authorization")
        }
    }
    
    @IBAction func goTo(_ sender: UIBarButtonItem) {
        locationManager?.startUpdatingLocation()
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }    
}


extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.map = nil
        return true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myLocation = locations.first else { return }
        let updateCoordinate = myLocation.coordinate
        let camera = GMSCameraPosition(target: updateCoordinate, zoom: defaultZoom)
        
        mapView.animate(to: camera)
        
        let marker = GMSMarker(position: updateCoordinate)
        marker.icon = GMSMarker.markerImage(with: .blue)
        marker.map = mapView
        
        geocoder.reverseGeocodeLocation(myLocation) { place, error in
            print(place?.first as Any)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
