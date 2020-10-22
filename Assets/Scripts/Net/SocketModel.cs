using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SocketModel : MonoBehaviour
{
    //一级协议 用于区分所属模块
    public byte type { get; set; }

    //二级协议 用于区分模块下的子模块
    public int area { get; set; }

    //三级协议 用于区分当前处理的逻辑
    public int command { get; set; }

    //消息体 当前需要处理主体数据
    public object msg { get; set; }

    public SocketModel()
    {

    }

    public SocketModel(byte type, int area, int command, object obj)
    {
        this.type = type;
        this.area = area;
        this.command = command;
        this.msg = obj;
    }

    public T GetMsg<T>()
    {
        return (T)msg;
    }
}
