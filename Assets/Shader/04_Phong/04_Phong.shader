Shader "CustomRenderTexture/04_Phong"
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
            Name "04_Phong"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float4      _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;      

            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXCOORD0;
                float3 normal   : NORMAL;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }


            fixed4 frag(v2f i) : SV_Target
            {
                float3 N = normalize(i.normal);
                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                // float3 lightDir = normalize(
                //     UnityWorldSpaceLightDir(i.worldPosition)
                // );
           
                float3 reflectDir = reflect(-lightDir, N);


                fixed4 diffuse =  saturate(dot(N, lightDir)) * _LightColor0 * _Color;
                fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0 ;
                fixed4 ambient =  0.3 * _LightColor0 * _Color;

                fixed4 phong = diffuse + specular + ambient;
                return phong;
            }

            
            ENDCG
        }
    }
}
