Shader "Custom/Dissolve_Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_EmissionColor ("EmissionColor", Color) = (1,1,1,1)

		_EdgeWidth("Edge Width", float) = 0
		_DissolveTex("Dissolve Texture", 2D) = "white" {}
		_DissolveProgress("Dissolve Progress", Range(0,1)) = 0.0
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _DissolveTex;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_DissolveTex;
        };

        fixed4 _Color;
		fixed _DissolveProgress;
		fixed4 _EmissionColor;
		fixed _EdgeWidth;

        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

			fixed dissolve = tex2D(_DissolveTex, IN.uv_DissolveTex).r;
			clip(_DissolveProgress * -1 + dissolve);

			fixed edge = _DissolveProgress + _EdgeWidth / 10;
			o.Emission = step(dissolve, edge) * _EmissionColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
