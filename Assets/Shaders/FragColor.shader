Shader "Custom/FragColor"
{
	properties
	{
		_MainColor("MainColor", color) = (1, 1, 1, 1)
		_SecondColor("SecondColor", color) = (1, 1, 1, 1)
		_Center("Center", range(-0.7, 0.7)) = 0
		_R("R", range(0, 0.5)) = 0.2
	}

	SubShader
	{
		pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _MainColor;
			float4 _SecondColor;
			float _Center;
			float _R;

			struct v2f
			{
				float4 pos : POSITION;
				float y:TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.y = v.vertex.y;

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				float d = i.y - _Center;
				float s = abs(d);
				//得到d要么是1，要么是-1，相当于正负号
				d = d / s;

				float f = s / _R;
				//约束大小0~1
				f = saturate(f);
				//计算结果-1~1
				d *= f;
				//约束到0~1
				d = d / 2 + 0.5;

				return lerp(_MainColor, _SecondColor, d);
			}
			ENDCG
		}
	}
}