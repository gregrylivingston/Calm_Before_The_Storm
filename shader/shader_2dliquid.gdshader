// 2D liquid inside 'sphere' shader.

// Original Author: Mirza Beig
// Godot Implementation: RuverQ

// https://twitter.com/TheMirzaBeig
// https://www.youtube.com/@MirzaBeig

// https://twitter.com/RuverQuack

// Feel free troveto use this however you want.
// Modify, learn from it, copy-paste, etc...

// Original Shadertoy: https://www.shadertoy.com/view/Ds3BRN

shader_type canvas_item;

// fV = fill value
uniform float fV;

void fragment() {
    vec2 uv = ((UV / -0.10)) + vec2(1.25,1.25);

    float
		sdf=length(uv),c=step(sdf,.85),
		
        vB=smoothstep(.1,.9,sin(uv.x+(PI*.5))-.3),
		vBA=vB*sin(TIME*4.)*.1,
        
        fW=(sin(((TIME*2.)+uv.x)*2.)*.05)+vBA,  //front
		bW=(sin(((TIME*-2.)+uv.x)*2.+PI)*.05)-vBA, // back
		
        fA=(sin(TIME*4.)*.05)*vB,  //larger amplitude wave
        
        fP=fV * 2.3 +(sin((TIME)*PI)*.1) - 1.1,
		
        fF=step(uv.y,(fA+fW)+fP),
		bF=step(uv.y,(-fA+bW)+fP);

    COLOR =
		vec4(
		(fF+(clamp(bF-fF,0.,1.)*.8))+
		clamp(pow((sdf+.01)*
		((1.-(fF+bF))*c),50.),0.,1.));
	COLOR.b += 1.5;
	COLOR.r *= 0.1;
		
}

