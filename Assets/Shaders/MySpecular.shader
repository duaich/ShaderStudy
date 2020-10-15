/*
 * L 反射光线--从顶点指向光源
 * I 入射光线--从光源指向顶点
 * N 法线
 * V 视角--从顶点指向摄像机
*/
Shader "Custom/MySpecular"
{
	properties
	{
		_SpecularColor("Specular", color) = (1, 1, 1, 1)
		_Shininess("Shininess", range(1, 64)) = 8
	}

	SubShader
	{
		Pass
		{
			tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "lighting.cginc"

			float4 _SpecularColor;
			float _Shininess;

			struct v2f
			{
				float4 pos:POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.color = fixed4(0, 0, 1, 1);

				//将顶点法线转成世界坐标系下的法线并规范化
				float3 N = UnityObjectToWorldNormal(v.normal);
				//反射光线向量--从顶点指向光源
				float3 L = normalize(WorldSpaceLightDir(v.vertex));
				//视角向量
				float3 V = normalize(WorldSpaceViewDir(v.vertex));

				//环境光+漫反射光+镜面高光=Phong模型

				//环境光--Ambient color
				o.color = UNITY_LIGHTMODEL_AMBIENT;

				//漫反射--Diffuse color
				//把点积的结果约束到0,1的范围内
				float ndotl = saturate(dot(N, L));
				//dot值越小，光强度越弱。
				o.color += _LightColor0 * ndotl;

				//镜面反射--Specular color
				//---------------------- 方法一 ----------------------
					//计算光线反射向量和视角向量的夹角。夹角越小，说明反射光和视角越接近，光线越亮。

				//入射光线向量--WorldSpaceLightDir方法计算的是从顶点射出的光向量。取负就是入射光线向量--从光源到顶点
				float3 I = -WorldSpaceLightDir(v.vertex);
				//光线反射向量--入射光线被镜子反射后的向量
				//float3 R = reflect(I, N);
				//reflect方法原理：
				float3 R = 2 * dot(N, L) * N - L;
				R = normalize(R);

				//开4次方是因为镜面反射的光线不是线性衰减的，夹角小的时候光线亮，
				//稍微偏移一点就会衰减的厉害。dot的值是0~1，4次可以达到这种效果。
				float specularScale = pow(saturate(dot(R, V)), _Shininess);

				//BlinnPhong模拟Phong，比较省
				//---------------------- 方法二 ----------------------
					//反射向量和视角向量相加得出半角向量H，再计算H和法线向量N的点积
					//这种做法与计算光线反射向量相比少了一次dot计算。

				/*float3 H = L + V;
				H = normalize(H);
				float specularScale = pow(saturate(dot(H, N)), _Shininess);*/

				o.color.rgb += _SpecularColor * specularScale;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
		}
	}
}