Shader "Custom/Texture_01"
{
	properties
	{
		_MainTex("MainTex", 2d) = ""{}
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

			//方法一：通过外部脚本修改下面四个值
			float tiling_x;
			float tiling_y;
			float offset_x;
			float offset_y;
			//方法二：使用系统提供的四维数组。S:Scale, T:Translate。xy表示缩放，zw表示平移
			float4 _MainTex_ST;
			//方法三：使用宏，等价于方法二

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv:TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;
				//======方法一
				/*o.uv.x *= tiling_x;
				o.uv.x *= tiling_y;
				o.uv.x += offset_x;
				o.uv.y += offset_y;*/

				//======方法二
				//o.uv = o.uv * _MainTex_ST.xy + _MainTex_ST.zw;

				//======方法三
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.uv);

				return color;
			}
			ENDCG
		}
	}
}