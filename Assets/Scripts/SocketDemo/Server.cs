using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using UnityEngine;

public class Server
{
    public Action<String> callback;
    Socket serverSocket;
    //服务器端收到消息的存储空间
    byte[] receiveBuffer = new byte[1024];
    private List<Socket> clientList = new List<Socket>();

    public void StartServer(string ipStr, int port)
    {
        if (serverSocket != null) return;
        IPAddress ip = IPAddress.Parse(ipStr);
        IPEndPoint point = new IPEndPoint(ip, port);
        serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        serverSocket.Bind(point);
        //监听客户端连接，10代表最多连接10个
        serverSocket.Listen(10);

        /*
         * 执行socket.Accept()的时候，程序被阻塞，
         * 在这个地方等待，直到有新的联检请求的时候程序才会执行下一句。这是同步执行。
         * 为了避免阻塞，可以采用异步执行返方案。
         */
        //server.Accept();

        //启动异步Accept
        serverSocket.BeginAccept(Accept, serverSocket);
    }

    void Accept(IAsyncResult ar)
    {
        //获取正在工作的Socket对象
        Socket socket = ar.AsyncState as Socket;
        //结束异步Accept并获已连接的Socket
        Socket client = socket.EndAccept(ar);

        //开始异步接收客户端发送消息内容
        client.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, new System.AsyncCallback(Receive), client);
        clientList.Add(client);

        //继续异步Accept，保持Accept一直开启！
        socket.BeginAccept(Accept, socket);
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
            Debug.Log(content);
            callback(content);
            receiveBuffer = new byte[1024];
        }
        //继续异步等待客户端的发送消息请求
        socket.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, new System.AsyncCallback(Receive), socket);
    }

    public void broadcastMsg(string message)
    {
        if (message == null)
            return;
        byte[] sendData = Encoding.UTF8.GetBytes(message);
        foreach (Socket client in clientList)
        {
            client.Send(sendData, SocketFlags.None);
        }
    }
}
