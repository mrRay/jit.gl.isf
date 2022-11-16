/*{
	"DESCRIPTION": "Star Wipe",
	"CREDIT": "by VIDVOX (adapted from http://transitions.glsl.io/transition/d1f891c5585fc40b55ea)",
	"ISFVSN": "2",
	"CATEGORIES": [
		"Transition"
	],
	"INPUTS": [
		{
			"NAME": "startImage",
			"TYPE": "image"
		},
		{
			"NAME": "endImage",
			"TYPE": "image"
		},
		{
			"NAME": "progress",
			"TYPE": "float",
			"MIN": 0.0,
			"MAX": 1.0
		}
	]
	
}*/


vec2 circlePoint( float ang )
{
	ang += 6.28318 * 0.15;
	return vec2( cos(ang), sin(ang) );  
}

float cross2d( vec2 a, vec2 b )
{
	return ( a.x * b.y - a.y * b.x );
}

// quickly knocked together with some math from http://www.pixeleuphoria.com/node/30
float star( vec2 p, float size )
{
	if( size <= 0.0 )
	{
		return 0.0;
	}
	p /= size;

	vec2 p0 = circlePoint( 0.0 );
	vec2 p1 = circlePoint( 6.28318 * 1.0 / 5.0 );
	vec2 p2 = circlePoint( 6.28318 * 2.0 / 5.0 );
	vec2 p3 = circlePoint( 6.28318 * 3.0 / 5.0 );
	vec2 p4 = circlePoint( 6.28318 * 4.0 / 5.0 );

	// are we on this side of the line
	float s0 = ( cross2d( p1 - p0, p - p0 ) );
	float s1 = ( cross2d( p2 - p1, p - p1 ) );
	float s2 = ( cross2d( p3 - p2, p - p2 ) );
	float s3 = ( cross2d( p4 - p3, p - p3 ) );
	float s4 = ( cross2d( p0 - p4, p - p4 ) );

	// some trial and error math to get the star shape.  I'm sure there's some elegance I'm missing.
	float s5 = min( min( min( s0, s1 ), min( s2, s3 ) ), s4 );
	float s = max( 1.0 - sign( s0 * s1 * s2 * s3 * s4 ) + sign(s5), 0.0 );
	s = sign( 2.6 - length(p) ) * s;

	return max( s, 0.0 );
}

void main()
{
	vec2		p = gl_FragCoord.xy / RENDERSIZE.xy;
	float		bottomAlpha = 1.0;
	vec4		bottom = IMG_NORM_PIXEL(startImage, isf_FragNormCoord.xy);
	float		topAlpha = progress;
	vec4		top = IMG_NORM_PIXEL(endImage, isf_FragNormCoord.xy);
	vec4		darkenedBottom = vec4(bottomAlpha) * bottom;
	vec4		returnMe = darkenedBottom;

	vec2		o = p * 2.0 - 1.0;

	float		t = topAlpha * 1.35;

	float		c1 = star( o, t );
	float		c2 = star( o, t - 0.1 );

	float		border = max( c1 - c2, 0.0 );
	if (progress == 0.0)	{
		returnMe = bottom;
	}
	else if (progress == 1.0)	{
		returnMe = top;
	}
	else	{
		returnMe = (topAlpha > c2) ? returnMe + vec4( border, border, border, 0.0 ) : top;
	}
	gl_FragColor = returnMe;
}

