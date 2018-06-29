'use strict';

import {
    NativeModules,
    NativeEventEmitter
} from 'react-native';

const { NativeBridge } = NativeModules;

export default class Bridge {

    constructor(){
        this.eventEmitterManager = new NativeEventEmitter(NativeBridge);
        this.eventListener = this.eventEmitterManager.addListener(
            'sendToJS',
            (data) => this.actionHandler(data));

		NativeBridge.startListening();
    }
    

    sendToNative(key, data = {}){
        NativeBridge.sendToNative({key, data})
    }


    
}