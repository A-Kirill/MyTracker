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
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?

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
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
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
        // Unlinking the old line from the map
        route?.map = nil
        // Replace the old line with a new one
        route = GMSPolyline()
        // Replace the old path with a new one, while empty (no points)
        routePath = GMSMutablePath()
        route?.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        route?.strokeWidth = 8
        // Add a new line to the map
        route?.map = mapView
        // Start tracking or continue if it is already running
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
        
        // Take the last point from the resulting set
        guard let location = locations.last else { return }
        // Add it to the route path
        routePath?.add(location.coordinate)
        // Updating the path along the route line by reassigning
        route?.path = routePath
        
        // To see the movement, set the camera to the point we just added
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: defaultZoom)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
