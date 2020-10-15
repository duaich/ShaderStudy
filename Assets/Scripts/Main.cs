using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Main : MonoBehaviour
{
    public Text txt;
	void Start ()
    {
        GlobalInput.callback += callback;
        GlobalInput.Start();
#if UNITY_EDITOR

#else
#endif

    }

    void Update () {
    }

    private void callback(string val)
    {
        txt.text = val;
    }
}
