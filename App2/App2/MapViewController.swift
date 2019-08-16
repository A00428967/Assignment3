//
//  MapViewController.swift
//  App2
//
//  Created by cda2019 on 2019-08-07.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var wonderLocation: CLLocation?
    var wonderLocation2: CLLocation?
    var wonderName: String?
    var currentLocation: CLLocation?
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        setupLocationManager()
    }

        // Do any additional setup after loading the view.
    func setupMapView() {
        let coordinate = wonderLocation?.coordinate
        let coordinate2 = wonderLocation2?.coordinate
        if let coordinate = coordinate, let name = wonderName {
            let annotation = MKPointAnnotation()
            annotation.title = name
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            //zoom(annotation.coordinate)
        }
        if let coordinate2 = coordinate2 {
            let annotation = MKPointAnnotation()
            annotation.title = "New Location"
            annotation.coordinate = coordinate2
            mapView.addAnnotation(annotation)
            zoom(annotation.coordinate)
        }
        mapView.showsUserLocation = true
    }
    
    func zoom(_ location: CLLocationCoordinate2D) {
        let radius = 1000
        let region = MKCoordinateRegion(center: location, latitudinalMeters: CLLocationDistance(Double(radius) * 2.0), longitudinalMeters: CLLocationDistance(Double(radius) * 2.0))
        mapView.setRegion(region, animated: true)
    }
    
    func setupLocationManager() {
        if CLLocationManager.authorizationStatus() == .notDetermined{
            manager.requestWhenInUseAuthorization()
        }
        
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.delegate = self
        manager.stopUpdatingLocation()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        
        
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusePin")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        view.pinTintColor = UIColor.red
        if annotation.title == "New Location" {
            view.pinTintColor = UIColor.green
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        if let coordinate = view.annotation?.coordinate {
            let mapItem = location?.mapItem(coordinate: coordinate)
            mapItem?.openInMaps(launchOptions: launchingOptions)
        }
    }
}


extension MKAnnotation {
    func mapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        return mapItem
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation = location
        updateLocation(location)
    }
    
    private func updateLocation(_ currentLocation: CLLocation){
        self.currentLocation = currentLocation
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


