// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/VertexMountain"
{
	properties{
		//山体半径
		_R("R", range(0, 5)) = 1
		//山体高度
		_H("H", range(0, 5)) = 1
		//山体位置
		_OX("OX", range(-5, 5)) = 0
	}

		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float _R;
			float _H;
			float _OX;

			struct v2f
			{
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			//v是赋值传值，不是引用。所以改变v的数据不会对原模型造成影响
			v2f vert(appdata_base v)
			{
				float4 wpos = mul(unity_ObjectToWorld, v.vertex);
				//取物体在xz平面模
				float xy = wpos.xz;
				float d = _R - length(xy - float2(_OX, 0));
				d = d < 0 ? 0 : d;

				float4 uppos = float4(v.vertex.x, _H * d, v.vertex.z, v.vertex.w);

				v2f o;
				o.pos = UnityObjectToClipPos(uppos);
				o.color = fixed4(uppos.y, uppos.y, uppos.y, 1);

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