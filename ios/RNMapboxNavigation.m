//
//  RNMapboxNavigation.m
//  Topicimes
//
//  Created by Axel Vencatareddy on 16/07/2020.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNMapboxNavigation, NSObject)

RCT_EXTERN_METHOD(takeMeToWH)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
