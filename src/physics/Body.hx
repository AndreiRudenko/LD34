package physics;

import luxe.Component;
import luxe.Entity;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.utils.Maths;
import luxe.Log;
import physics.Space;
import physics.AABB;
import physics.Contact;
import helpers.DebugDrawer;

class Body {
    public static var ID (default, null):Int = 0;

    public var id(default, null):Int;
    public var tag:String;

    public var space( default, set ):Space;
    public var aabb( default, null ):AABB;

    public var gravityScale:Float;
    public var velocity:Vector;
    public var position:Vector;
    public var nextPos:Vector;
    var force:Vector;

    @:isVar public var mass( default, set ):Float;
    public var invMass( default, null ):Float;

    public var maxSpeed:Vector;
    public var damping:Float;

    public var isStatic:Bool; 
    public var isSensor:Bool; 
    public var deleted:Bool; 

// Circle 
    public var radius:Float;

// Material
    public var restitution:Float;

//
    public var contactsArray:Array<Contact>;

    public var collisionGroup:Int;
    public var collisionMask:Int;

// for broadphase
    public var gridIndex:Array<Int>;

    public function new(_options:BodyOptions){
        id = ID++;
        tag = Log.def(_options.tag, '');

        space = _options.space;

        position = Log.def(_options.position, new Vector(100, 100));
        nextPos = position.clone();
        velocity = new Vector();
        force = new Vector();


        radius = Log.def(_options.radius, 16);
        mass = Log.def(_options.mass, 10);
        damping = Log.def(_options.damping, 0);
        gravityScale = Log.def(_options.gravityScale, 1);
        maxSpeed = Log.def(_options.maxSpeed, new Vector(10000, 10000));
        isStatic = Log.def(_options.isStatic, false);
        isSensor = Log.def(_options.isSensor, false);

        collisionGroup = Log.def(_options.collisionGroup, 0x00000001);
        collisionMask = Log.def(_options.collisionMask, 0xFFFFFFFF);

        restitution = Log.def(_options.restitution, 0);

        aabb = new AABB(position);
        aabb.half.set_xy(radius + 2, radius + 2);

        contactsArray = [];
        gridIndex = [];

        deleted = false;

        space.addBody(this);
    }

    public function destroy() {

        position = null;
        velocity = null;
        force = null;
        maxSpeed = null;
        space = null;
    }

    inline public function updateVelocity(dt:Float){

        velocity.x += (space.gravity.x * gravityScale + force.x * invMass) * dt;
        velocity.y += (space.gravity.y * gravityScale + force.y * invMass) * dt;

        velocity.x = Maths.clamp(velocity.x, -maxSpeed.x, maxSpeed.x);
        velocity.y = Maths.clamp(velocity.y, -maxSpeed.y, maxSpeed.y);

        velocity.x *= Maths.clamp(1.0 - dt * damping, 0.0, 1.0);
        velocity.y *= Maths.clamp(1.0 - dt * damping, 0.0, 1.0);

        force.x = 0;
        force.y = 0;

        updateAABB(dt);

        DebugDrawer.draw_circle(position, radius, DebugDrawer.color_yellow);
    }

    inline public function updatePosition(dt:Float){
		position.x += velocity.x * dt;
		position.y += velocity.y * dt;
    }

    inline public function updateAABB(dt:Float){

        nextPos.x = position.x + velocity.x * dt;
        nextPos.y = position.y + velocity.y * dt;

        aabb.center.x = (position.x + nextPos.x) * 0.5;
        aabb.center.y = (position.y + nextPos.y) * 0.5;

        aabb.half.x = Math.abs(position.x - nextPos.x) + radius + 2;
        aabb.half.y = Math.abs(position.y - nextPos.y) + radius + 2;

        // update broadphase
        space.broadphase.updateBody(this);
    }

    public function resetGridIndex(){
        gridIndex.splice(0, gridIndex.length);
    }

    // force
    inline public function addForce(_x:Float, _y:Float){
        force.x += _x;
        force.y += _y;
    }

    inline public function addForceVec(v:Vector){
        force.add(v);
    }

    inline public function setForce(_x:Float, _y:Float){
        force.x = _x;
        force.y = _y;
    }

    inline public function setForceVec(v:Vector){
        force.copy_from(v);
    }

    // velocity
    inline public function addVelocity(_x:Float, _y:Float){
        velocity.x += _x;
        velocity.y += _y;
    }

    inline public function addVelocityVec(v:Vector){
        velocity.add(v);
    }

    inline public function setVelocity(_x:Float, _y:Float){
        velocity.x = _x;
        velocity.y = _y;
    }

    inline public function setVelocityVec(v:Vector){
        velocity.copy_from(v);
    }

    public function set_space(_space:Space):Space{
        if(space != null){
            space.removeBody(this);
            space = _space;
            space.addBody(this);
        } else {
            space = _space;
        }

        return space;
    }

    // getter setter

    function set_mass(_value:Float):Float{
        if(_value <= 0 ){
            mass = 0;
            invMass = 0;
        } else {
            mass = _value;
            invMass = 1.0/mass;
        }
        return mass;
    }
}

typedef BodyOptions = {

    var space : Space;
    var position : Vector;
    @:optional var tag : String;
    @:optional var gravityScale : Float;
    @:optional var radius : Float;
    @:optional var mass : Float;
    @:optional var damping : Float;
    @:optional var restitution : Float;
    @:optional var maxSpeed : Vector;
    @:optional var isStatic : Bool;

    @:optional var isSensor : Bool;
    @:optional var collisionGroup : Int;
    @:optional var collisionMask : Int;
}
