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

var activePlace = 0

var places:[Dictionary<String, String>] = []

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

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
        
        if activePlace == -1 {
            
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else {
        
        
        let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
        let lon = NSString(string: places[activePlace]["lon"]!).doubleValue
        
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
        annotation.title = places[activePlace]["name"]
        myMap.addAnnotation(annotation)
        
        var uilpr = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        uilpr.minimumPressDuration = 2.0
        myMap.addGestureRecognizer(uilpr)
        
        }
        
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
        
        
    }

}
    



