//
//  Extensions.swift
//  [P02] OnTheMap
//
//  Created by aia on 07/11/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String,message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
        
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(title: "Invalid Link", message: "Cannot open link.")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}
