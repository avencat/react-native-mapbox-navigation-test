//
//  RNMapboxNavigationManager.swift
//  Topicimes
//
//  Created by Axel Vencatareddy on 17/07/2020.
//

@objc(RNMapboxNavigationManager)
class RNMapboxNavigationManager: RCTViewManager {
  override func view() -> UIView! {
    return RNMapboxNavigationView();
  }

  override static func moduleName() -> String! {
        return "RNMapboxNavigation";
  }

  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
