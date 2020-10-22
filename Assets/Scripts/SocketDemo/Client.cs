using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using UnityEngine;

public class Client
{
    public Action<String> callback;
    Socket socket;
    byte[] receiveBuffer = new byte[1024];

    void Start ()
    {
        
    }

    public void StartConnect(string ipStr, int port)
    {
        if (socket != null) return;
        IPAddress ip = IPAddress.Parse(ipStr);
        IPEndPoint point = new IPEndPoint(ip, port);
        socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        socket.BeginConnect(point, new System.AsyncCallback(OnConnected), socket);
    }

	void OnConnected(IAsyncResult ar)
    {
        Debug.Log("连接服务器成功");
        Socket socket = ar.AsyncState as Socket;
        socket.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, Receive, socket);
    }

    void Receive(IAsyncResult ar)
    {
        //获取正在工作的Socket对象
        Socket socket = ar.AsyncState as Socket;
        int length = 0;

        try
        {
            //接收完毕消息后的字节数
            length = socket.EndReceive(ar);
        }
        catch (System.Exception ex)
        {
            Debug.Log(ex.ToString());
        }
        if (length > 0)
        {
            string content = Encoding.Default.GetString(receiveBuffer);
            Debug.Log(":::::" + content);
            callback(content);
            receiveBuffer = new byte[1024];
        }
        //继续异步等待客户端的发送消息请求
        socket.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, new System.AsyncCallback(Receive), socket);
    }

    public void SendMsg(string message)
    {
        if (message == null)
            return;
        byte[] sendData = Encoding.UTF8.GetBytes(message);

        socket.Send(sendData, SocketFlags.None);
    }
}
