Shader "Custom/ColorShader"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				if (v.vertex.x == 0.5 && v.vertex.y == 0.5 && v.vertex.z == -0.5)
					o.color = fixed4(_SinTime.w / 2 + 0.5, _CosTime.w / 2 + 0.5, _SinTime.y / 2 + 0.5, 1);
				else
					o.color = fixed4(0, 0, 1, 1);

				/*float4 wpos = mul(unity_ObjectToWorld, v.vertex);
				if (wpos.x > 0)
					o.color = fixed4(1, 0, 0, 1);
				else
					o.color = fixed4(0, 0, 1, 1);*/

				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : COLOR
			{
				return i.color;
			}
			ENDCG
		}
	}
}
