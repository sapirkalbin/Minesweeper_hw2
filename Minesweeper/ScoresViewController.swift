//
//  ScoresViewController.swift
//  Minesweeper
//
//  Created by Sapir Kalbin on 08/05/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import MapKit
import UIKit

class ScoresViewController: UIViewController, CLLocationManagerDelegate {
    var users : Array<String> = Array()
    let mLocationManager = CLLocationManager()

    @IBOutlet weak var locationMap: MKMapView!
    @IBAction func retry(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.present(detailsViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var chooser: UISegmentedControl!
    
    
    @IBAction func difficultyChanged(_ sender: Any) {
        
    }
    var recordsList = [Record]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if (CLLocationManager.locationServicesEnabled())
        {
            mLocationManager.delegate = self
            
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                mLocationManager.startUpdatingLocation()
            } else {
                mLocationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func getAllScores()
    {
        recordsList.append(Record(nickname: "s", score: "s", difficulty: "GameDifficulty", location: "String"))
    }

    

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            mLocationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegion.init()//location.coordinate, 500, 500)
        locationMap.setRegion(coordinateRegion, animated: true)
        mLocationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to initialize GPS: ", error.description)
    }


}

