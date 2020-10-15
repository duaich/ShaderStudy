Shader "Custom/AlphaBlend_03"
{
	SubShader
	{
		Tags { "Queue" = "transparent" }

		pass
		{
			//用当前颜色乘srcalpha，然后用1减当前alpha，然后把两部分做加法
			blend srcalpha oneminussrcalpha
			//渲染深度值大(物体在遮挡物后面，离镜头越远深度值越大)的部分，既下半部分。
			ZTest Greater

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : POSITION;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 color = fixed4(1, 1, 0, 0.5);

				return color;
			}
			ENDCG
		}
		
		pass
		{
			//渲染上半部分。因为上半部分没有遮挡物。
			ZTest Less

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : POSITION;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 color = fixed4(1, 0, 0, 1);

				return color;
			}
			ENDCG
		}
	}
}