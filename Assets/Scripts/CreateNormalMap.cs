using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateNormalMap : MonoBehaviour
{
    [SerializeField] private Texture2D tex0;
    [SerializeField] private Texture2D tex1;

    void Start ()
    {
		for (int h = 1; h < 255; h++)
        {
            for (int w = 1; w < 255; w++)
            {
                float uLeft = tex0.GetPixel(w - 1, h).r;
                float uRight = tex0.GetPixel(w + 1, h).r;
                //当前点的右侧点减去左侧点
                float u = uRight - uLeft;

                float uTop = tex0.GetPixel(w, h - 1).r;
                float uBottom = tex0.GetPixel(w, h + 1).r;
                //当前点的下侧点减去上侧点
                float v = uBottom - uTop;

                Vector3 vector_u = new Vector3(1, 0, u);
                Vector3 vector_v = new Vector3(0, 1, v);

                //叉乘得到法线向量
                Vector3 N = Vector3.Cross(vector_u, vector_v).normalized;

                //向量的范围-1~1，颜色值0~1,要做转换
                float r = N.x * 0.5f + 0.5f;
                float g = N.y * 0.5f + 0.5f;
                float b = N.z * 0.5f + 0.5f;

                tex1.SetPixel(w, h, new Color(r, g, b));
            }
        }

        tex1.Apply(false);

    }
	
	void Update ()
    {
		
	}
}
