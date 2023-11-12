//
//  ListViewController.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation
import UIKit

protocol ListViewControllerDelegate : AnyObject{
    func refreshLocationAction()
}

class ListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate   {
    @IBOutlet weak var tableViewLocation: UITableView!
    var indicator: UIActivityIndicatorView!

    weak var delegate: ListViewControllerDelegate?

    var students = [StudentInformationModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        getStudentsLocation()
//        tableViewLocation.dataSource = self
//        tabelViewLocation.delegate = self
    } 
    
    func getStudentsLocation() {
        self.showLoading(true)
        OnTheMapService.getStudentLocations() {response, error in
            DispatchQueue.main.async {
                self.students = response ?? []
                self.tableViewLocation?.reloadData()
//                self.showLoading(false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let student = students[indexPath.row]
        
        cell.contentView.backgroundColor = UIColor.white
        content.text = "\(String(describing: student.firstName))" + " " + "\(student.mapString )"
        content.secondaryText = "\(student.mediaURL )"
        content.secondaryTextProperties.color = .blue

        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL )
    }

    func setupLayout() {
        indicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.gray)
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.center = self.view.center
        showLoading(true)
        self.tableViewLocation?.backgroundColor = .white
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
