Shader "Custom/AlphaBlend_02"
{
	SubShader
	{
		Tags { "Queue" = "transparent" }

		pass
		{
			//用当前颜色乘srcalpha，然后用1减当前alpha，然后把两部分做加法
			blend srcalpha oneminussrcalpha
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
				fixed4 color = fixed4(0, 0, 1, 0.5);

				return color;
			}
			ENDCG
		}
	}
}