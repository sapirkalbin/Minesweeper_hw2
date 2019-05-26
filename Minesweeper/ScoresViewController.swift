//
//  ScoresViewController.swift
//  Minesweeper
//
//  Created by Sapir Kalbin on 08/05/2019.
//  Copyright © 2019 sapir kalbin and eti okonsky. All rights reserved.
//

import MapKit
import UIKit
import Firebase

class ScoresViewController: UIViewController {
    @IBAction func changed(_ sender: UISegmentedControl) {
        if(sender.titleForSegment(at: sender.selectedSegmentIndex) == "Easy")
        {
            print("Easy")
            getScoresByDiff(difficulty: "easy")
        }
        else if (sender.titleForSegment(at: sender.selectedSegmentIndex) == "Normal")
        {
            print("Normal")
            getScoresByDiff(difficulty: "normal")

        }
        else
        {
            print("Hard")
            getScoresByDiff(difficulty: "hard")
        }
        
        //updateTable()
    }
    
    
    var users : Array<String> = Array()
    let mLocationManager = CLLocationManager()
    var ref: DatabaseReference!
    var scoresArray: [Record] = []

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
        ref = Database.database().reference()

        self.mLocationManager.delegate = self
        self.mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationServices()

        
    }
    
    func getScoresByDiff(difficulty: String) {
        ref.child("scores").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            if snapshot.exists() {
                let array:NSArray = snapshot.children.allObjects as NSArray
                
                for child in array {
                    let snap = child as! DataSnapshot
                    if(snap.key as String == difficulty){
                        if snap.value is NSArray {
                            let data:NSArray = snap.value as! NSArray
                            for i in 0...data.count - 1{
                                let dictionary = data[i] as! NSDictionary
                                let nickname: String = dictionary.value(forKey: "name") as! String
                                let score: String = dictionary.value(forKey: "score") as! String
                                
                                self.scoresArray.append(Record(nickname: nickname, score: score, difficulty: difficulty, location:CLLocation()))
                            }
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                if let location = mLocationManager.location?.coordinate {
                    let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
                    locationMap.setRegion(region, animated: true)
                }
                mLocationManager.startUpdatingLocation()
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
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
        recordsList.append(Record(nickname: "s", score: "s", difficulty: "GameDifficulty", location: CLLocation()))
    }
}

extension ScoresViewController: CLLocationManagerDelegate {
    
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
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        locationMap.setRegion(region, animated: true)
        mLocationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to initialize GPS: ", error.description)
    }


}


