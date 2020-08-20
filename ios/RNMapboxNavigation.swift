//
//  RNMapboxNavigation.swift
//  Topicimes
//
//  Created by Axel Vencatareddy on 16/07/2020.
//
//
//  RNMapboxNavigation.swift
//  Topicimes
//
//  Created by Axel Vencatareddy on 16/07/2020.
//

import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}

class RNMapboxNavigationView: UIView, NavigationViewControllerDelegate {
  var voiceController: CustomVoiceController?

  @objc var waypoints: [[NSNumber]] = [] {
    didSet { startNavigation() }
  }

  @objc var shouldSimulateRoute: Bool = false

  @objc var isMuted: Bool = false {
    didSet {
      guard voiceController != nil else { return }
      voiceController?.isMuted = isMuted
    }
  }

  @objc var onProgressChange: RCTDirectEventBlock?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startNavigation() {
    var allWaypoints: [Waypoint] = []

    for waypoint in waypoints {
      guard (waypoint).count == 2 else { return }
      allWaypoints.append(Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoint[0] as! CLLocationDegrees, longitude: waypoint[1] as! CLLocationDegrees)))
    }

    let options = NavigationRouteOptions(waypoints: allWaypoints, profileIdentifier: .walking)
    Directions.shared.calculate(options) { [weak self] (session, result) in
      switch result {
        case .failure(let error):
            print(error.localizedDescription)
        case .success(let response):
          guard let route = response.routes?.first, let _ = self else { return }

            let navigationService = MapboxNavigationService(route: route, routeOptions: options, simulating: self!.shouldSimulateRoute ? .always : .onPoorGPS)

            self!.voiceController = CustomVoiceController(navigationService: navigationService)
            self!.voiceController?.isMuted = self!.isMuted

            let navigationOptions = NavigationOptions(navigationService: navigationService, voiceController: self!.voiceController)
            let navigationViewController = NavigationViewController(for: route, routeOptions: options, navigationOptions: navigationOptions)
            navigationViewController.delegate = self

            let view = navigationViewController.view!
            view.frame = self!.frame
            view.bounds = self!.bounds

            self?.addSubview(view)
      }
    }
  }

  func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
    let currentStepProgress = progress.currentLegProgress.currentStepProgress
    let currentStepDictionnary: Dictionary<String, Any>
    do {
        currentStepDictionnary = try progress.currentLegProgress.currentStep.asDictionary()
    } catch let error {
        print(error)
        return
    }
    let routeDictionnary: Dictionary<String, Any>
    do {
        routeDictionnary = try progress.route.asDictionary()
    } catch let error {
        print(error)
        return
    }

    onProgressChange?([
      "longitude": location.coordinate.longitude,
      "latitude": location.coordinate.latitude,
      "currentStepProgress": [
        "distanceTraveled": currentStepProgress.distanceTraveled,
        "userDistanceToManeuverLocation": currentStepProgress.userDistanceToManeuverLocation,
        "distanceRemaining": currentStepProgress.distanceRemaining,
        "fractionTraveled": currentStepProgress.fractionTraveled,
        "durationRemaining": currentStepProgress.durationRemaining],
      "currentStep": currentStepDictionnary,
      "route": routeDictionnary,
      "routeProgress": [
        "isFinalLeg": progress.isFinalLeg,
        "distanceTraveled": progress.distanceTraveled,
        "distanceRemaining": progress.distanceRemaining,
        "durationRemaining": progress.durationRemaining,
        "fractionTraveled": progress.fractionTraveled,
      ],
      "nextDirection": [
        "direction": currentStepProgress.step.maneuverDirection?.rawValue,
        "type": currentStepProgress.step.maneuverType.rawValue,
      ],
    ])
  }
}

class CustomVoiceController: MapboxVoiceController {
  var isMuted = false

  override func didPassSpokenInstructionPoint(notification: NSNotification) {
    if isMuted == false {
      super.didPassSpokenInstructionPoint(notification: notification)
    }
  }
}
