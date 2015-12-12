package utils;

import luxe.Vector;
import luxe.utils.Maths;

class Mathf{
    public static inline var EPSILON:Float = 1.0E-9;
    public static inline var EPSILON2:Float = 1.0E-5;

    inline public static function ApValue(start:Float, end:Float, shift:Float):Float {
        if (start < end) {
            return  Math.min(start + shift, end);
        } else {
            return Math.max(start - shift, end);
        }
    } 

    inline public static function ApValueT(start:Float, end:Float, shift:Float, dt:Float):Float {
        if (start < end) {
            return  Math.min(start + shift * dt, end);
        } else {
            return Math.max(start - shift * dt, end);
        }
    } 
    
    // value 100 = return 0
    inline public static function ApFriction(vel:Float, value:Float):Float {
        var ret:Float = vel * Maths.clamp(1.0 - 0.01 * value, 0.0, 1.0);
        if(Math.abs(ret) > 0.1){
            return ret;
        } else {
            return 0;
        }
    } 

    inline public static function ApFrictionT(start:Float, shift:Float, dt:Float):Float {
        var ret:Float = start * Maths.clamp(1.0 - dt * shift, 0.0, 1.0);
        if(Math.abs(ret) > 0.1){
            return ret;
        } else {
            return 0;
        }
    } 

    inline public static function calculateSpringForce(posA:Vector, velA:Vector, posB:Vector, velB:Vector, length:Float, stiffness:Float, damping:Float):Vector {
        var BtoAX:Float = posA.x - posB.x;
        var BtoAY:Float = posA.y - posB.y;
        
        var dist:Float = Math.sqrt((BtoAX * BtoAX) + (BtoAY * BtoAY));
        
        if (dist > EPSILON2) {
            BtoAX /= dist;
            BtoAY /= dist;
            
            dist = length - dist;
            
            var totalRelVel:Float = ((velA.x - velB.x) * BtoAX) + ((velA.y - velB.y) * BtoAY);
            
            return new Vector(BtoAX * ((dist * stiffness) - (totalRelVel * damping)), BtoAY * ((dist * stiffness) - (totalRelVel * damping)));
        } 
        
        return null;
    }

    inline public static function calculateSpringForce1D(posA:Float, velA:Float, posB:Float, velB:Float, length:Float, stiffness:Float, damping:Float):Float {
        var ret:Float = 0;
        var btoa:Float = (posA - posB);
        
        var dist:Float = Math.abs(btoa);
        
        if (dist > EPSILON2) {
            btoa /= dist;
            
            dist = length - dist;
            
            // var totalRelVel:Float = ((velA - velB) * btoa);
            
            ret = btoa * ((dist * stiffness) - ((velA - velB) * btoa * damping));
        } 
        
        return ret;
    }
}


/*inline T SaturatedAdd(T Min, T Max, T Current, T Modifier)
{
    if(Modifier < 0)
    {
        if(Current < Min)
            return Current;
        Current += Modifier;
        if(Current < Min)
            Current = Min;
        return Current;
    }
    else
    {
        if(Current > Max)
            return Current;
        Current += Modifier;
        if(Current > Max)
            Current = Max;
        return Current;
    }
}*/





/*



class Test {
    static function main() {
        var m:Float = 60;
        var speed:Float = 0;
        var accel:Float = 1 * m;
        var friction:Float = 1.9 * m;
        var maxSpeed:Float = 7 * m;
        
        trace('speed = ' + speed);
        trace('accel = ' + accel);
        trace('friction = ' + friction);
        trace('maxSpeed = ' + maxSpeed);
        
        trace('');
        trace('acceleration');
        for(i in 0...5){
            speed = ApValue(speed, maxSpeed, accel);
           trace(speed); 
        }
            
        trace('');
		trace('friction');
        for(i in 0...5){
            speed = ApValue(speed, 0, friction);
           trace(speed); 
        }
            
        trace('');
		trace('while');
        speed = 0;
        while(speed < maxSpeed){
            speed = ApValue(speed, maxSpeed, accel);
            trace(speed); 
        }
        
    }
    
    inline public static function ApValue(start:Float, end:Float, shift:Float):Float {
		if (start < end) {
			return	Math.min(start + shift, end);
		}
		else {
			return Math.max(start - shift, end);
		}
	} 
}





class Test {
    static function main() {
        var m:Float = 60;
        var speed:Float = 0;
        var accel:Float = 1 * m;
        var friction:Float = 1.9 * m;
        var maxSpeed:Float = 7 * m;
        
        trace('speed = ' + speed);
        trace('accel = ' + accel);
        trace('friction = ' + friction);
        trace('maxSpeed = ' + maxSpeed);
            
        trace('');
		trace('accel Right');
        speed = 0;
        while(speed < maxSpeed){
            speed = ApValue(speed, maxSpeed, accel);
            trace(speed); 
        }
         
        trace('');
		trace('accel left');
        while(speed > -maxSpeed){
            if(speed > 0){
            	speed = ApValue(speed, 0, friction);
            }
            speed = ApValue(speed, -maxSpeed, accel);
            trace(speed); 
        }
            
        speed = maxSpeed;
        trace('');
		trace('while fric');
        while(speed > 0){
            speed = ApValue(speed, 0, friction);
            trace(speed); 
        }
    }
    
    inline public static function ApValue(start:Float, end:Float, shift:Float):Float {
		if (start < end) {
			return	Math.min(start + shift, end);
		}
		else {
			return Math.max(start - shift, end);
		}
	} 
}


*/


class Test {
    static function main() {
        var dt:Float = 1/60;
        var m:Float = 60;
        var speed:Float = 0;
        var accel:Float = 1 * m;
        var friction:Float = 1.9 * m;
        var maxSpeed:Float = 7 * m;
        var dragdamping:Float = 0.8 * m;
        var timer:Float = 0;
        var _speed:Float = 1/ 0.116666666666666666;
        
        trace('dt = ' + dt);
        trace('speed = ' + speed);
        trace('accel = ' + accel);
        trace('friction = ' + friction);
        trace('maxSpeed = ' + maxSpeed);
            
        trace('');
		trace('accel Right');
        speed = 0;
        while(speed < maxSpeed){
            speed = ApValue(speed, maxSpeed, accel);
            trace(speed); 
        }
          
        speed = maxSpeed;
        trace('');
		trace('app fric');
        while(speed > 0){
            speed = ApValue(speed, 0, friction);
            trace(speed); 
        }

        timer = 0;
        speed = 0;
        trace('');
		trace('clamp time');
        while(speed < maxSpeed){
			timer = clamp(timer + dt, 0.0, 1.0/_speed);
			speed = lerp(0, maxSpeed, timer  * _speed);
            //trace('timer =' + timer * _speed);
            trace('speed = ' + speed);

		}

    }
    
    inline public static function ApValue(start:Float, end:Float, shift:Float):Float {
		if (start < end) {
			return	Math.min(start + shift, end);
		}
		else {
			return Math.max(start - shift, end);
		}
	} 

    static inline public function clamp( value:Float, a:Float, b:Float ) : Float {
        return ( value < a ) ? a : ( ( value > b ) ? b : value );
    } //clamp
    

    static inline public function lerp( value:Float, target:Float, t:Float ) {

        t = clamp(t, 0, 1);

        return (value + t * (target - value));

    } //lerp

    static inline public function QuintOut (k:Float):Float {
        return --k * k * k * k * k + 1;
    }
    
}
