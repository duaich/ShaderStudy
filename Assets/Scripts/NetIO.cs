using System;
using System.Net.Sockets;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class NetIO : MonoBehaviour
{
    public static NetIO instance;

    private Socket socket;
    private string ip = "127.0.0.1";
    private int port = 5566;

    private byte[] readBuff = new byte[1024];
    List<byte> cache = new List<byte>();
    List<SocketModel> msgList = new List<SocketModel>();

    bool isReading;

    private NetIO()
    {
        try
        {
            //创建客户端连接
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.Connect(ip, port);
            //开启异步消息接收，消息到大后直接写入缓存区
            socket.BeginReceive(readBuff, 0, 1024, SocketFlags.None, ReceiveCallBack, readBuff);
        } catch (Exception e)
        {
            Debug.Log(e.Message);
        }
    }

    public void ReceiveCallBack(IAsyncResult data)
    {
        try
        {
            //消息长度
            int length = socket.EndReceive(data);
            byte[] msg = new byte[length];

            Buffer.BlockCopy(readBuff, 0, msg, 0, length);
            cache.AddRange(msg);

            if (!isReading)
            {
                isReading = true;
                ParseData();
            }
            //尾递归，再次开启异步消息接收
            socket.BeginReceive(readBuff, 0, 1024, SocketFlags.None, ReceiveCallBack, readBuff);
        } catch (Exception e)
        {
            Debug.Log("远程服务器断开连接：" + e.Message);
        }
    }

    public void ParseData()
    {
        //有数据的话就调用长度解码
        byte[] result = Decode(ref cache);

        if (result == null)
        {
            isReading = false;
            return;
        }

        //消息体解码
        SocketModel msg = MDecode(result);

        //将消息体存储，等待调用
        if (msg == null)
        {
            isReading = false;
            return;
        }
        msgList.Add(msg);

        //尾递归，防止在消息处理过程中，有其他消息过来
        ParseData();
    }

    //消息体长度解码
    private byte[] Decode(ref List<byte> cache)
    {
        MemoryStream ms = new MemoryStream(cache.ToArray());
        BinaryReader br = new BinaryReader(ms);
        int length = br.ReadInt32();
        //如果消息体的长度大于内存流中消息体的长度（ms.Length - ms.Position），说明还没有读取完
        if (length > ms.Length - ms.Position)
        {
            return null;
        }
        byte[] result = br.ReadBytes(length);

        cache.Clear();

        cache.AddRange(br.ReadBytes((int)(ms.Length - ms.Position)));
        br.Close();
        ms.Close();

        return result;
    }

    //消息体解码
    private SocketModel MDecode(byte[] data)
    {
        ByteArray ba = new ByteArray(data);
        SocketModel model = new SocketModel();
        byte type;
        int area;
        int command;
        ba.read(out type);
        ba.read(out area);
        ba.read(out command);

        model.type = type;
        model.area = area;
        model.command = command;

        if (ba.Readable)
        {
            byte[] msg;
            ba.read(out msg, ba.Length - ba.Position);
            //反序列化
            model.msg = SeriaLiseUtil.Decode(msg);

            ba.Close();
        }
        
        return model;
    }

    //发送消息
    public void write(byte type, int area, int command, object msg)
    {
        ByteArray ba = new ByteArray();
        ba.write(type);
        ba.write(area);
        ba.write(command);
        if (msg != null)
        {
            ba.write(SeriaLiseUtil.Encode(msg));
        }

        //长度编码
        ByteArray data = new ByteArray();
        data.write(ba.Length);
        data.write(ba.GetBuffer());

        //发送
        try
        {
            socket.Send(data.GetBuffer());
        } catch (Exception e)
        {
            Debug.Log("网络错误：" + e.Message);
        }
    }

    public static NetIO Instance
    {
        get
        {
            if (instance == null)
            {
                instance = new NetIO();
            }
            return instance;
        }
    }
}
