package components;

import luxe.Input;
import luxe.Log;
import luxe.Component;
import physics.Body;
import luxe.utils.Maths;

class Collider extends Component{
    public var body:Body;
    var _options:ColliderOptions;

    public function new(_opt:ColliderOptions){
        super({name : Log.def(_opt.name, "Collider")});
        _options = _opt;
        // super(_options);
    }

    override function init(){
        body = new Body({
            space : Physics.space,
            position : pos.clone(),
            tag : _options.tag, 
            radius : _options.radius,
            collisionGroup : _options.collisionGroup,
            collisionMask : _options.collisionMask,
            isSensor : _options.isSensor,
            isStatic : _options.isStatic,
            gravityScale : _options.gravityScale
            });
    }
    
    override public function onremoved() {
    }

    override public function ondestroy() {
        body.destroy();
        body = null;
        _options = null;
    }

    override function update(dt:Float) {
    	// if(body == null) return;
    	// body.velocity.x += Std.random(10) - 5;
    	// body.velocity.y += Std.random(10) - 5;

    	// if(body.position.x > Luxe.screen.w - body.radius && body.velocity.x > 0){
    	// 	body.velocity.x = 0;
    	// 	body.position.x = Luxe.screen.w - body.radius;
    	// }
    	// if(body.position.x < body.radius && body.velocity.x < 0){
    	// 	body.velocity.x = 0;
    	// 	body.position.x = body.radius;
    	// }
    	// if(body.position.y > Luxe.screen.h - body.radius && body.velocity.y > 0){
    	// 	body.velocity.y = 0;
    	// 	body.position.y = Luxe.screen.h - body.radius;
    	// }
    	// if(body.position.y < body.radius && body.velocity.y < 0){
    	// 	body.velocity.y = 0;
    	// 	body.position.y = body.radius;
    	// }

        pos.copy_from(body.position).int();

    	// if(body.position.y > Luxe.screen.h + body.radius){
    	// 	entity.destroy();
    	// }

    	// body.position.x = Maths.clamp(body.position.x, body.radius, Luxe.screen.w - body.radius);
    	// body.position.y = Maths.clamp(body.position.y, body.radius, Luxe.screen.h - body.radius);

    }

}
typedef ColliderOptions = {
    // > luxe.options.ComponentOptions,

    @:optional var name : String;
    @:optional var tag : String;

    @:optional var isSensor : Bool;
    @:optional var isStatic : Bool;

    @:optional var collisionGroup : Int;
    @:optional var collisionMask : Int;
    @:optional var radius : Float;
    @:optional var gravityScale : Float;

} //ColliderOptions