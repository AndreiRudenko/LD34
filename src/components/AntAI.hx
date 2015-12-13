package components;

import luxe.Component;
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

    public function new(){
        super({name : 'AntAI'});
    }

    override public function init() {
        // trace(entity.name + ' init Run');

        aInput = get("AntInput");
        if(aInput == null) throw(entity.name + " AntAI must have AntInput component");

        seeDist = 200;
        playerPos = Main.playerPos;
    }

    override public function update(dt:Float) {
        distance = Mathf.distance(pos, playerPos);

        if(distance < seeDist){
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
            aInput.moveDirection.x = Math.random() - 0.5;
            aInput.moveDirection.y = Math.random() - 0.5;
        }

        // aInput.moveDirection.x
    }

}
