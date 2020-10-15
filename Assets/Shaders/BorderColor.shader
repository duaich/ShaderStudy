Shader "Custom/BorderColor"
{
	properties
	{
		_BorderColor("BorderColor", color) = (1, 1, 1, 1)
		_Shininess("Shininess", range(1, 8)) = 2
	}

	SubShader
	{
		tags {"queue"="transparent"}
		pass
		{
			blend srcalpha oneminussrcalpha
			zwrite off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _BorderColor;
			float _Shininess;

			struct v2f
			{
				float4 pos : POSITION;
				float3 normal:TEXCOORD0;
				float4 vertex:TEXCOORD1;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.vertex = v.vertex;

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				float3 N = UnityObjectToWorldNormal(i.normal);
				float3 V = normalize(WorldSpaceViewDir(i.vertex));

				float scale = 1 - saturate(dot(N, V));
				scale = pow(scale, _Shininess);

				return _BorderColor * scale;
			}
			ENDCG
		}
	}
}