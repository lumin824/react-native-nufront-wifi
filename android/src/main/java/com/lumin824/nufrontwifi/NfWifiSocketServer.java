package com.lumin824.nufrontwifi;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;

/**
 * Created by lumin on 16/5/29.
 */
public class NfWifiSocketServer {

    private DatagramSocket socket;

    public NfWifiSocketServer(int port) {
        try {
            this.socket = new DatagramSocket(port);
        } catch (SocketException e) {
            e.printStackTrace();
        }

    }

    public byte[] receiveSpecLenBytes(int len) {

        byte data[] = new byte[len];

        DatagramPacket packet= new DatagramPacket(data , data.length);
        try {
            socket.receive(packet);
            return data;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void close(){
        if(socket != null) socket.close();
    }
}
