Shader "Custom/TextureWave"
{
	properties
	{
		_MainTex("MainTex", 2d) = ""{}
		//振动幅度
		_A("A", range(0, 0.1)) = 0.01
		//振动周期
		_F("F", range(1, 30)) = 10
		_R("R", range(0, 1)) = 0
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
			float _A;
			float _F;
			float _R;

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv:TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				//没有点击时的波光粼粼
				i.uv += 0.005 * sin(i.uv * 3.14 * _F + _Time.y);

				//动画
				float2 uv = i.uv;
				//以某个点为圆心，计算图片uv到该中心的距离
				float dis = distance(uv, float2(0.5, 0.5));
				float scale = 0;
				if (dis < _R)
				{
					//振动幅度跟距离成反比
					_A *= 1 - dis / _R;
					scale = _A * sin(-dis * 3.14 * _F + _Time.y * 10);
					uv += uv * scale;
				}

				//fixed4(1, 1, 1, 1) * saturate(scale) * 50  打白光
				fixed4 color = tex2D(_MainTex, uv);// + fixed4(1, 1, 1, 1) * saturate(scale) * 50;

				return color;
			}
			ENDCG
		}
	}
}