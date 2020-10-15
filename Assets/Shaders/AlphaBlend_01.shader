Shader "Custom/AlphaBlend_01"
{
	SubShader
	{
		Tags { "Queue" = "transparent" }

		pass
		{
			//用当前颜色乘srcalpha，然后用1减当前alpha，然后把两部分做加法
			//这一行确保物体可以透明
			blend srcalpha oneminussrcalpha

			//控制像素是否写入深度缓存区。如果是实心的物体，设置为on；如果是半透明的物体，设置为off。
			ZWrite Off

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
				fixed4 color = fixed4(1, 0, 0, 0.5);

				return color;
			}
			ENDCG
		}
	}
}