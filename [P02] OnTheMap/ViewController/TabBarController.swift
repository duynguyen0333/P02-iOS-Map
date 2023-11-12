//
//  TabBarController.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, MapViewControllerDeledate, ListViewControllerDelegate {
    override func viewDidLoad() {
        customHeader()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func customHeader(){
        self.navigationItem.title = "On The Map"

        let mappinImageButton = UIButton(type: .custom)
        let powerImageButton = UIButton(type: .custom)
        let refreshImageButton = UIButton(type: .custom)
        
        mappinImageButton.setImage(UIImage(systemName: "mappin"), for: .normal)
        powerImageButton.setImage(UIImage(systemName: "power"), for: .normal)
        refreshImageButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        
        let mappinBarButtonItem = UIBarButtonItem(customView: mappinImageButton)
        let refreshBarButtonItem = UIBarButtonItem(customView: refreshImageButton)
        let powerBarButtonItem = UIBarButtonItem(customView: powerImageButton)
        
        self.navigationItem.rightBarButtonItems = [powerBarButtonItem]
        self.navigationItem.leftBarButtonItems = [mappinBarButtonItem, refreshBarButtonItem]
        
        mappinImageButton.addTarget(self, action: #selector(addLocationButtonAction), for: .touchUpInside)
        powerImageButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        refreshImageButton.addTarget(self, action: #selector(refreshLocationAction), for: .touchUpInside)

    }
    
    @objc func refreshLocationAction() {
        let mapLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let studentLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        
//        mapLocationVC.showLoading(true)
//        studentLocationVC.showLoading(true)
        mapLocationVC.getLocationPins()
        studentLocationVC.getStudentsLocation()
        
        
    }
    
    @objc func addLocationButtonAction() {
        let addLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController

        addLocationVC.modalPresentationStyle = .pageSheet
        self.present(addLocationVC, animated: true)
    }
    
    @objc func logoutButtonAction() {
        OnTheMapService.logout { response, error in
            self.navigationController?.popViewController(animated: true)
        }
    }
}
