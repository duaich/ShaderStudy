Shader "Custom/VertexWave"
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
				//横波
				//v.vertex.y += 0.2 * sin(v.vertex.x * 2 + _Time.y);

				//交叉波
				/*v.vertex.y += 0.2 * sin((v.vertex.x - v.vertex.z) + _Time.y);
				v.vertex.y += 0.3 * sin((v.vertex.x - v.vertex.z) + _Time.y);*/

				//圆形波
				v.vertex.y += 0.2 * sin(-length(v.vertex.xz) * 2 + _Time.y * 5);

				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = fixed4(v.vertex.y, v.vertex.y, v.vertex.y, 1);

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