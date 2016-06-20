package com.lumin824.nufrontwifi;

import android.os.Handler;
import android.os.Message;
import android.util.Log;

import java.util.List;

/**
 * Created by lumin on 16/5/29.
 */
public class NfWifiTask {

    private String ssid;
    private String key;
    private NfWifiSocketClient client;
    private NfWifiSocketServer server;

    private Thread clientThread;
    private Thread serverThread;

    private boolean isRunning;

    public NfWifiTask(String ssid, String key) {
        this.ssid = ssid;
        this.key = key;
        this.client = new NfWifiSocketClient();
        this.server = new NfWifiSocketServer(60002);
    }

    public void start(final Handler callback){

        isRunning = true;
        serverThread = new Thread(new Runnable(){
            @Override
            public void run() {
            while(isRunning){
                byte[] receiveAll = server.receiveSpecLenBytes(24);
                if(receiveAll != null && receiveAll[0] == 0x18
                    && receiveAll[8] == 0x06 && receiveAll[9] == 0x00
                    && receiveAll[10] == 0x01){
                    String deviceId = String.format("%02x%02x%02x%02x%02x%02x", receiveAll[11], receiveAll[12], receiveAll[13],
                        receiveAll[14], receiveAll[15], receiveAll[16]);
                    Message msg = callback.obtainMessage();
                    msg.obj = deviceId;
                    callback.sendMessage(msg);
                }
            }
            Log.d("rnwifi", "server thread is stop");
            }
        });
        serverThread.start();

        clientThread = new Thread(new Runnable() {
            @Override
            public void run() {
            NfWifiGenerator generator = new NfWifiGenerator(ssid, key);
            List<byte[]> bytesArray = generator.getBytesArray();
            String target = "239.1.2.110";
            int port = 60001;
            int interval = 1;
            while(isRunning){
                client.sendDataWithBytesArray(bytesArray, target, port, interval);
            }
            Log.d("rnwifi", "client thread is stop");
            }
        });
        clientThread.start();
    }

    public void stop(){
        Log.d("rnwifi", "stop");
        this.isRunning = false;
        if(server != null) server.close();
        if(client != null) client.close();
    }
}
