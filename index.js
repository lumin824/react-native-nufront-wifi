import {
  NativeModules
} from 'react-native';

let { NfWifiModule } = NativeModules;

export var startConfig = () => {
  console.log('startConfig');
};

export var stopConfig = () => {
  console.log('stopConfig');
};

export var getSSID = NfWifiModule.getSSID;
