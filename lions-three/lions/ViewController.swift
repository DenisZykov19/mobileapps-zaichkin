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
import RealmSwift

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let realm = try! Realm()
    
    
    struct Dost {
        var title: String?
        var coord: CLLocationCoordinate2D
    }
    
    var arrDost = [Dost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        arrDost.append(Dost(title: "kjsfdjkdf", coord: CLLocationCoordinate2D(latitude: 55.44, longitude: 53.66)))
        
        let artObject = Art()
        artObject.id = 1
        artObject.title = "Firest"
        artObject.latitude = 55.05
        artObject.longitude = 37.50
        
        try! realm.write {
            realm.add(artObject, update: .modified)
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
//        mapView.showsCompass = true
        mapView.showsScale = true
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            let location = mapView.userLocation
            location.title = "Я здесь"
        } else {
             locationManager.requestAlwaysAuthorization()
        }
        
        let source = CLLocationCoordinate2D(latitude: 55.77, longitude: 37.00)
        let destination = CLLocationCoordinate2D(latitude: 55.00, longitude: 37.55)
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            self.mapView.removeOverlays(self.mapView.overlays)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        do {
            let artArray = try realm.objects(Art.self)
            let lat = artArray[0].latitude
            for dostSelf in  artArray {
                
                let annotation = MKPointAnnotation()
                annotation.title = dostSelf.title
                annotation.coordinate = CLLocationCoordinate2D(latitude: dostSelf.latitude, longitude: dostSelf.longitude)
                
                
                mapView.addAnnotation(annotation as! MKAnnotation)
            }
        } catch  {
           print(error.localizedDescription)
        }
        
        
        

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
            
            
            let xib = Bundle.main.loadNibNamed("AnnotationXibView", owner: self, options: nil)?.first as! AnnotationXibView
            xib.image.image = UIImage(named: "icons8-sculpture-filled-50")
            xib.label.text = "My first Object"
            annotationView.addSubview(xib)
            
//        let image = UIImage(named: "s1200")
//            let size = CGSize(width: 50, height: 50)
//            UIGraphicsBeginImageContext(size)
//            image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//
//            annotationView.image = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.canShowCallout = false
        annotationView.isDraggable = true
        
        return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.lineWidth = 4.0
        return render

    }
    
    
}

