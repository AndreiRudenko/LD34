package physics;

import luxe.Input;
import luxe.Color;
import luxe.Vector;
import luxe.Text;
import luxe.utils.Maths;
import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;
import phoenix.geometry.TextGeometry;
import utils.DebugDrawer;

class SpatialHash {
		/* the square cell gridLength of the grid. Must be larger than the largest shape in the space. */
	public var cellSize(default, null):Int;
		/* the world space width */
	public var gridWidth (default, null):Int;
		/* the world space height */
	public var gridHeight (default, null):Int;
		/* the number of buckets (i.e. cells) in the spatial grid */
	public var gridLength (default, null):Int;
		/* the array-list holding the spatial grid buckets */
	public var grid : haxe.ds.Vector<Array<Body>>;

	var space:Space;
	var invCellSize:Float;
	var gridWidthRes:Float;
	var gridHeightRes:Float;

	var debugMode:Bool = true;
	// var debugMode:Bool = false;

	var debugBoxes : haxe.ds.Vector<DebugObject>;
	var collPairsText:TextGeometry;

	public function new( _w:Float, _h:Float, _cs:Int, _space:Space) {
		space = _space;

		gridWidthRes = _w;
		gridHeightRes = _h;

		cellSize = _cs;
		invCellSize = 1 / cellSize;

		gridWidth = Math.ceil(_w * invCellSize);
    	gridHeight = Math.ceil(_h * invCellSize);

    	gridLength = Std.int(gridWidth * gridHeight);

    	grid = new haxe.ds.Vector(gridLength);

    	for (i in 0...gridLength) {
    		grid[i] = new Array<Body>();
    	}

    	if(debugMode){
    		collPairsText =  Luxe.draw.text({
		    	pos : new Vector(100,100),
		    	text : "collision_pairs = ",
		    	point_size : 16
		    });

    		debugBoxes = new haxe.ds.Vector(gridLength);

    		var iw:Int = 0;
	    	var ih:Int = 0;
	    	for (i in 0...gridLength) {

	    		debugBoxes[i] = new DebugObject(new Vector((cellSize*0.5) + cellSize * iw, (cellSize*0.5) + cellSize * ih), cellSize);

	    		iw++;
	    		if(iw >= gridWidth){
	    			iw = 0;
	    			ih++;
	    		}
	    	}
    	}
	}

	function getBodyCollision(bodyA:Body) {
		// добавление
		// проверяем все яйчейки
		for (i in bodyA.gridIndex) {
			// проверяем есть ли ктото в этой яйчейке
			if(grid[i].length == 0) continue;
			// проверяем кто есть в ней
			for (bodyB in grid[i]) {
				// проверяем на маски
				if(shouldCollide(bodyB, bodyA)){
					// добавляем
					Contact.addContact(bodyA, bodyB, space.contacts);
				}
			}
		}

		if(debugMode){
			collPairsText.text = "collision_pairs = " + space.contactsCount;
		}
		// return null;

	}

	public function addBody(b:Body){
		updateIndexes(b, aabbToGrid(b.aabb.min.add_xyz(1,1), b.aabb.max.subtract_xyz(1,1) ));
	}

	public function removeBody(b:Body):Void{
		removeIndexes(b);
	}

	public function updateBody(b:Body){
		// if(b.isStatic) return;
		updateIndexes(b, aabbToGrid(b.aabb.min, b.aabb.max));
		getBodyCollision(b);
	}

	public function clear(){
	    for (cell in grid) {
	    	if(cell.length > 0){
	    		for (co in cell) {
	    			co.gridIndex.splice(0, co.gridIndex.length);
	    		}
	    		cell.splice(0, cell.length);
	    	}
	    }
	}

	inline function getIndex1DVec(_pos:Vector):Int { // i = x + w * y;  x = i % w; y = i / w;
		return Std.int(Math.floor(_pos.x  * invCellSize) + gridWidth * Math.floor(_pos.y  * invCellSize) );
	}

	inline function getIndex(_pos:Float):Int {
		return Std.int(_pos * invCellSize);
	}

	inline function getIndex1D(_x:Int, _y:Int):Int { // i = x + w * y;  x = i % w; y = i / w;
		return Std.int(_x + gridWidth * _y);
	}

