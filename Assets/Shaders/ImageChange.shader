Shader "Custom/ImageChange"
{
	properties
	{
		_MainTex("MainTex", 2d) = ""{}
		_SecondTex("MainTex", 2d) = ""{}
	}

	SubShader
	{
		tags {"queue" = "transparent"}
		pass
		{
			blend srcalpha oneminussrcalpha
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _SecondTex;

			float4 _MainTex_ST;

			struct v2f
			{
				float4 pos: POSITION;
				float2 uv: TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 color;
				
				/*if (i.uv.y < 0.2 || (i.uv.y > 0.4 && i.uv.y < 0.6) || i.uv.y > 0.8)
				{
					color = tex2D(_MainTex, i.uv);
				}
				else {
					color = tex2D(_SecondTex, i.uv);
				}
				color.w *= _SinTime;*/

				float2 uv = i.uv;
				float dis = distance(uv, float2(0.5, 0.5));
				float scale = 0;
				if (dis < 0.4)
				{
					color = tex2D(_SecondTex, i.uv);
					if (dis > 0.3)
					{
						color *= tex2D(_MainTex, i.uv);
						color.w = 1 - (dis - 0.3) / 0.1;
					}
				}
				else {
					color = tex2D(_MainTex, i.uv);
				}
				
				return color;
			}
			ENDCG
		}
	}
}