Shader "Unlit/Dissolve_Unlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		
		_DissolveTex("Dissolve Texture", 2D) = "white" {}
		_DissolveProgress("Dissolve Progress", Range(0,1)) = 0.0
		
		_EdgeWidth("Edge Width", float) = 0
		_EdgeColor("Edge Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float2 uv_Dissolve : TEXCOORD1;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
				float2 uv_Dissolve : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _DissolveTex;
			float4 _DissolveTex_ST;
			fixed _DissolveProgress;
			float _EdgeWidth;
			fixed4 _EdgeColor;

			VertexOutput vert (VertexInput i)
            {
				VertexOutput o;
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.uv = TRANSFORM_TEX(i.uv, _MainTex);
				o.uv_Dissolve = TRANSFORM_TEX(i.uv_Dissolve, _DissolveTex);
                return o;
            }

            fixed4 frag (VertexOutput o) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, o.uv);
             
				fixed dissolve = tex2D(_DissolveTex, o.uv_Dissolve).r;
				clip(_DissolveProgress * -1 + dissolve);

				fixed edge = _DissolveProgress + _EdgeWidth / 10;

				col += step(dissolve, edge) * _EdgeColor;

				return col;
            }
            ENDCG
        }
    }
}
