using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Text;

public class SocketDemo : MonoBehaviour
{
    [SerializeField]
    private string ip = "127.0.0.1";
    [SerializeField]
    private int port = 5566;
    [SerializeField]
    private InputField clientInputTxt;
    [SerializeField]
    private InputField serverInputTxt;
    [SerializeField]
    private Text serverContentTxt;
    [SerializeField]
    private Text clientContentTxt;
    private Server server;
    private Client client;
    private List<string> fromClientStrList = new List<string>();
    private List<string> fromServerStrList = new List<string>();
    private string fromServerStr = "";

    void Start ()
    {
        server = new Server();
        client = new Client();
        server.callback += MsgFromClient;
        client.callback += MsgFromServer;
    }
	
	void Update ()
    {
        //serverContentTxt.text = fromClientStr.ToString();
        //clientContentTxt.text = fromServerStr.ToString();
        string str = "";
        foreach (string temStr in fromClientStrList)
        {
            str += temStr + "\n";
        }
        serverContentTxt.text = str;

        str = "";
        //Debug.Log("---------------count:" + fromServerStrList.Count);
        foreach (string temStr in fromServerStrList)
        {
            str += temStr + "\n";
            //Debug.Log("tempStr:" + temStr + "  str:" + str);
        }
        clientContentTxt.text = str;
    }

    public void ServerBoradcastMsg()
    {
        server.broadcastMsg(serverInputTxt.text);
    }

    public void StartServer()
    {
        server.StartServer(ip, port);
    }

    public void ConnectServer()
    {
        client.StartConnect(ip, port);
    }

    public void ClientSendMsg()
    {
        client.SendMsg(clientInputTxt.text);
    }

    private void MsgFromServer(string str)
    {
        fromServerStr += str;
        Debug.Log("---MsgFromServer:::fromServerStr>" + fromServerStr);
        Debug.Log("---MsgFromServer:::str>" + str);
    }

    private void MsgFromClient(string str)
    {
        fromClientStrList.Add(str);
        Debug.Log("+++MsgFromClient:::" + str);
    }
}
