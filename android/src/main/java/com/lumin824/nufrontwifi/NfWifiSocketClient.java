package com.lumin824.nufrontwifi;

import android.util.Log;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.util.List;

/**
 * Created by lumin on 16/5/29.
 */
public class NfWifiSocketClient {

    private DatagramSocket socket;

    public NfWifiSocketClient() {

        try {
            this.socket = new DatagramSocket();
        } catch (SocketException e) {
            e.printStackTrace();
        }
    }

    public void sendDataWithBytesArray(List<byte[]> bytesArray, String target, int port, int interval) {

        try {
            sendDataWithBytesArray(bytesArray, 0, bytesArray.size(), target, port, interval);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void sendDataWithBytesArray(List<byte[]> bytesArray, int offset, int count, String target, int port, int interval) throws Exception {

        boolean isBroadcast = "255.255.255.255".contentEquals(target);

        if(!socket.isConnected()){
            Log.d("wifisend2","connect");
            socket.connect(new InetSocketAddress(target, port));
        }

        for(int i = offset; i < offset + count; i++){
            byte[] bytes = bytesArray.get(i);

            if(bytes.length == 0) continue;

            StringBuilder sb = new StringBuilder();
            sb.append(String.format("%d-%d:",i, bytes.length));
            for(byte b : bytes) sb.append(String.format("%02x ", b));

            Log.d("wifisend", sb.toString());

            DatagramPacket packet = new DatagramPacket(bytes, bytes.length);
            for(int j = 0; j < 20; j++){
                socket.send(packet);
                Thread.sleep(3);
            }

            Thread.sleep(30);
        }
    }

    public void close(){
        if(socket != null) socket.close();
    }
}
