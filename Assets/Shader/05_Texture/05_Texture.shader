Shader "CustomRenderTexture/05_Texture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("InputTex", 2D) = "white" {}
     }

     SubShader
     {
        Blend One Zero

        Pass
        {
            Name "05_Texture"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float4      _Color;
            sampler2D   _MainTex;
            float4      _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;    
                float2 uv : TEXCOORD0;
            };

            struct v2f 
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 tiling = _MainTex_ST.xy;
                float2 offset = _MainTex_ST.zw;
                
                fixed4 col = tex2D(_MainTex, i.uv * tiling + offset);
                return col;
            }
            ENDCG
        }
    }
}
