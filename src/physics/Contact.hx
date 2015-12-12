package physics;

import luxe.Vector;
import utils.DebugDrawer;

class Contact {

	public var id:Int;

	public var isCollide:Bool;
	public var remove:Bool;

	public var bodyA:Body;
	public var bodyB:Body;

	public var position:Vector;
	public var velocity:Vector;
	public var invMass:Float;

	public var normal:Vector;
	public var overlap:Vector;
	public var separation:Float;

	public var restitution:Float;

	public var tfirst:Float;
	public var tlast:Float;


	public function new(bA:Body, bB:Body, _id:Int) {
		
		id = _id;
		bodyA = bA;
		bodyB = bB;

		separation = 0;
		overlap = new Vector();
		normal = new Vector();
		velocity = new Vector();
		position = new Vector();

		restitution = Math.max(bodyA.restitution, bodyB.restitution);
		invMass = bodyA.invMass + bodyB.invMass;
		
		remove = false;
		isCollide = false;

		// swept
		tfirst = 0;
		tlast = 1;

		bodyA.contactsArray.push(this);
		bodyB.contactsArray.push(this);
	}

	public function update(){

	    separation = 0;

		normal.x = 0;
		normal.y = 0;

		overlap.x = 0;
		overlap.y = 0;

		position.x = 0;
		position.y = 0;

		tfirst = 0;
		tlast = 1;

		velocity.x = bodyB.velocity.x - bodyA.velocity.x;
		velocity.y = bodyB.velocity.y - bodyA.velocity.y;

		invMass = bodyA.invMass + bodyB.invMass;
	}

	public function reset(){
		update();
		isCollide = false;
	}

	public function destroy(){

		if(bodyA != null) bodyA.contactsArray.remove(this);
		if(bodyB != null) bodyB.contactsArray.remove(this);

	    bodyA = null;
	    bodyB = null;
	    normal = null;
		overlap = null;
		velocity = null;
	}



	inline public static function addContact(bA:Body, bB:Body, contacts:Map<Int, Contact>):Contact{
		var _id:Int = getHash(bA.id, bB.id);

		if(contacts.exists(_id)){
			var c:Contact = contacts.get(_id);
			c.remove = false;
			return c;
		}
		var _contact:Contact = new Contact(bA, bB, _id);

	    contacts.set(_id, _contact );
		Physics.space.contactsCount++;
		// trace('addContact ' + _id);
	    return _contact;
	}

	inline public static function removeContact(con:Contact, contacts:Map<Int, Contact>){
		// trace('removeContact ' + con.id);

		con.destroy();
		contacts.remove(con.id);
		Physics.space.contactsCount--;

	}

	    // Cantor pairing function
    static function getHash( a:Int,  b:Int):Int{
        var A = 2 * a;
    	var B = 2 * b;
        if(a > b){
    		return Std.int((A * A + A + B) * 0.5);
        } else {
            return Std.int((B * B + B + A) * 0.5);
        }
	}

	inline public static function clearContacts(contacts:Map<Int, Contact>){
	    for (c in contacts) {
			if(c.remove){
				removeContact(c, contacts);
				continue;
			}
			c.reset();
			c.remove = true;
		}
	}



}

