Shader "Custom/vf"
{
	SubShader
	{
		pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//形参数组必须制定长度
			float Func(float arr[2])
			{
				float sum = 0;
				for (int i = 0; i < arr.Length; i++)
				{
					sum += arr[i];
				}
				return sum;
			}

			void vert(in float2 objPos:POSITION, out float4 pos:POSITION, out float4 col:COLOR)
			{
				pos = float4(objPos, 0, 1);
				col = pos;
			}

			void frag(inout float4 col:COLOR)
			{
				float arr[2] = {0.5, 0.5};
				col.x = Func(arr);
			}

			ENDCG
		}
	}
}