using System.Threading;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterEffect : MonoBehaviour
{
    [SerializeField] private int waveRadius = 8;
    [SerializeField] private int waveWidth = 128;
    [SerializeField] private int waveHeight = 128;

    private float[,] waveA;
    private float[,] waveB;
    private Color[] colorsBuffer;
    private Texture2D tex_uv;
    private bool isRun = true;
    private int sleepTime;

    void Start ()
    {
        waveA = new float[waveWidth, waveHeight];
        waveB = new float[waveWidth, waveHeight];

        tex_uv = new Texture2D(waveWidth, waveHeight);
        colorsBuffer = new Color[waveWidth * waveHeight];

        GetComponent<Renderer>().material.SetTexture("_WaveTex", tex_uv);

        Thread th = new Thread(new ThreadStart(ComputeWave));
        th.Start();
    }
	
	void Update ()
    {
        sleepTime = (int)(Time.deltaTime * 1000);
        tex_uv.SetPixels(colorsBuffer);
        tex_uv.Apply();

        if (Input.GetMouseButton(0))
        {
            RaycastHit hit;
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out hit))
            {
                Vector3 pos = hit.point;
                //转到模型坐标系
                pos = transform.worldToLocalMatrix.MultiplyPoint(pos);

                int w = (int)((pos.x + 0.5) * waveWidth);
                int h = (int)((pos.y + 0.5) * waveHeight);

                PutDrop(w, h);
            }
        }
        //ComputeWave();
    }

    private void PutDrop(int x, int y)
    {
        //waveA[waveWidth / 2,     waveHeight / 2] = 1;
        //waveA[waveWidth / 2 - 1, waveHeight / 2] = 1;
        //waveA[waveWidth / 2 + 1, waveHeight / 2] = 1;
        //waveA[waveWidth / 2,     waveHeight / 2 - 1] = 1;
        //waveA[waveWidth / 2,     waveHeight / 2 + 1] = 1;
        //waveA[waveWidth / 2 - 1, waveHeight / 2 - 1] = 1;
        //waveA[waveWidth / 2 - 1, waveHeight / 2 + 1] = 1;
        //waveA[waveWidth / 2 + 1, waveHeight / 2 - 1] = 1;
        //waveA[waveWidth / 2 + 1, waveHeight / 2 + 1] = 1;

        float dist;

        for (int i = -waveRadius; i <= waveRadius; i++)
        {
            for (int j = -waveRadius; j <= waveRadius; j++)
            {
                if (((x + i) >= 0 && (x + i < waveWidth - 1)) && ((y + j >= 0) && (y + j < waveHeight - 1)))
                {
                    dist = Mathf.Sqrt(i * i + j * j);
                    if (dist < waveRadius)
                    {
                        waveA[x + i, y + j] = Mathf.Cos(dist * Mathf.PI / waveRadius);
                    }
                }
            }
        }
    }

    private void ComputeWave()
    {
        while (isRun)
        {
            for (int w = 1; w < waveWidth - 1; w++)
            {
                for (int h = 1; h < waveHeight - 1; h++)
                {
                    //当前点八个方向的点相加，减去当前点的值
                    waveB[w, h] = (
                        waveA[w - 1, h] +
                        waveA[w + 1, h] +

                        waveA[w, h - 1] +
                        waveA[w, h + 1] +

                        waveA[w - 1, h - 1] +
                        waveA[w - 1, h + 1] +
                        waveA[w + 1, h - 1] +
                        waveA[w + 1, h + 1]
                        ) / 4 - waveB[w, h];

                    //限定在-1~1
                    float value = waveB[w, h];
                    if (value > 1)
                        waveB[w, h] = 1;
                    if (value < -1)
                        waveB[w, h] = -1;

                    //计算偏移量，限定在-1~1
                    float offset_u = (waveB[w - 1, h] - waveB[w + 1, h]) / 2;
                    float offset_v = (waveB[w, h - 1] - waveB[w, h + 1]) / 2;

                    float r = offset_u / 2 + 0.5f;
                    float g = offset_v / 2 + 0.5f;

                    //tex_uv.SetPixel(w, h, new Color(r, g, 0));
                    colorsBuffer[w + waveWidth * h] = new Color(r, g, 0);

                    //衰减
                    waveB[w, h] -= waveB[w, h] * 0.025f;
                }
            }

            //tex_uv.Apply();

            float[,] temp = waveA;
            waveA = waveB;
            waveB = temp;

            Thread.Sleep(sleepTime);
        }
    }

    void OnDestroy()
    {
        isRun = false;
    }
}
