Shader "Custom/LightingMap"
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
			float4 _MainTex_ST;

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv:TEXCOORD0;
				float2 uv2:TEXCOORD1;
			};

			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv2 = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				float3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv2));
				fixed4 color = tex2D(_MainTex, i.uv);
				color.rgb *= lm * 2;
				return color;
			}
			ENDCG
		}
	}
}