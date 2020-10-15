Shader "Custom/MagicSky"
{
	properties
	{
		_F("F", range(1, 10)) = 4
		_MainTex("MainTex", 2d) = ""{}
		_SecondTex("SecondTex", 2d) = ""{}
	}

	SubShader
	{
		pass
		{
			//控制输出指定颜色
			//colormask rg

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _SecondTex;
			float _F;

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
				fixed4 mainColor = tex2D(_MainTex, i.uv);
				//sin确保offset周期变化
				float offset_uv = 0.05 * sin(i.uv * _F + _Time.x * 3);

				float2 uv = i.uv + offset_uv;
				uv.y += 0.3;
				fixed4 color_1 = tex2D(_SecondTex, uv);
				mainColor.rgb *= color_1.b * 5;

				uv = i.uv - offset_uv;
				uv.y += 0.3;
				fixed4 color_2 = tex2D(_SecondTex, uv);
				mainColor.rgb *= color_2.b * 5;
				
				return mainColor;

				/*-----------------------------一张图
				float2 uv = i.uv;
				float offset_uv = 0.05 * sin(uv * _F + _Time.x * 2);
				//多次采样
				uv += offset_uv;
				fixed4 color_1 = tex2D(_MainTex, uv);

				uv = i.uv;
				uv -= offset_uv;
				fixed4 color_2 = tex2D(_MainTex, uv);


				return (color_1 + color_2);
				*/
			}
			ENDCG
		}
	}
}