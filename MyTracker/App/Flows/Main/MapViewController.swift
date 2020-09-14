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
//    private var locationManager: CLLocationManager?
    let locationManager = LocationManager.instance
    private var geocoder = CLGeocoder()
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var prevRoute: GMSPolyline?
    var locationServiceCheck: Bool = false
    
    var usselesExampleVariable = ""

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
        //with Rx:
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                // Обновляем путь у линии маршрута путём повторного присвоения
                self?.route?.path = self?.routePath
                
                // Чтобы наблюдать за движением, установим камеру на только что добавленную точку
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
        }
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.allowsBackgroundLocationUpdates = true
//        locationManager?.pausesLocationUpdatesAutomatically = false
//        locationManager?.startMonitoringSignificantLocationChanges()
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.requestWhenInUseAuthorization()
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
        locationManager.startUpdatingLocation()
        locationServiceCheck = true
    }
    
    @IBAction func stopTapped(_ sender: UIBarButtonItem) {
        locationManager.stopUpdatingLocation()
        locationServiceCheck = false
        writeTrackToDB()
    }
    
    @IBAction func previousTapped(_ sender: UIBarButtonItem) {
        route?.map = nil
        prevRoute?.map = nil
        
        if locationServiceCheck == true {
            
            showMapAlert("Alert","Need to stop route tracking") {
                self.locationManager.stopUpdatingLocation()
                self.loadTrackFromDB()
            }            
        } else {
            loadTrackFromDB()
        }
    }
    
    private func writeTrackToDB() {
        guard let route = routePath else { return }
        var coord: [Coordinate] = []
        for i in 0...route.count() - 1 {
            let tp = Coordinate()
            tp.id = Int(i + 1)
            tp.latitude = route.coordinate(at: i).latitude
            tp.longitude = route.coordinate(at: i).longitude
            coord.append(tp)
        }
        DBManager.instance.removeRouteFromDb()
        DBManager.instance.addRouteToDb(coord)
    }
    
    private func loadTrackFromDB() {
        let coords = DBManager.instance.loadTrackPointArrayFromDb()
        let path = GMSMutablePath()
        for coord in coords {
            path.add(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
        }
        prevRoute = GMSPolyline(path: path)
        prevRoute?.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        prevRoute?.strokeWidth = 8
        prevRoute?.map = mapView
        let bounds = GMSCoordinateBounds(coordinate: path.coordinate(at: 0), coordinate: path.coordinate(at: path.count() - 1))
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))!
        mapView.camera = camera
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
