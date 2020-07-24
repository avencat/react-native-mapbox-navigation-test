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
            style={styles.map}
            waypoints={[
              [46.0, 8.0],
              [46.1, 8.0],
            ]}
          />
        )}
      </View>
      <Button title={`${isVisible ? 'Hide' : 'Show'} GPS`} style={{ position: 'absolute', bottom: 50, right: 0 }} onPress={() => setIsVisible(!isVisible)} />
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
