Shader "CustomRenderTexture/02_Lambert"
{
    Properties
    {
        _BaseColor("BaseColor", Color) = (1,1,1,1)
    }

    SubShader
     {

        Pass
        {
            Name "02_Lambert"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            // #include "UnityCustomRenderTexture.cginc"
            // #pragma vertex CustomRenderTextureVertexShader
            // #pragma fragment frag
            // #pragma target 3.0

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            float4 _BaseColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {

                float intensity = saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
                fixed4 col = _BaseColor;
                fixed4 diffuse = intensity * col * _LightColor0;
                return diffuse;
            }
            ENDCG
        }
    }
}
