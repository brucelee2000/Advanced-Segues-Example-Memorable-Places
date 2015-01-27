# Advanced-Segues-Example-Memorable-Places
Hide/Show navigation bar
------------------------
Hide navigation bar to show its own bar on ViewController

        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            // Hide navigation bar from navigation controller in order to show next view's own bar after segue is performed
            self.navigationController?.navigationBarHidden = true
            
            self.performSegueWithIdentifier("findPlaceinMap", sender: indexPath)
        }
        
Data transfer among ViewControllers
-----------------------------------
* **When using navigation bar**

  Navigation controller *automatically* maintains the data transfer between two VCs

* **When using user own navigation bar**

  Navigation controller *cannot* maintain the data transfer, and user has to take care of that

        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            // Get the new view controller using [segue destinationViewController].
            // Pass the selected object to the new view controller
            
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // When using navigation bar, navigation controller automatically maintains the data transfer between two VCs
            // When using user own navigation bar, navigation controller cannot maintain the data transfer, and user has to take care of that
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            if segue.identifier == "addPlace" {
                let mapVC = segue.destinationViewController as ViewController
                mapVC.mySavedPlaceVC = self
                mapVC.addPlace = true
            } else if segue.identifier == "findPlaceinMap" {
                let mapVC = segue.destinationViewController as ViewController
                mapVC.mySavedPlaceVC = self
                
                let indexPath = self.tableView.indexPathForSelectedRow()
                mapVC.currentPlace = places[indexPath!.row]
                mapVC.addPlace = false
                //mapVC.currentPlaceNumber = activePlaceNumber
                //mapVC.currentPlace = places[activePlaceNumber!]
            }
        }
        
Usage of AnnotationView
-----------------------
* **Implement *"viewForAnnotation"* to return an AnnotationView**

* **Customize or condictionally customize annotation appearance such as**

  Show call out and its offset position
  
  Pin drop animation
  
  Pin color
  
  Add button or image

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
                  
                  // Customize the AnnotationView
                  pinView!.canShowCallout = true
                  pinView!.animatesDrop = true
                  pinView!.pinColor = MKPinAnnotationColor.Red
                  // pinView!.image = UIImage(named: "polygon")
                  // pinView!.backgroundColor = UIColor.redColor()
                  // pinView.calloutOffset = CGPointMake(0, 32)
                  
                  // Customize the AnnotationView for each kind of annotation
                  /*
                  if annotation.title == "Current Location" {
                      pinView!.canShowCallout = true
                      pinView!.animatesDrop = false
                      pinView!.pinColor = MKPinAnnotationColor.Green
                  } else {
                      pinView!.canShowCallout = true
                      pinView!.animatesDrop = true
                      pinView!.pinColor = MKPinAnnotationColor.Red
                  }
                  */
                  
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
          
AnnotationView’s accessory buttons tapped
-----------------------------------------

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
