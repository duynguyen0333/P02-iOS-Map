//
//  MapViewController.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation
import UIKit
import MapKit

protocol MapViewControllerDeledate: AnyObject {
    func refreshLocationAction()
}

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var locations = [StudentInformationModel]()
    var annotations = [MKPointAnnotation]()
    
    weak var delegate: MapViewControllerDeledate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationPins()
    }
    
    func getLocationPins() {
        self.showLoading(true)
        OnTheMapService.getStudentLocations { locations, error in
            self.showLoading(false)
            for location in locations ?? [] {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude ?? 0.0, longitude: location.longitude ?? 0.0)
                annotation.title = "\(location.firstName ?? "") " + "\(location.lastName ?? "")"
                annotation.subtitle = location.mediaURL
                self.annotations.append(annotation)
            }
            self.mapView?.addAnnotations(self.annotations)

        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reusePin = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePin) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaUrl = view.annotation?.subtitle! {
                openLink(mediaUrl)
            }
        }
    }
    
    func showLoading(_ showIndicator: Bool) {
        if showIndicator {
            self.indicator?.startAnimating()
        } else {
            self.indicator?.stopAnimating()
        }
        
        self.indicator?.isHidden = !showIndicator
    }
}
