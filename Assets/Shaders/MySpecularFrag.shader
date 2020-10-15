Shader "Custom/MySpecularFrag"
{
	properties
	{
		_MainColor("MainColor", color) = (1, 1, 1, 1)
		_SpecularColor("Specular", color) = (1, 1, 1, 1)
		_Shininess("Shininess", range(1, 64)) = 8
	}

	SubShader
	{
		pass
		{
			tags{"LightMode" = "ShadowCaster"}
		}
		pass
		{
			tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "lighting.cginc"

			float4 _MainColor;
			float4 _SpecularColor;
			float _Shininess;

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

				color += _LightColor0 * _MainColor * diffuseScale;

				//Specular color
				float3 V = normalize(WorldSpaceViewDir(i.vertex));
				float3 R = 2 * dot(N, L) * N - L;
				float specularScale = saturate(dot(R, V));

				color += _SpecularColor * pow(specularScale, _Shininess);

				float3 wpos = mul(unity_WorldToObject, i.vertex).xyz;
				//compute 4 points lighting
				color.rgb += Shade4PointLights(
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
					unity_4LightAtten0,
					wpos, N
				);

				return color;
			}
		ENDCG
		}
	}

	//fallback "Diffuse"
}