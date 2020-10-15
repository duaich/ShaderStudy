using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetTexture : MonoBehaviour
{
    [SerializeField] private float tiling_x = 1;
    [SerializeField] private float tiling_y = 1;

    [SerializeField] private float offset_x;
    [SerializeField] private float offset_y;

    void Start ()
    {
		
	}
	
	void Update ()
    {
        GetComponent<Renderer>().material.SetFloat("tiling_x", tiling_x);
        GetComponent<Renderer>().material.SetFloat("tiling_y", tiling_y);
        GetComponent<Renderer>().material.SetFloat("offset_x", offset_x);
        GetComponent<Renderer>().material.SetFloat("offset_y", offset_y);
    }
}
