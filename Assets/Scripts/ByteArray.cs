using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ByteArray : MonoBehaviour
{
    MemoryStream ms = new MemoryStream();
    BinaryReader br;
    BinaryWriter wr;

    public ByteArray()
    {
        br = new BinaryReader(ms);
        wr = new BinaryWriter(ms);
    }

    public ByteArray(byte[] buff)
    {
        ms = new MemoryStream(buff);
        br = new BinaryReader(ms);
        wr = new BinaryWriter(ms);
    }

    public bool Readable
    {
        get { return ms.Length > ms.Position; }
    }

    public void Close()
    {

    }

    public int Length
    {
        get { return (int)ms.Position; }
    }

    public int Position
    {
        get { return (int)ms.Position; }
    }

    public byte[] GetBuffer()
    {
        return ms.GetBuffer();
    }

    //--------------read
    public void read(out int value)
    {
        value = br.ReadInt32();
    }

    public void read(out byte value)
    {
        value = br.ReadByte();
    }

    public void read(out byte[] value, int length)
    {
        value = br.ReadBytes(length);
    }

    //-----------------write
    public void write(int value)
    {
        wr.Write(value);
    }

    public void write(byte value)
    {
        wr.Write(value);
    }

    public void write(byte[] value)
    {
        wr.Write(value);
    }
}
