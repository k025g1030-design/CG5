Shader "CustomRenderTexture/06_ToonShading"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("InputTex", 2D) = "white" {}
        _Threshold ("Toon Threshold", Range(0, 1)) = 0.5

        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(0.5, 10)) = 3
        _RimIntensity ("Rim Intensity", Range(0, 2)) = 0.5
        _RimThreshold ("Rim Threshold", Range(0, 1)) = 0.5
     }

     SubShader
     {
        Blend One Zero

        Pass
        {
            Name "06_ToonShading"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float4      _Color;
            sampler2D   _MainTex;
            float4      _MainTex_ST;
            float       _Threshold;
            float4      _RimColor;
            float       _RimPower;
            float       _RimIntensity;
            float       _RimThreshold;
            
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
                float res = step(_Threshold, saturate(dot(normalize(i.normal), normalize(_WorldSpaceLightPos0.xyz))));

                float2 tiling = _MainTex_ST.xy;
                float2 offset = _MainTex_ST.zw;
                // phong lighting
                float3 N = normalize(i.normal);
                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                // rim lighting
                float rim = pow(1.0 - saturate(dot(N, eyeDir)), _RimPower);
                // rim toon shading
                rim = step(_RimThreshold, rim);
                float3 rimlight = _RimColor.rgb * rim * _RimIntensity;

                
               
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 reflectDir = reflect(-lightDir, N);
                fixed4 diffuse =  saturate(dot(N, lightDir)) * _LightColor0 * _Color;
                fixed4 ambient =  res * _LightColor0 * _Color;

                fixed4 phong = diffuse + ambient;
                
                fixed4 col = tex2D(_MainTex, i.uv * tiling + offset) * phong;
                col.rgb += rimlight;
                
                //fixed4 diffuse = res * _Color.rgb * _LightColor0.rgb;
                //return fixed4(diffuse, _Color.a);
                return col;
            }
            ENDCG
        }
    }
}
