package physics;

import luxe.Vector;
import physics.Body;
import helpers.DebugDrawer;

class Space {

	public var velocityIterations:Int = 8;
	public var positionIterations:Int = 5;

	public var gravity:Vector;

	public var ccd:Bool = true;
	// public var ccd:Bool = false;

	public var bodies : haxe.ds.GenericStack<Body>;

	public var contacts : Map<Int, Contact>;
	public var contactSolver:ContactSolver;

	public var broadphase : SpatialHash;

	public var contactsCount : Float;

	public function new(_iterations:Int, _update_rate:Float) {

		bodies = new haxe.ds.GenericStack<Body>();

		contacts = new Map();
		contactSolver = new ContactSolver(contacts);
		broadphase = new SpatialHash(Luxe.screen.size.x, Luxe.screen.size.y, 32, this); // добавляется  mapManager

		gravity = new Vector(0, 980);

		contactsCount = 0;

	}

	public function addBody(b:Body){
	    bodies.add(b);
	    broadphase.addBody(b);
	}

	public function removeBody(b:Body){
		b.deleted = true;
	}

	function removeDeletedObjects() {
	    for (b in bodies) {
	    	if(b.deleted){
	    		bodies.remove(b);
	    	}
	    }
	}


	public function step(dt:Float) {
	    // trace("Space.step : start");

	    // trace("Space.step : removeDeletedObjects");
		removeDeletedObjects();

	    // trace("Space.step : updateVelocity");
	    for (b in bodies) {
	    	if(b.isStatic) continue;
			b.updateVelocity(dt);
	    }

	    // trace("Space.step : clearContacts");
	    Contact.clearContacts(contacts);

		// broadphase.debugDraw();

		contactSolver.solveVelocity(velocityIterations);

		// for (c in contacts) {
		// 	c.draw();
		// }

	    if(ccd){
			contactSolver.solveCCD(dt);
	    } else {
	    	for (b in bodies) {
				if(b.isStatic) continue;
				b.updatePosition(dt);
			}	
	    }

	    // trace("Space.step : solvePosition");
		contactSolver.solvePosition(positionIterations);

	    // trace("Space.step : postSolve");
	    contactSolver.postSolve(dt);

	}

	public function destroy(){
	    gravity = null;
		bodies = null;
		contacts = null;
		broadphase = null;
	}

}
