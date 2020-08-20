/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { useState } from 'react';
import {
  Button,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  View,
} from 'react-native';

import {
  Colors,
} from 'react-native/Libraries/NewAppScreen';

import MapView from './MapView';

const App: () => React$Node = () => {
  const [isVisible, setIsVisible] = useState<boolean>(false)

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" />
      <View style={{ backgroundColor: 'red', flex: 1 }}>
        {isVisible && (
          <MapView
            onProgressChange={({ nativeEvent: { currentStep, route, routeProgress, currentStepProgress, nextDirection } }) => {
              const importantInformation = {
                streetName: currentStep.bannerInstructions[0].primary.text,
                distanceToNextManeuver:
                  currentStepProgress.userDistanceToManeuverLocation,
                instruction: currentStep.maneuver.instruction,
                distance: route.distance,
                distanceTraveled: routeProgress.distanceTraveled,
                distanceRemaining: routeProgress.distanceRemaining,
                expectedTravelTime: route.duration,
                durationToNextManeuver: currentStepProgress.durationRemaining,
                routeProgress,
                currentStepProgress,
                nextDirection,
              };

              console.log(importantInformation);
            }}
            shouldSimulateRoute
            style={styles.map}
            waypoints={[
              [38.9131752, -77.0324047],
              [38.8977, -77.0365],
            ]}
          />
        )}
      </View>
      <View style={{ alignItems: 'center', justifyContent: 'center', left: 165, position: 'absolute', top: 400 }}>
        <Button
          title={`${isVisible ? 'Hide' : 'Show'} GPS`}
          onPress={() => setIsVisible(!isVisible)}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: Colors.dark,
    flex: 1,
  },

  map: {
    flex: 1,
  },
});

export default App;
