//
//  ViewController.swift
//  lions
//
//  Created by Администратор on 23/06/2019.
//  Copyright © 2019 Sergey Klimovich. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.delegate = self
            let location = mapView.userLocation
            location.title = "Я здесь"
        } else {
             locationManager.requestAlwaysAuthorization()
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = "Object"
        annotation.subtitle = "First Object"
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(55.37), longitude: 37.61)
        mapView.addAnnotation(annotation as! MKAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let radius = CLLocationDistance(10000)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), latitudinalMeters: radius, longitudinalMeters: radius)
        self.mapView.setRegion(region, animated: false)
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        let image = UIImage(named: "s1200")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            annotationView.image = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.canShowCallout = false
        annotationView.isDraggable = true
        
        return annotationView
        }
    }

}

