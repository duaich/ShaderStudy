Shader "Custom/MyDiffuseFrag"
{
	SubShader
	{
		Pass
		{
			tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "lighting.cginc"

			struct v2f
			{
				float4 pos:POSITION;
				float3 normal:TEXCOORD1;
				float4 vertex:COLOR;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.normal = v.normal;
				o.vertex = v.vertex;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//Ambinet color
				fixed4 color = UNITY_LIGHTMODEL_AMBIENT;
				
				float3 N = UnityObjectToWorldNormal(i.normal);
				float3 L = normalize(WorldSpaceLightDir(i.vertex));

				//Diffuse color
				float diffuseScale = saturate(dot(N, L));

				color += _LightColor0 * diffuseScale;

				return color;
			}
		ENDCG
		}
	}
}