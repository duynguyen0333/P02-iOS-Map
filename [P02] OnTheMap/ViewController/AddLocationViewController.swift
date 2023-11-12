//
//  AddLocation.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController : UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        showLoading(false)
    }
    
    @IBAction func findLocationAction(_ sender: Any) {
        showLoading(true)
        let newLocation = locationTextField.text
        
//        guard let url = URL(string: self.websiteTextField.text!), UIApplication.shared.canOpenURL(url) else {
//            self.showAlert(title: "Invalid URL", message: "Please include 'http://' in your link.")
//            return
//        }
        
        geocodePosition(newLocation: newLocation ?? "")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocation" {
            let studentLocation = sender as? StudentInformationModel
            let vc = segue.destination as! LocationResultViewController
            vc.studentInformation = studentLocation
        }
    }
    
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showLoading(false)
                self.showAlert(title: "Location Not Found", message: error.localizedDescription)
            } else {
                var location: CLLocation?
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                self.showLoading(false)
                if let location = location {
                    self.showNewLocation(location.coordinate)
                } else {
                    self.showAlert(title: "Location Not Found", message: "Please try again later.")
                }
            }
        }
    }
    
    private func showNewLocation(_ location: CLLocationCoordinate2D) {
        let location = StudentInformationModel(firstName: OnTheMapService.Auth.firstName, lastName: OnTheMapService.Auth.lastName, mapString : locationTextField.text!, mediaURL: websiteTextField.text!, uniqueKey: OnTheMapService.Auth.userId, location: location)
        self.performSegue(withIdentifier: "showLocation", sender: location)
    }
    
    private func showLoading(_ showIndicator: Bool) {
        if showIndicator {
            self.indicator.startAnimating()
        } else {
            self.indicator.stopAnimating()
        }
        
        self.indicator.isHidden = !showIndicator
        self.locationTextField.isEnabled = !showIndicator
        self.websiteTextField.isEnabled = !showIndicator
        self.findLocationButton.isEnabled = !showIndicator
    }
}

