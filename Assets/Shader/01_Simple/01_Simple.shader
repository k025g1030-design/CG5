Shader "CustomRenderTexture/01_Simple"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("InputTex", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            // #include "UnityCustomRenderTexture.cginc"
            // #pragma vertex CustomRenderTextureVertexShader
            // #pragma fragment frag
            // #pragma target 3.0

            float4      _Color;
            sampler2D   _MainTex;

            float4 vert(float4 v:POSITION) : SV_POSITION
            {
                float4 o;
                o = UnityObjectToClipPos(v);
                return o;
            }
            
            fixed4 RGB255(fixed r, fixed g, fixed b)
            {
                fixed3 rgb = fixed3(r, g, b) / 255.0;
                #ifndef UNITY_COLORSPACE_GAMMA
                rgb = GammaToLinearSpace(rgb);
                #endif
                return fixed4(rgb, 1.0);
            }

            fixed4 frag(float4 i:SV_POSITION) : SV_TARGET
            {
                return _Color;
            }
            ENDCG
        }
    }
}
