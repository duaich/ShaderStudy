using System.Collections;
using System.IO;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.Serialization.Formatters.Binary;
using System;

public class SeriaLiseUtil : MonoBehaviour
{
    /// <summary>
    /// 对象序列化
    /// </summary>
    public static byte[] Encode(object value)
    {
        //创建编码解码的内存流对象，并将需要序列化的数据写入其中
        MemoryStream ms = new MemoryStream();
        //二进制序列化对象
        BinaryFormatter binary = new BinaryFormatter();
        binary.Serialize(ms, value);
        byte[] result = new byte[ms.Length];
        //将数据流拷贝到结果数组
        Buffer.BlockCopy(ms.GetBuffer(), 0, result, 0, (int)ms.Length);
        ms.Close();
        return result;
    }

    /// <summary>
    /// 反序列化对象
    /// </summary>
    public static object Decode(byte[] value)
    {
        //创建编码解码的内存流对象，并将需要反序列化的数据写入其中
        MemoryStream ms = new MemoryStream(value);
        //二进制序列化对象
        BinaryFormatter binary = new BinaryFormatter();
        //将数据流反序列化为object对象
        object obj = binary.Deserialize(ms);
        ms.Close();
        return obj;
    }
}
