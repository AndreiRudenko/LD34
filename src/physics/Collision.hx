package physics;

import luxe.Vector;
import luxe.utils.Maths;
import physics.SCDL;

class Collision {

	public static function IntersectCCD(contact:Contact, dt:Float):Bool {
		return SCDL.sweepCircleCircle(contact, dt);
	}

	public static function IntersectDiscrete(contact:Contact):Bool {
		return SCDL.testCircleCircle(contact);
	}

}