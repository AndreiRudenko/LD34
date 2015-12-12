package physics;

import luxe.Vector;
import luxe.utils.Maths;
import physics.Contact;

import helpers.DebugDrawer;

class SCDL {
	
	public static inline var EPSILON:Float = 1.0E-9;

	// ----------------------------------- Circle Circle ----------------------------------- //

    public static function testCircleCircle(contact:Contact) : Bool {
    	contact.update();

		var circle1:Body = contact.bodyA;
		var circle2:Body = contact.bodyB;

            //add both radii together to get the colliding distance
        var totalRadius:Float = circle1.radius + circle2.radius;
            //find the distance between the two circles using Pythagorean theorem. No square roots for optimization
        var distancesq:Float = (circle1.position.x - circle2.position.x) * (circle1.position.x - circle2.position.x) +
        (circle1.position.y - circle2.position.y) * (circle1.position.y - circle2.position.y);

            //if your distance is less than the totalRadius square(because distance is squared)
        if(distancesq < totalRadius * totalRadius) {

                //find the difference. Square roots are needed here.
            var difference:Float = totalRadius - Math.sqrt(distancesq);

            		// find collision normal
                contact.normal.x = circle1.position.x - circle2.position.x;
                contact.normal.y = circle1.position.y - circle2.position.y;
                contact.normal.normalize();

                    //find the movement needed to separate the circles
                contact.overlap.x = contact.normal.x * difference;
                contact.overlap.y = contact.normal.y * difference;

                    //the magnitude of the overlap
                contact.separation = contact.overlap.length;

	    			// find contact points
	    		contact.position.x = circle1.position.x - circle1.radius * contact.normal.x;
				contact.position.y = circle1.position.y - circle1.radius * contact.normal.y;

            return true;
        }

        return false;

    }


	// ----------------------------------- Circle Circle CCD ----------------------------------- //

	public static function sweepCircleCircle(contact:Contact, dt:Float):Bool {
		contact.update();

		var velocity:Vector = contact.velocity.multiplyScalar(dt);
		var circle1:Body = contact.bodyA;
		var circle2:Body = contact.bodyB;

	    var s:Vector = Vector.Subtract(circle2.position, circle1.position); // vector between the centers of each sphere
	    var r:Float = circle2.radius + circle1.radius;

	    var c:Float = s.dot(s) - r * r;
	    if (c < 0.0) { 
	    	// they already overlap
	        return false;
	    }

	    var b:Float = velocity.dot(s);
	    if (b >= 0.0){
	    	// does not move towards each other
	        return false;
	    }

	    // var a:Float = velocity.dot(velocity);
	    var a:Float = velocity.lengthsq;

	    var d:Float = b * b - a * c;
	    if (d < 0.0){
	        return false;
	    }

	    contact.tfirst = (-b - Math.sqrt(d)) / a;

	    if(contact.tfirst <= 0 || contact.tfirst > 1){
	    	return false;
	    }

		s.normalize();
        contact.normal.copy_from(s);

		contact.position.x = (circle1.position.x + circle1.velocity.x * dt * contact.tfirst) + circle1.radius * contact.normal.x;
		contact.position.y = (circle1.position.y + circle1.velocity.y * dt * contact.tfirst) + circle1.radius * contact.normal.y;

	    return true;

	}

}
