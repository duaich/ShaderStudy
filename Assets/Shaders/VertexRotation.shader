Shader "Custom/VertexRotation"
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
				float angle = length(v.vertex) * _SinTime.w;

				//方法一：
				//绕Y轴旋转矩阵
				float4x4 m = {
					float4(cos(angle), 0, sin(angle), 0),
					float4(0, 1, 0, 0),
					float4(-sin(angle), 0, cos(angle), 0),
					float4(0, 0, 0, 1)
				};
				//mul方法是第一个参数影响第二个参数，既用m来影响v.vertex
				v.vertex = mul(m, v.vertex);

				//方法二：优化
				/*float x = cos(angle) * v.vertex.x + sin(angle) * v.vertex.z;
				float z = cos(angle) * v.vertex.z - sin(angle) * v.vertex.x;
				v.vertex.x = x;
				v.vertex.z = z;*/

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