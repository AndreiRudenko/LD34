package components;

// import luxe.Events;
import luxe.Input;
import luxe.Vector;
import luxe.Component;

class PlayerInput extends Component {

    public var moveDirection(default, null):Vector;

	public function new():Void {
		super({name : 'PlayerInput'});

        moveDirection = new Vector();
	}

	override function init()  {
        // trace(entity.name + ' init PlayerInput');
        
		if(entity.name == "Player1") {
    		Luxe.input.bind_key( entity.name + "_left",  Key.key_a );
    		Luxe.input.bind_key( entity.name + "_right", Key.key_d );
            Luxe.input.bind_key( entity.name + "_enter",  Key.enter );

		} else if(entity.name == "Player2") {
    		Luxe.input.bind_key( entity.name + "_left",  Key.key_j );
    		Luxe.input.bind_key( entity.name + "_right", Key.key_l );
            Luxe.input.bind_key( entity.name + "_enter",  Key.enter );

		}
	}

	override function update(dt:Float) {

		if ( Luxe.input.inputdown( entity.name + "_right" ) && Luxe.input.inputdown( entity.name + "_left" )){
        	if(moveDirection.x != 0){
        		moveDirection.x = 0;
        	}
        } else if( Luxe.input.inputdown( entity.name + "_left" ) ){
        	moveDirection.x = -1;
        } else if ( Luxe.input.inputdown( entity.name + "_right" ) ){
        	moveDirection.x = 1;
        } else {
        	if(moveDirection.x != 0){
        		moveDirection.x = 0;
        	}
        }
	}

}
