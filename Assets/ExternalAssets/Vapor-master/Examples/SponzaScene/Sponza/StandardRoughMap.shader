﻿Shader "Custom/StandardRoughMap" {
	Properties {
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Bump (RGB)", 2D) = "white" {}
		_Rough ("Rough (A)", 2D) = "white" {}
		_Metallic("Metallic", 2D) = "black" {}
		_SmoothMult("Smoothness Mult", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		//NOTE: Only works with vapor in deferred
		//TODO: Support override cginc's to support this in forward

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Rough;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _Metallic;
		float _SmoothMult;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Metallic = tex2D(_Metallic, IN.uv_MainTex) + 0.05f;
			o.Smoothness = 1 - tex2D(_Rough, IN.uv_MainTex) * _SmoothMult;
			o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
