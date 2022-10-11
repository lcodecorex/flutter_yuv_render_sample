uniform sampler2D textureY;
uniform sampler2D textureU;
uniform sampler2D textureV;

const mat4 YUV_TO_RGB_MATRIX = mat4(
1.1643835616, 0, 1.7927410714, -0.9729450750,
1.1643835616, -0.2132486143, -0.5329093286, 0.3014826655,
1.1643835616, 2.1124017857, 0, -1.1334022179,
0, 0, 0, 1);

vec4 fragment(in vec2 uv, in vec2 fragCoord) {
    float y = texture(textureY, uv).x;
    float u = texture(textureU, uv).x;
    float v = texture(textureV, uv).x;
    return vec4(y, u, v, 1.0) * YUV_TO_RGB_MATRIX;
}
