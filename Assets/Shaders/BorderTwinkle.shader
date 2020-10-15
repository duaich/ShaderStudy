Shader "Custom/BorderTwinkle"
{
	properties
	{
		_BorderColor("BorderColor", color) = (1, 1, 1, 1)
		_Shininess("Shininess", range(1, 8)) = 2
		_Outer("Outer", range(0, 1)) = 0.2
	}

	SubShader
	{
		tags {"queue"="transparent"}
		pass
		{
			blend srcalpha oneminussrcalpha
			zwrite off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _BorderColor;
			float _Shininess;
			float _Outer;

			struct v2f
			{
				float4 pos : POSITION;
				float3 normal:TEXCOORD0;
				float4 vertex:TEXCOORD1;
			};

			v2f vert(appdata_base v)
			{
				//沿着法线的方向扩展
				v.vertex.xyz += v.normal * _Outer;
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.vertex = v.vertex;

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				float3 N = UnityObjectToWorldNormal(i.normal);
				float3 V = normalize(WorldSpaceViewDir(i.vertex));

				float scale = saturate(dot(N, V));
				scale = pow(scale, _Shininess);

				_BorderColor.a *= scale;
				return _BorderColor;
			}
			ENDCG
		}

		pass
		{
			//反转减法--让上面渲染的结果减去现在的结果
			blendop revsub
			blend dstalpha one
			zwrite off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : POSITION;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				return fixed4(1, 1, 1, 1);
			}
			ENDCG
		}

		//渲染内部
		pass
		{
			//zero表示让当前计算的结果不输出，one表示让上次计算的结果全部输出
			//blend zero one
			blend srcalpha oneminussrcalpha
			zwrite off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _BorderColor;
			float _Shininess;

			struct v2f
			{
				float4 pos : POSITION;
				float3 normal:TEXCOORD0;
				float4 vertex:TEXCOORD1;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.vertex = v.vertex;

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				float3 N = UnityObjectToWorldNormal(i.normal);
				float3 V = normalize(WorldSpaceViewDir(i.vertex));

				float scale = 1 - saturate(dot(N, V));
				scale = pow(scale, _Shininess);

				return _BorderColor * scale;
			}
			ENDCG
		}
	}
}