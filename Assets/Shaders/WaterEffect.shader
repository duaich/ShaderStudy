Shader "Custom/WaterEffect"
{
	properties
	{
		_MainTex("MainTex", 2d) = ""{}
	}

	SubShader
	{
		pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _WaveTex;

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv:TEXCOORD0;
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
				//获取外部脚本给shader设置的颜色值0~1
				float2 uv = tex2D(_WaveTex, i.uv).xy;
				//把0~1还原成-1~1
				uv = uv * 2 - 1;
				uv *= 0.025;

				i.uv += uv;

				fixed4 color = tex2D(_MainTex, i.uv);

				return color;
			}
			ENDCG
		}
	}
}