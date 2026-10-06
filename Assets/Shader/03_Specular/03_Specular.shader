Shader "CustomRenderTexture/03_Specular"
{
    Properties
    {
        _BColor ("Base Color", Color) = (1,1,1,1)
        _SColor ("Specular Color", Color) = (1,1,1,1)
        _MainTex("InputTex", 2D) = "white" {}
     }

     SubShader
     {
        Blend One Zero

        Pass
        {
            Name "03_Specular"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float4      _BColor;
            float4      _SColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;      

            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXCOORD0;
                float3 worldNormal   : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);

                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
           
                float3 reflectDir = reflect(-lightDir, normal);

                fixed4 diffuse =  saturate(dot(normal, lightDir)) * _LightColor0 * _BColor;

                fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0 * _SColor;
                return diffuse + specular;
            }
            ENDCG
        }
    }
}
