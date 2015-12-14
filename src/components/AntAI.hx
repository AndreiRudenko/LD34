package components;

import luxe.Component;
import luxe.Sprite;
import luxe.Entity;
import luxe.Vector;
import luxe.Input;
import luxe.utils.Maths;
import utils.Mathf;
import physics.Body;

class AntAI extends Component{
    public var active:Bool;

    public var speed:Float;
    var seeDist:Float;

    var collider:EnemyCollider;

    var body:Body;
    var aInput:AntInput;
    var playerPos:Vector;
    var distance:Float;
    var sprite : Sprite;

    var movementTime:Float = 3;
    var mTimer:Float = 0;

    public function new(){
        super({name : 'AntAI'});
    }

    override public function init() {
        // trace(entity.name + ' init Run');

        aInput = get("AntInput");
        if(aInput == null) throw(entity.name + " AntAI must have AntInput component");

        sprite = cast entity;

        seeDist = 200;
        playerPos = Main.playerPos;
    }

    override public function update(dt:Float) {
        distance = Mathf.distance(pos, playerPos);

        if(distance < seeDist){
            var angle:Float = Mathf.angle(pos, playerPos);
            sprite.rotation_z = Maths.degrees(angle) - 90;

            if(pos.x - Main.playerPos.x > 0){
                aInput.moveDirection.x = -1;
            } else if(pos.x - Main.playerPos.x < 0){
                aInput.moveDirection.x = 1;
            } else {
                // aInput.moveDirection.x = 0;
            }
            if(pos.y - Main.playerPos.y > 0){
                aInput.moveDirection.y = -1;
            } else if(pos.y - Main.playerPos.y < 0){
                aInput.moveDirection.y = 1;
            } else {
                // aInput.moveDirection.y = 0;
            }  
        } else {
            if(mTimer >= movementTime * Math.random() + 1){
                aInput.moveDirection.x = Math.random() - 0.5;
                aInput.moveDirection.y = Math.random() - 0.5;  
                mTimer = 0;
            }
            mTimer += dt;

            var angle:Float = Mathf.angle(pos, Vector.Add(pos, aInput.moveDirection));
            sprite.rotation_z = Maths.degrees(angle) - 90;
        }

        // aInput.moveDirection.x
    }

}
