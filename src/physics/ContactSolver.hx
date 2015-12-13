package physics;

import luxe.Vector;
import luxe.utils.Maths;
import utils.DebugDrawer;

class ContactSolver {
	var contacts : Map<Int, Contact>;

	var corPerc:Float = 0.5; // 0.8 // usually 20% to 80%
	var corSlop:Float = 0.01; // 0.05 // usually 0.01 to 0.1

	public function new( _contacts : Map<Int, Contact>) {
		contacts = _contacts;
	}

	public function solveVelocity(iterations:Int){
		for (c in contacts) {
			if(Collision.IntersectDiscrete(c)){
				c.isCollide = true;
			}
		}

		for (i in 0...iterations) {
			for (c in contacts) {
			    if(!c.isCollide) continue;
			    solveContactVelocity(c);
			}
		}
	}


	public function solveContactVelocity(c:Contact){
		if(c.invMass == 0) return;

		var bodyA:Body = c.bodyA;
		var bodyB:Body = c.bodyB;

		c.velocity.x = (bodyB.velocity.x - bodyA.velocity.x);
		c.velocity.y = (bodyB.velocity.y - bodyA.velocity.y);

		var normVel:Float = c.velocity.dot(c.normal);
		if (normVel > 0) {
			return;
		}

		if(!bodyA.isStatic && !bodyB.isStatic){
			var normImp:Float = (-(1 + c.restitution) * normVel) / c.invMass;

			var impx:Float = c.normal.x * normImp;
			var impy:Float = c.normal.y * normImp;

			bodyA.velocity.x -= impx * bodyA.invMass;
			bodyA.velocity.y -= impy * bodyA.invMass;

			bodyB.velocity.x += impx * bodyB.invMass;
			bodyB.velocity.y += impy * bodyB.invMass;

			// var normImp:Float = (-(1 + c.restitution) * normVel) * 0.5;

			// var impx:Float = c.normal.x * normImp;
			// var impy:Float = c.normal.y * normImp;

			// bodyA.velocity.x -= impx;
			// bodyA.velocity.y -= impy;

			// bodyB.velocity.x += impx;
			// bodyB.velocity.y += impy;

		} else if (!bodyA.isStatic){

			var normImp:Float = (-(1 + c.restitution) * normVel);
			var impx:Float = c.normal.x * normImp;
			var impy:Float = c.normal.y * normImp;

			bodyA.velocity.x -= impx;
			bodyA.velocity.y -= impy;
		} else if (!bodyB.isStatic){

			var normImp:Float = (-(1 + c.restitution) * normVel);
			var impx:Float = c.normal.x * normImp;
			var impy:Float = c.normal.y * normImp;

			bodyB.velocity.x += impx;
			bodyB.velocity.y += impy;
		}
	}

	public function solvePosition(iterations:Int){

		var bodyA:Body;
		var bodyB:Body;

		for (i in 0...iterations) {
			for (c in contacts) {

				if(!Collision.IntersectDiscrete(c)) continue;
	    		if(c.separation <= 0 || c.invMass == 0) continue;

				bodyA = c.bodyA;
				bodyB = c.bodyB;

				// var slope:Float = Math.max(c.separation - corSlop, 0) * contactBaumgarte;
				var slope:Float = Math.max(c.separation - corSlop, 0);
				var corx:Float = c.normal.x * slope / c.invMass * corPerc;
				var cory:Float = c.normal.y * slope / c.invMass * corPerc;

	    		if(!bodyA.isStatic){
					bodyA.position.x -= bodyA.invMass * corx;
					bodyA.position.y -= bodyA.invMass * cory;
	    		}	    		
	    		if(!bodyB.isStatic){
					bodyB.position.x += bodyB.invMass * corx;
					bodyB.position.y += bodyB.invMass * cory;
	    		}
			}
		}
	}


	public function postSolve(dt:Float){
		for (c in contacts) {
			if(c.isCollide){
				// Collision.SetEdgeCollision(c);
				// ApplyFriction(c, dt);
				c.bodyA.onCollisionEventFire(c.bodyB, c);
				c.bodyB.onCollisionEventFire(c.bodyA, c);

			}
			c.isCollide = false;
			// c.draw();
		}
	}

	public function solveCCD(dt:Float){

		var iters:Int = 0;

		var subTime:Float = 1;
		var minTOI:Float = 1;
		var minContact:Contact = null;

		while(true) {
			iters++;

			if(iters > 30){
				break;
			}

			minTOI = 1;
			minContact = null;
			
			// находим минимальное время столкновения min TOI
			for (c in contacts) {
				if(Collision.IntersectCCD(c ,dt * subTime)){
					if(c.tfirst <= minTOI && c.tfirst > 0.000001){
						minTOI = c.tfirst;
						minContact = c;
					}
				}
			}

			// двигаем все тела на протяжении этого времени TOI
			for (b in Physics.space.bodies) {
				if(!b.isStatic){
					b.updatePosition(dt * minTOI * subTime);
				}
			}

			if(minContact == null) break;

			// initialiseCCD(minContact);
			// solveVelocityCCD(minContact);

			subTime *= 1 - minTOI;

			// trace('subTime = ' + subTime);

			if(subTime == 0) break;

			// обновляем контакты
			for (b in Physics.space.bodies) {
				if(!b.isStatic){
					b.updateAABB(dt);
				}
			}

	    	Contact.clearContacts(contacts);

		}
		// trace('CCD Iters = ' + iters);

	}

}
