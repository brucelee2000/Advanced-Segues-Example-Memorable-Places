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
    
    var manager = CLLocationManager()
    
    @IBOutlet weak var myMap: MKMapView!
    
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
            annotation.subtitle = "\(currentPlace.latitude)" + ", " + "\(currentPlace.longitude)"
            
            myMap.addAnnotation(annotation)
            myMap.selectAnnotation(annotation, animated: true)
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
        
        myMap.setCenterCoordinate(currentLocation.coordinate, animated: true)
        myMap.setRegion(region, animated: true)
   
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) in
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
                
                // Remove old annotations with title of "current location"
                var annotationArray = self.myMap.annotations as [MKPointAnnotation]
                for eachAnnotation in annotationArray {
                    if eachAnnotation.title == "Current Location" {
                        self.myMap.removeAnnotation(eachAnnotation)
                    }
                }
                
                // Add new annotation with title of "current location"
                var currentAnnotation = MKPointAnnotation()
                currentAnnotation.coordinate = currentLocation.coordinate
                
                currentAnnotation.title = "Current Location"
                currentAnnotation.subtitle = address
                
                self.myMap.addAnnotation(currentAnnotation)
                
                self.currentPlace = Place()
                self.currentPlace.name = address
                self.currentPlace.latitude = "\(currentLocation.coordinate.latitude)"
                self.currentPlace.longitude = "\(currentLocation.coordinate.longitude)"
 
                // Stop updating location
                self.manager.stopUpdatingLocation()
            }
        })
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

    // Function to implement guesture recognition on the map
    func longPressed(guestureRecog:UIGestureRecognizer) {
        if guestureRecog.state == UIGestureRecognizerState.Began {
            var deselectedAnnotations = myMap.selectedAnnotations
            myMap.removeAnnotations(deselectedAnnotations)
            
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
                    
                    var usrAnnotation = MKPointAnnotation()
                    usrAnnotation.coordinate = usrCoordinate
                    
                    usrAnnotation.title = address
                    usrAnnotation.subtitle = "\(usrCoordinate.latitude)" + ", " + "\(usrCoordinate.longitude)"
                    
                    self.myMap.addAnnotation(usrAnnotation)
                    self.myMap.selectAnnotation(usrAnnotation, animated: true)
                    
                    self.currentPlace = Place()
                    self.currentPlace.name = usrAnnotation.title
                    self.currentPlace.latitude = "\(usrCoordinate.latitude)"
                    self.currentPlace.longitude = "\(usrCoordinate.longitude)"
                    
                    // Add place directly once pinned on the map
                    // self.mySavedPlaceVC.places.append(self.currentPlace)
                }
            })
            

        }
    }
    
    // Implement "viewForAnnotation" delegate method to return an AnnotationView
    // - Customize the elements of annotationView
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            // If annotation is not an MKPointAnnotation (eg. MKUserLocation),
            // return nil so map draws defualt view for it (eg. blue dot)
            return nil
        }
        
        let reuseId = "pin"
        
        // Dequeue an existing AnnotationView first
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            // If an existing AnnotationView was not available, cretea one
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            // Customize the AnnotationView for each kind of annotation
            if annotation.title == "Current Location" {
                pinView!.canShowCallout = true
                pinView!.animatesDrop = false
                pinView!.pinColor = MKPinAnnotationColor.Green
            } else {
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = MKPinAnnotationColor.Red
            }
            
            // Other customization
            // pinView!.image = UIImage(named: "polygon")
            // pinView!.backgroundColor = UIColor.redColor()
            // pinView.calloutOffset = CGPointMake(0, 32)
            
            // Add buttons with customized images to the callout
            var rightButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            rightButton.setImage(UIImage(named: "square"), forState: UIControlState.Normal)
            rightButton.sizeToFit()
            pinView!.rightCalloutAccessoryView = rightButton
            

            var leftButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            leftButton.setImage(UIImage(named: "Star"), forState: UIControlState.Normal)
            leftButton.sizeToFit()
            pinView!.leftCalloutAccessoryView = leftButton
            
            // Add a detail discloure button to the right callout
            //var button = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            
            // Add an image to the left callout
            //var iconView = UIImageView(image: UIImage(named: "Star"))
            //pinView!.leftCalloutAccessoryView = iconView
            
        } else {
            // Re-using an existing AnnotationView by only updating its annotation reference
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Tells the delegate that the user tapped one of the annotation view’s accessory buttons
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //to do
        if control == view.rightCalloutAccessoryView {
            //println("right button clicked")
            performSegueWithIdentifier("rightCalloutClicked", sender: self)
        } else if control == view.leftCalloutAccessoryView {
            //println("left button clicked")
            performSegueWithIdentifier("rightCalloutClicked", sender: self)
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
        } else if segue.identifier == "rightCalloutClicked" {
            // to do
            let rightCalloutVC:rightCalloutViewController = segue.destinationViewController as rightCalloutViewController
            rightCalloutVC.mapVC = self
            rightCalloutVC.pinnedPlace = currentPlace
        }

    }
    
}




