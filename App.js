/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { useCallback } from 'react'
import {
  Button,
  NativeModules,
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
} from 'react-native';

import {
  Header,
  Colors,
} from 'react-native/Libraries/NewAppScreen';

const App: () => React$Node = () => {
  const launchGPS = useCallback(() => {
    NativeModules.RNMapboxNavigation.takeMeToWH();
  }, [])

  return (
    <View style={styles.container}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView>
        <ScrollView
          contentInsetAdjustmentBehavior="automatic"
          style={styles.scrollView}
        >
          <Header />
          {global.HermesInternal == null ? null : (
            <View style={styles.engine}>
              <Text style={styles.footer}>Engine: Hermes</Text>
            </View>
          )}
          <View style={styles.body}>
            <Button title={'Launch GPS'} onPress={launchGPS} />
          </View>
        </ScrollView>
      </SafeAreaView>
    </View>
  );
};

const styles = StyleSheet.create({
  body: {
    backgroundColor: Colors.dark,
  },

  container: {
    backgroundColor: Colors.dark,
    flex: 1,
  },

  engine: {
    position: 'absolute',
    right: 0,
  },

  footer: {
    color: Colors.lighter,
    fontSize: 12,
    fontWeight: '600',
    padding: 4,
    paddingRight: 12,
    textAlign: 'right',
  },

  scrollView: {
    backgroundColor: Colors.dark,
  },
});

export default App;
