package components;

import luxe.Input;
import luxe.Component;
import physics.Body;
import luxe.utils.Maths;

class EnemyCollider extends Collider{

    public function new(_opt:Collider.ColliderOptions){
        // super({name : "Collider"});
        _options = _opt;
        super(_options);
    }

    override function init(){
        super.init();
    }
    
    override public function onremoved() {
        super.onremoved();
    }

    override public function ondestroy() {
        super.ondestroy();

        // body.destroy();
        // body = null;
        // _options = null;
    }

    override function update(dt:Float) {
        
        super.update(dt);
        // body.velocity.y = Main.speed;
        // body.velocity.y += 10;
        // body.position.y += 1;
        // body.velocity.x = 0;
        if(body.position.y > Luxe.screen.h + body.radius){
            entity.destroy();
        }
        // trace('vel = ' + body.velocity.y);
    }

}