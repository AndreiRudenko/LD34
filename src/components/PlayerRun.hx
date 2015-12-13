package components;

import luxe.Component;
import luxe.Entity;
import luxe.Vector;
import luxe.Input;
import luxe.utils.Maths;
import utils.Mathf;
import physics.Body;

class PlayerRun extends Component{
    public var active:Bool;

    public var speed:Float;

    var pbody:PlayerBody;

    var body:Body;
    var pInput:PlayerInput;

    public var accel:Float;
    var friction:Float;
    var mainSpeed:Float;

    public function new(){
        super({name : 'Run'});
    }

    override public function init() {
        // trace(entity.name + ' init Run');

        pInput = get("PlayerInput");
        if(pInput == null) throw(entity.name + " Run must have PlayerInput component");

        pbody = get("PlayerBody");
        if(pbody == null) throw(entity.name + " Run must have PlayerBody component");

        body = pbody.head.body;

        active = true;

        var m:Float = 60;
        // accel = 40 * m;
        friction = 0.1 * m;

        // speed = 5 * m;
        speed = 0.5;

        accel = 4;

        mainSpeed = 0;
        // friction = 0.01;

    }

    override public function update(dt:Float) {
        // trace('Run update');
        if(!active) return;

            // accel = airAccel;
            // friction = airFriction;
        mainSpeed = Main.speed;
        
        if(speed > 0) {
            if(pInput.moveDirection.x > 0 && body.velocity.x <= speed * mainSpeed){
                if(body.velocity.x < 0) {
                    body.velocity.x = Mathf.ApFrictionT(body.velocity.x, friction, dt);
                }
                body.velocity.x = Mathf.ApValueT(body.velocity.x, speed * mainSpeed, accel * mainSpeed, dt);
            } else if(pInput.moveDirection.x < 0 && body.velocity.x >= -speed * mainSpeed){
                if(body.velocity.x > 0) {
                    body.velocity.x = Mathf.ApFrictionT(body.velocity.x, friction, dt);
                }
                body.velocity.x = Mathf.ApValueT(body.velocity.x, -speed * mainSpeed, accel * mainSpeed, dt);
            } else {
                body.velocity.x = Mathf.ApFrictionT(body.velocity.x, friction, dt);
            }
        }

        // if(pInput.moveDirection.x < 0){
        //     body.velocity.x += 100;
        // }
/*
        if(allowY && speed.y > 0) {
            if(pInput.moveDirection.y > 0){
                if(body.velocity.y < 0) {
                    body.velocity.y = Mathf.ApFrictionT(body.velocity.y, friction, dt);
                }
                body.velocity.y = Mathf.ApValueT(body.velocity.y, speed.y, accel, dt);
            } else if(pInput.moveDirection.y < 0 ){
                if(body.velocity.y > 0) {
                    body.velocity.y = Mathf.ApFrictionT(body.velocity.y, friction, dt);
                }
                body.velocity.y = Mathf.ApValueT(body.velocity.y, -speed.y, accel, dt);
            } else {
                body.velocity.y = Mathf.ApFrictionT(body.velocity.y, friction, dt);
            }
        }*/
    }

}
