//
//  rightCalloutViewController.swift
//  Memorable Places
//
//  Created by Yosemite on 1/20/15.
//  Copyright (c) 2015 Yosemite. All rights reserved.
//

import UIKit

class rightCalloutViewController: UIViewController {
    
    var mapVC:ViewController!
    
    var pinnedPlace = Place()
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func saveAddress(sender: UIButton) {
        self.mapVC.mySavedPlaceVC.places.append(pinnedPlace)
        // Dismiss current VC when there is navigation controller
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressLabel.text = pinnedPlace.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
