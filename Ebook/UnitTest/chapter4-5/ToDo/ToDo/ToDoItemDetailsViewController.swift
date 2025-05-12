//
//  ToDoItemDetailsViewController.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import UIKit
import MapKit

class ToDoItemDetailsViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var doneButton: UIButton!
    let dateFormatter = DateFormatter()
    var toDoItem: ToDoItem? {
        didSet {
            titleLabel.text = toDoItem?.title
              if let timestamp = toDoItem?.timestamp {
                dateLabel.text = dateFormatter.string(
                  from: Date(timeIntervalSince1970: timestamp))
              }
              locationLabel.text = toDoItem?.location?.name
              descriptionLabel.text = toDoItem?.itemDescription

            
            if let coordinate = toDoItem?.location?.coordinate {
                mapView.setCenter(
                    CLLocationCoordinate2D(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude),
                    animated: false)
            }
            doneButton.isEnabled = (toDoItem?.done == false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
