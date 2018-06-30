# metamask-ios-core-example

This is a working proof of concept of the [MetamaskController](https://github.com/MetaMask/metamask-extension/blob/develop/app/scripts/metamask-controller.js) (core of [metamask](https://github.com/MetaMask/metamask-extension/)) running inside a Native iOS App using  through React Native 

This prototype uses NSNotifications to send data from Native to JS and viceversa through the [NativeBridge](https://github.com/brunobar79/metamask-ios-core-example/blob/master/metamask-ios/NativeBridge.m) which makes use of [RCTBridgeModule](https://facebook.github.io/react-native/docs/native-modules-ios.html) and  [RCTEventEmitter](https://facebook.github.io/react-native/docs/native-modules-ios.html#sending-events-to-javascript).

Check out [WalletViewController.m](https://github.com/brunobar79/metamask-ios-core-example/blob/master/metamask-ios/WalletViewController.m#L25) to see how this is implemented  from the native iOS side.

Check out [ReactComponents/index.js](https://github.com/brunobar79/metamask-ios-core-example/blob/master/ReactComponents/index.js) to see how this is being used on the JS side to make fwd the requests to the MetamaskController.


