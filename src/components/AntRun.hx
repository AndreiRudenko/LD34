package components;

import luxe.Component;
import luxe.Entity;
import luxe.Vector;
import luxe.Input;
import luxe.utils.Maths;
import utils.Mathf;
import physics.Body;

class AntRun extends Component{
    public var active:Bool;

    public var speed:Float;

    var collider:EnemyCollider;

    var body:Body;
    var aInput:AntInput;

    var accel:Float;
    var friction:Float;

    public function new(){
        super({name : 'AntRun'});
    }

    override public function init() {
        // trace(entity.name + ' init Run');

        aInput = get("AntInput");
        if(aInput == null) throw(entity.name + " AntRun must have AntInput component");

        collider = get("Collider");
        if(collider == null) throw(entity.name + " AntRun must have Collider component");

        body = collider.body;

        active = true;

        var m:Float = 60;
        accel = 2 * m;
        friction = 0.1 * m;

        speed = 4 * m;


    }

    override public function update(dt:Float) {
        // trace('Run update');
        if(!active || entity.destroyed) return;

            // accel = airAccel;
            // friction = airFriction;
            // aInput.moveDirection.x = 1;
        if(speed > 0) {
            if(aInput.moveDirection.x > 0 && body.velocity.x <= speed){
                // if(body.velocity.x < 0) {
                //     body.velocity.x = Mathf.ApFrictionT(body.velocity.x, friction, dt);
                // }
                body.velocity.x = Mathf.ApValueT(body.velocity.x, speed, accel, dt);
            } else if(aInput.moveDirection.x < 0 && body.velocity.x >= -speed){
                if(body.velocity.x > 0) {
                    // body.velocity.x = Mathf.ApFrictionT(body.velocity.x, friction, dt);
                }
                body.velocity.x = Mathf.ApValueT(body.velocity.x, -speed, accel, dt);
            } else {
                // body.velocity.x = Mathf.ApFrictionT(body.velocity.x, friction, dt);

            }
        }

        if(speed > 0) {
            if(aInput.moveDirection.y > 0){
                // if(body.velocity.y < 0) {
                //     body.velocity.y = Mathf.ApFrictionT(body.velocity.y, friction, dt);
                // }
                body.velocity.y = Mathf.ApValueT(body.velocity.y, speed, accel, dt);
            } else if(aInput.moveDirection.y < 0 ){
                if(body.velocity.y > 0) {
                    // body.velocity.y = Mathf.ApFrictionT(body.velocity.y, friction, dt);
                }
                body.velocity.y = Mathf.ApValueT(body.velocity.y, -speed, accel, dt);
            } else {
                // body.velocity.y = Mathf.ApFrictionT(body.velocity.y, friction, dt);
            }
        }
    }

}
