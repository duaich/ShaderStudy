Shader "Custom/Niuqu"
{
	SubShader
	{
		pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v)
			{
				float angle = v.vertex.z + _Time.y;

				//只旋转x
				float4x4 m = {
					float4(sin(angle) / 8 + 0.5, 0, 0, 0),
					float4(0, 1, 0, 0),
					float4(0, 0, 1, 0),
					float4(0, 0, 0, 1)
				};
				//mul方法是第一个参数影响第二个参数，既用m来影响v.vertex
				v.vertex = mul(m, v.vertex);

				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = float4(0, 1, 1, 1);

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				return i.color;
			}
			ENDCG
		}
	}
}