Shader "Unlit/billboard"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="AlphaTest" }
		LOD 100
		Cull off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			// #pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				// UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				float4x4 mvMat = float4x4(1, UNITY_MATRIX_MV[0][1], 0, UNITY_MATRIX_MV[0][3],
																	0, UNITY_MATRIX_MV[1][1], 0, UNITY_MATRIX_MV[1][3],
																	0, UNITY_MATRIX_MV[2][1], 1, UNITY_MATRIX_MV[2][3],
																	UNITY_MATRIX_MV[3][0], UNITY_MATRIX_MV[3][1], UNITY_MATRIX_MV[3][2], UNITY_MATRIX_MV[3][3]);
				o.vertex = mul(UNITY_MATRIX_P, mul(mvMat, float4(v.vertex.xyz, 1)));
				// o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				// UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				// UNITY_APPLY_FOG(i.fogCoord, col);
				clip(col.a - 0.5);
				return col;
			}
			ENDCG
		}
	}
}
