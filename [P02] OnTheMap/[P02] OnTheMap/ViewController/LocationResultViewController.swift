//
//  LocationResultViewController.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation
import UIKit
import MapKit

class LocationResultViewController : UIViewController { 
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var studentInformation: StudentInformationModel?
    let annotation = MKPointAnnotation()

    override func viewDidLoad() {
        showLoading(false)
        annotation.title = "\(studentInformation?.firstName ?? "")" + " " + "\(studentInformation?.lastName ?? "")"
        annotation.subtitle = studentInformation?.mediaURL
        annotation.coordinate = CLLocationCoordinate2D(latitude: studentInformation?.latitude ?? 0.0, longitude: studentInformation?.longitude ?? 0.0)

        mapView.setCenter(CLLocationCoordinate2D(latitude: studentInformation?.latitude ?? 0.0, longitude: studentInformation?.longitude ?? 0.0), animated: false)
        mapView.addAnnotation(annotation)
        mapView.delegate = self
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        showLoading(true)
        if let studentLocation = studentInformation {
            OnTheMapService.postStudentLocation(studentLocation: studentLocation) { (success, error) in
                self.showLoading(false)
                if success {
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Cannot save location")
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func showLocations(location: StudentInformationModel?) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            annotation.title = "\(location?.firstName ?? "")" + " " + "\(location?.lastName ?? "")"
            annotation.subtitle = location?.mediaURL
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: StudentInformationModel?) -> CLLocationCoordinate2D? {
        if let lat = location?.latitude, let lon = location?.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
}

extension LocationResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "PinView"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.tintColor = .red
            pinView!.isDraggable = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let mediaUrl = view.annotation?.subtitle {
            openLink(mediaUrl ?? "")
        }
    }
    
    private func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) -> StudentInformationModel {
        return StudentInformationModel(firstName: OnTheMapService.Auth.firstName, lastName: OnTheMapService.Auth.lastName, mapString: studentInformation?.mapString ?? "", mediaURL: studentInformation?.mediaURL ?? "", uniqueKey: studentInformation!.uniqueKey, location: view.annotation!.coordinate)
    }
    
    private func showLoading(_ showIndicator: Bool) {
        if showIndicator {
            self.indicator.startAnimating()
        } else {
            self.indicator.stopAnimating()
        }
        self.indicator.isHidden = !showIndicator
    }
}


