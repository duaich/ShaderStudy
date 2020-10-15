using UnityEngine;
using System.Collections;

public class Compute_01 : MonoBehaviour
{
    public Material mat;
    public ComputeShader comshader;   

    private ComputeBuffer P;            
    int kernel;

    void Start()
    {
        //16384是32 * 32 * 4 * 4得出的。32 * 32个组，每组4 * 4个线程
        P = new ComputeBuffer(16384, 12); //设置P Buffer的大小,12为字节大小(float3),
        kernel = comshader.FindKernel("Main");//找到Main的id号
    }

    private void OnRenderObject()
    {
        comshader.SetBuffer(kernel, "P", P);//给compute shader设置P
        comshader.Dispatch(kernel, 32, 32, 1);

        mat.SetBuffer("P", P); //给shader设置P
        mat.SetPass(0);//指定shader的pass渲染
        Graphics.DrawProcedural(MeshTopology.Points, 16384);//在屏幕绘制点
    }

    private void OnDestroy()
    {
        P.Release();//释放buffer
    }
}
