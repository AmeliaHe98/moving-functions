Shader "Custom/Waves" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Strength ("_Strength", Range(0,2)) = 1.0
        _Speed ("_Speed", Range(-200,200)) = 100
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
     
        CGPROGRAM
        #pragma surface surf Standard vertex:vert fullforwardshadows
        #pragma target 3.0
 
        sampler2D _MainTex;
 
        struct Input {
            float2 uv_MainTex;
        };
 
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Strength;
        float _Speed;
 
        void vert (inout appdata_full v) {
            //float phase = _Time * 30.0;
            float4 wpos = mul(unity_ObjectToWorld, v.vertex);
            float offset = (cos(wpos.y) + cos(wpos.x +(_Speed*_Time) ));
            wpos.y = wpos.y + (offset * _Strength);
            v.vertex = mul(unity_WorldToObject, wpos);
        }
 
        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}