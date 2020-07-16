//
//  RNMapboxNavigation.swift
//  Topicimes
//
//  Created by Axel Vencatareddy on 16/07/2020.
//

import Foundation
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

@objc(RNMapboxNavigation)
class RNMapboxNavigation: NSObject {

  @objc
  func takeMeToWH() {
    // Define two waypoints to travel between
    let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), name: "Mapbox")
    let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), name: "White House")

    // Set options
    let routeOptions = NavigationRouteOptions(waypoints: [origin, destination])

    // Request a route using MapboxDirections
    Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
        switch result {
        case .failure(let error):
            print(error.localizedDescription)
        case .success(let response):
            guard let route = response.routes?.first, let strongSelf = self else {
                return
            }
            // Pass the generated route to the the NavigationViewController
            let viewController = NavigationViewController(for: route, routeOptions: routeOptions)
            viewController.modalPresentationStyle = .fullScreen

            let appDelegate = UIApplication.shared.delegate

            appDelegate!.window!!.rootViewController!.present(viewController, animated: true, completion: nil)
        }
    }
  }

  static func moduleName() -> String! {
        return "RNMapboxNavigation";
  }

  static func requiresMainQueueSetup() -> Bool {
      return true
  }
}
