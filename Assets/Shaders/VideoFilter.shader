Shader "Custom/VideoFilter"
{
	properties
	{
		_MainTex("MainTex", 2d) = ""{}
		_R("R", range(0, 1)) = 0.5
		_G("G", range(0, 1)) = 0.5
		_B("B", range(0, 1)) = 0.5
	}

	SubShader
	{
		// 透明度混合队列为Transparent，所以Queue=Transparent
        // RenderType标签让Unity把这个Shader归入提前定义的组中，以指明该Shader是一个使用了透明度混合的Shader
        // IgonreProjector为True表明此Shader不受投影器（Projectors）影响
        Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }

		pass
		{
			Tags { "LightMode" = "ForwardBase" }

            // 关闭深度写入
            ZWrite Off
            // 开启混合模式，并设置混合因子为SrcAlpha和OneMinusSrcAlpha
            Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _R;
			float _G;
			float _B;

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv:TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.uv = v.texcoord.xy;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.uv);
				if (color.x < _R && color.y > _G && color.z < _B)
				{
					return fixed4(0, 0, 0, 0);
				}
				else {
					return color;
				}
			}
			ENDCG
		}
	}
}