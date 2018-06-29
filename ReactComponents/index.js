import './shim.js'
import crypto from 'crypto'
require('react-native-browser-polyfill')

import React from 'react';
import {AppRegistry, StyleSheet, View, Text, ActivityIndicator} from 'react-native';
import initBackground from './core/scripts/background-ios';


class MetamaskApp extends React.Component {
  constructor(props){
    super(props)
    this.state = {
        ready: false,
        rate: false
    }

    this.controller = null;

  }

  componentDidMount = async () => {

    this.controller = await initBackground()

    const API = this.controller.getApi()
    API.setCurrentCurrency('usd', (error, data) =>{
      console.log("ERROR IS: ", error);
      console.log("RATE IS: ", data);
      this.setState({
         rate: data.conversionRate
      })
    });

    console.log('POLLING STARTED');

    this.controller.currencyController.scheduleConversionInterval()

    setInterval( _ => {
      const rate = this.controller.currencyController.getConversionRate()
      this.setState({rate})
      console.log('POLLING UPDATED', rate);
    }, 5000)
    
  }
  



  render() {
    if(this.state.rate === false){
      return <View style={styles.container}><ActivityIndicator loading={true} /></View>
    }
    return <View style={styles.container}><Text style={styles.title}>Conversion Rate: {this.state.rate}</Text></View>
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