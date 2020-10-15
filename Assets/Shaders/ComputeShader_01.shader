Shader "Custom/ComputeShader_01" 
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		Pass
		{
			Blend Off Lighting Off Cull Off ZWrite Off ZTest Off AlphaTest Off

			CGPROGRAM

			#pragma target 3.0
			#pragma vertex vert 
			#pragma fragment frag 
			#include "UnityCG.cginc"

			StructuredBuffer<float3> P;//存有点位置

			sampler2D _MainTex;

			struct vertIN
			{
				uint id : SV_VertexID;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 uv : TEXCOORD0;
			};

			v2f vert(vertIN i)
			{
				v2f o;
				float3 pos = P[i.id]; //存储点的位置,P buffer中在compute shader以放置了点位置

				o.pos = mul(UNITY_MATRIX_VP, float4(pos ,1)); //从世界坐标变换到视平空间
				o.uv = P[i.id] / 128; //128=32x4，32为组的x方向组数量，4为每组x方向的线程数  把uv值确定在（0，1）的区间内
				return o;
			}

			fixed4 frag(v2f i) :COLOR
			{
				fixed4 c = tex2D(_MainTex, i.uv * 1.7);//1.7是因为compute shader中我缩放了点的位置除以了1.7，为了是让点之间密集些，当然uv也就对齐不到点上了
				//不过uv其实是世界坐标上的xy，就不像模型表面切线空间的uv了就随着模型表面绑着。
				return c;
			}
			ENDCG
		}
	}
	FallBack "代码归 恬纳微晰 所有！！！"
}
