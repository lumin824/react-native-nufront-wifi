import {
  NativeModules
} from 'react-native';

let { NfWifiModule } = NativeModules;

export var startConfig = NfWifiModule.startConfig

export var stopConfig = NfWifiModule.stopConfig

export var getSSID = NfWifiModule.getSSID;
