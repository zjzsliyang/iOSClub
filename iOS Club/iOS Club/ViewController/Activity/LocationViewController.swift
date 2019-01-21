//
//  LocationViewController.swift
//  Student Club
//
//  Created by Yang Li on 2019/1/21.
//  Copyright © 2019 Yang LI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchResultsUpdating, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var searchController: UISearchController!
    var candidatePlaces = [CLPlacemark]()
    let pin = MKPointAnnotation()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "event location"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(addPin(gesture:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func addPin(gesture: UITapGestureRecognizer) {
        let coordinate = mapView.convert(gesture.location(in: mapView), toCoordinateFrom: mapView)
        self.pin.coordinate = coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        lookUpCurrentLocation(location: location) { (place) in
            if place != nil {
                self.candidatePlaces = []
                self.candidatePlaces.append(place!)
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            self.pin.coordinate = center
            mapView.addAnnotation(pin)
            if let lastLocation = self.locationManager.location {
                lookUpCurrentLocation(location: lastLocation) { (place) in
                    if place != nil {
                        self.candidatePlaces = []
                        self.candidatePlaces.append(place!)
                        self.tableView.reloadData()
                        self.locationManager.stopUpdatingLocation()
                    }
                }
            } else {
                log.error("get location error")
            }
        }
    }
    
    func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            } else { completionHandler(nil) }
        })
    }
    
    func lookUpNearbyLocation(location: CLLocation) {

    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidatePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = candidatePlaces[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "place")!
        cell.textLabel?.text = place.name
        cell.detailTextLabel!.text = place.thoroughfare
        return cell
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
