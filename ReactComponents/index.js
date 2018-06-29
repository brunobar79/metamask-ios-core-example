import './shim.js'
import crypto from 'crypto'
require('react-native-browser-polyfill')

import React from 'react';
import {AppRegistry, StyleSheet, View} from 'react-native';
import bg from './ui/app/scripts/background-ios';

//import launchMetamaskUi from './ui'

class MetamaskApp extends React.Component {
  constructor(props){
    super(props)
    this.state = {
        ready: false
    }

  }

  componentDidMount = () => {
    /*launchMetamaskUi({}, ui => {
        this.ui = ui
        this.setState({ready: true});
    })*/
  }
  




  render() {
    return null
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  title: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  }
});

// Module name
AppRegistry.registerComponent('MetamaskApp', () => MetamaskApp);