	function updateIndexes(b:Body, _ar:Array<Int>) {
		for (i in b.gridIndex) {
			removeIndex(b, i);
		}
		b.resetGridIndex();
		for (i in _ar) {
			addIndex(b, i);
		}
	}

	function addIndex(b:Body, _cellPos:Int){
	    grid[_cellPos].push(b);
	    b.gridIndex.push(_cellPos);
	}

	function removeIndexes(b:Body){
		for (i in b.gridIndex) {
			removeIndex(b, i);
		}
		b.resetGridIndex();
	}

	function removeIndex(b:Body, _pos:Int) {
		resetCellDebug(_pos);
		grid[_pos].remove(b);
		// b.gridIndex.remove(_pos);
	}

	function aabbToGrid(_min:Vector, _max:Vector):Array<Int> {
		var arr:Array<Int> = [];

		var aabbMinX:Int = Maths.clampi(getIndex(_min.x), 0, gridWidth-1);
		var aabbMinY:Int = Maths.clampi(getIndex(_min.y), 0, gridHeight-1);
		var aabbMaxX:Int = Maths.clampi(getIndex(_max.x), 0, gridWidth-1);
		var aabbMaxY:Int = Maths.clampi(getIndex(_max.y), 0, gridHeight-1);

		var aabbMin:Int = getIndex1D(aabbMinX, aabbMinY);
		var aabbMax:Int = getIndex1D(aabbMaxX, aabbMaxY);

		arr.push(aabbMin);
		if(aabbMin != aabbMax) {
			arr.push(aabbMax);

			var lenX:Int = aabbMaxX - aabbMinX + 1;
			var lenY:Int = aabbMaxY - aabbMinY + 1;
			for (x in 0...lenX) {
				for (y in 0...lenY) {
					// пропускаем добавленые
					if((x == 0 && y == 0) || (x == lenX-1 && y == lenY-1) ){
						continue;
					}
					arr.push(getIndex1D(x, y) + aabbMin);
				}
			}
		}

		return arr;
	}

	inline function isValidGridPos(num:Int, max:Int):Bool {
		if(num < 0 || num >= max){
			return false;
		} else {
			return true;
		}
	}

	inline function clampToGridVec(_vec:Vector):Vector {
		_vec.x = Maths.clamp(_vec.x, 0, gridWidthRes-1);
		_vec.y = Maths.clamp(_vec.y, 0, gridHeightRes-1);
		return _vec;
	}

	// ---------- debug ---------- //

	function resetCellDebug(_pos:Int){
	    if(debugMode) {
			debugBoxes[_pos].text.visible = false;
			debugBoxes[_pos].box.visible = false;
		}
	}

	public function debugDraw(){
	    if(debugMode){
			for (i in 0...grid.length) {
				if(grid[i].length > 0){

			        debugBoxes[i].text.visible = true;
				    debugBoxes[i].text.text = "" + grid[i].length;
				    debugBoxes[i].box.visible = true;

				    if(grid[i].length > 1){
				    	debugBoxes[i].box.color = DebugDrawer.color_orange;

				    } else {
				    	debugBoxes[i].box.color = DebugDrawer.color_gray_01;
				    }

				}
			}
		}
	}

	function shouldCollide(bodyA:Body, bodyB:Body):Bool {
		if(bodyA == bodyB) return false;
		if(bodyA.isStatic && bodyB.isStatic) return false;

		// from box2d by Erin Catto
		return (bodyA.collisionMask & bodyB.collisionGroup) != 0 && (bodyA.collisionGroup & bodyB.collisionMask) != 0;
	}

}


class DebugObject {
	public var text:TextGeometry;
	public var box:RectangleGeometry;
	public function new(_pos:Vector, _size:Float){
		box = Luxe.draw.rectangle({
		        x : _pos.x,
		        y : _pos.y,
		        w : _size,
		        h : _size,
		        origin : new Vector(_size*0.5,_size*0.5),
		        color : DebugDrawer.color_gray_01,
		        visible : false
		    });
	    text = Luxe.draw.text({
		    	pos : _pos,
		    	text : "",
		    	visible : false,
		    	point_size : 14
		    });
	}
}
