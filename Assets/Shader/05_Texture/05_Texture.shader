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
                float3 normal : NORMAL;   
            };

            struct v2f 
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
                float3 normal   : NORMAL;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                // texture tiling and offset
                float2 tiling = _MainTex_ST.xy;
                float2 offset = _MainTex_ST.zw;
                // phong lighting
                float3 N = normalize(i.normal);
                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
           
                float3 reflectDir = reflect(-lightDir, N);
                fixed4 diffuse =  saturate(dot(N, lightDir)) * _LightColor0 * _Color;
                fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0 ;
                fixed4 ambient =  0.3 * _LightColor0 * _Color;

                fixed4 phong = diffuse + specular + ambient;
                
                fixed4 col = tex2D(_MainTex, i.uv * tiling + offset) * phong;
                return col;
            }
            ENDCG
        }
    }
}
