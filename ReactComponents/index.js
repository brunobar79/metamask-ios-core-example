import './shim.js'
import crypto from 'crypto'

require('react-native-browser-polyfill')

import React from 'react';
import {AppRegistry, StyleSheet, View, Text, ActivityIndicator} from 'react-native';
import initBackground from './core/scripts/background-ios';
import Bridge from './core/bridge'

class MetamaskApp extends React.Component {
  constructor(props){
    super(props)
    this.controller = null;

  }

  componentDidMount = async () => {

    this.controller = await initBackground()

    this.bridge = new Bridge();
    this.bridge.actionHandler = (data) => {
      switch(data.action){
        case 'getCurrentEthRate':
         console.log('[METAMASK]: calling get eth rate');
          this.getCurrentEthRate();
        break;
        default:
          throw new Error('uknown action')
      }
    }
  }
  


  getCurrentEthRate(){
    const API = this.controller.getApi()
    API.setCurrentCurrency('usd', (error, rate) =>{
      this.bridge.sendToNative('currentEthRate', rate)
      console.log('[METAMASK]: POLLING STARTED');

      this.controller.currencyController.scheduleConversionInterval()

      setInterval( _ => {
        const rate = this.controller.currencyController.getConversionRate()
        console.log('[METAMASK]: GOT NEW RATE');

        this.bridge.sendToNative('currentEthRate', {conversionRate: rate})
      }, 5000)
    });
  }


  render() {
    return null
  }
}

// Module name
AppRegistry.registerComponent('MetamaskApp', () => MetamaskApp);