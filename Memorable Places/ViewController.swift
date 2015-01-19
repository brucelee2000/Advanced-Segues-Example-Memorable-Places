//
//  ViewController.swift
//  Memorable Places
//
//  Created by Yosemite on 1/17/15.
//  Copyright (c) 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var mySavedPlaceVC:TableViewController!
    
    var currentPlace = Place()
    
    var addPlace:Bool = true
    
    @IBOutlet weak var myMap: MKMapView!
    
    var manager = CLLocationManager()
    
    @IBAction func findMe(sender: UIBarButtonItem) {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // When the view is jumped from adding places
        if addPlace {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            // When the view is jumped from cell selection
            let lat = NSString(string: currentPlace.latitude).doubleValue
            let lon = NSString(string: currentPlace.longitude).doubleValue
        
            var latitude:CLLocationDegrees = lat
            var longtitude:CLLocationDegrees = lon
            var latDelta:CLLocationDegrees = 0.02
            var lonDelta:CLLocationDegrees = 0.02
        
            var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
            var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
            myMap.setRegion(region, animated: true)
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = currentPlace.name
            
            myMap.addAnnotation(annotation)
            myMap.selectAnnotation(annotation, animated: false)
        }
        
        // Add gesture recognition to the map
        var uilpr = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        uilpr.minimumPressDuration = 2.0
        myMap.addGestureRecognizer(uilpr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLocation:CLLocation = locations[0] as CLLocation
        
        var latDelta:CLLocationDegrees = 0.02
        var lonDelta:CLLocationDegrees = 0.02
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocation.coordinate, span)
        
        myMap.setRegion(region, animated: true)
        
        // Stop updating location
        manager.stopUpdatingLocation()
        
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }


    override func viewWillDisappear(animated: Bool) {
        // Hide navigation bar from navigation controller in order to show next view's own bar after segue is performed
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true

    }

    func longPressed(guestureRecog:UIGestureRecognizer) {
        if guestureRecog.state == UIGestureRecognizerState.Began {
            var touchPoint = guestureRecog.locationInView(self.myMap)
            var usrCoordinate:CLLocationCoordinate2D = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
            var usrLocation = CLLocation(latitude: usrCoordinate.latitude, longitude: usrCoordinate.longitude)

            var geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(usrLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    println(error)
                } else {
                    // Create a constant from variable
                    let p = CLPlacemark(placemark: placemarks[0] as CLPlacemark)
                    // Get the address
                    var subThoroughfare = p.subThoroughfare ?? ""
                    var thoroughfare = p.thoroughfare ?? ""
                    var subLocality = p.subLocality ?? ""
                    var locality = p.locality ?? ""
                    var subAdministrativeArea = p.subAdministrativeArea ?? ""
                    var administrativeArea = p.administrativeArea ?? ""
                    var postalCode = p.postalCode ?? ""
                    var country = p.country ?? ""
                    
                    var address = "\(subThoroughfare) \(thoroughfare)\n\(subAdministrativeArea), \(administrativeArea) \(postalCode)\n\(country)"
                    println(address)
                    
                    var usrAnnotation = MKPointAnnotation()
                    usrAnnotation.coordinate = usrCoordinate
                    
                    usrAnnotation.title = address
                    
                    self.myMap.addAnnotation(usrAnnotation)
                    self.myMap.selectAnnotation(usrAnnotation, animated: true)
                    
                    var selectedPlace = Place()
                    selectedPlace.name = usrAnnotation.title
                    selectedPlace.latitude = "\(usrCoordinate.latitude)"
                    selectedPlace.longitude = "\(usrCoordinate.longitude)"
                    
                    self.mySavedPlaceVC.places.append(selectedPlace)
                }
            })
            

        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // When using navigation bar, navigation controller automatically maintains the data transfer between two VCs
        // When using user own navigation bar, navigation controller cannot maintain the data transfer, and user has to take care of that
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if segue.identifier == "backToTableView" {
            let targetVC:TableViewController = segue.destinationViewController as TableViewController
            targetVC.places = self.mySavedPlaceVC.places
        }

    }
    
}




