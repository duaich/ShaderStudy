Shader "Custom/MyDiffuse"
{
	SubShader
	{
		Pass
		{
			tags {"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "lighting.cginc"

			struct v2f
			{
				float4 pos:POSITION;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.color = fixed4(0, 0, 1, 1);

				//将顶点法线规范化
				float3 N = normalize(v.normal);
				//光线规范化
				float3 L = normalize(_WorldSpaceLightPos0);
				//上面的N和L是在两个不同的坐标系，所以要将它们两个转换到同一个坐标系中。不然会出现问题。
				L = mul(float4(L, 0), unity_WorldToObject).xyz;
				L = normalize(L);

				//把点积的结果约束到0,1的范围内
				float ndotl = saturate(dot(N, L));
				//dot值越小，光强度越弱。
				o.color = _LightColor0 * ndotl;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//环境光
				return i.color + UNITY_LIGHTMODEL_AMBIENT;
			}
			ENDCG
		}
	}
}
