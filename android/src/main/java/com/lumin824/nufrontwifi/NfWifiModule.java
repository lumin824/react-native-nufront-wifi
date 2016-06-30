package com.lumin824.nufrontwifi;

import android.content.Context;
import android.net.wifi.WifiManager;
import android.net.wifi.WifiInfo;

import android.os.Handler;
import android.os.Message;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;



public class NfWifiModule extends ReactContextBaseJavaModule {

  private WifiManager wifi;

  @Override
  public String getName(){
    return "NfWifiModule";
  }

  public NfWifiModule(ReactApplicationContext reactContext){
    super(reactContext);

    wifi = (WifiManager)reactContext.getSystemService(Context.WIFI_SERVICE);
  }

  @ReactMethod
  public void getSSID(Callback callback){
    WifiInfo info = wifi.getConnectionInfo();

    String ssid = info.getSSID();
    if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
      ssid = ssid.substring(1, ssid.length() - 1);
    }

    callback.invoke(ssid);
  }

  private NfWifiTask task;

  @ReactMethod
  public void startConfig(String ssid, String key, final String code, final Promise promise) throws Exception{

    if(ssid == null) ssid = "";
    if(key == null) key = "";
    if(task != null) stopConfig();

    task = new NfWifiTask(ssid, key);
    task.start(new Handler(){

      @Override
      public void handleMessage(Message msg) {
        String newCode = msg.obj.toString();
        if(code == null || newCode.equals(code)){
          promise.resolve(msg.obj.toString());
          stopConfig();
        }
      }
    });


  }

  @ReactMethod
  public void stopConfig(){
    if(task != null){
      task.stop();
      task = null;
    }
  }

  @Override
  public void onCatalystInstanceDestroy() {
    stopConfig();
  }
}
