package physics;

import luxe.Vector;

class AABB{

	@:isVar public var max (get, never) : Vector;
	@:isVar public var min (get, never) : Vector;
	@:isVar public var size (get, never) : Vector;

	public var center:Vector;
	public var half:Vector;

	public function new(?_pos:Vector, ?_half:Vector) {
		center =  _pos != null ? _pos.clone() : new Vector();
		half =  _half != null ? _half.clone() : new Vector(64,64);
	}

	public function clone():AABB{
	    var clone:AABB = new AABB(center, half);
		return clone;
	}

	public function destroy(){
		center = null;
		half = null;
	}
	
	function get_max():Vector {
		return Vector.Add(center, half);
	}

	function get_min():Vector {
		return Vector.Subtract(center, half);
	}

	function get_size():Vector {
		return Vector.Add(half, half);
	}

}
