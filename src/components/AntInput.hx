package components;

// import luxe.Events;
import luxe.Input;
import luxe.Vector;
import luxe.Component;

class AntInput extends Component {

    public var moveDirection:Vector;

	public function new():Void {
		super({name : 'AntInput'});
        moveDirection = new Vector();
	}

	override function init(){
	}

	override function update(dt:Float) {
	}

}
