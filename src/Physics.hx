import luxe.Vector;
import physics.Space;

class Physics extends luxe.Physics.PhysicsEngine {

    public static var space : Space;
    // public var debugdraw : DebugDraw;

    public var iterations : Int = 5;

    public override function init() {

        space = new Space(iterations, Luxe.physics.step_delta);

        // gravity = new Vector(0, 180);
        // gravity = new Vector(0, 980);
        // gravity = new Vector(0, 9.807);
        // gravity = new Vector(0, 1618);
        gravity = new Vector(0, 0);
        // gravity = new Vector(0, 100);

    } //init

        //update the actual physics
    public override function update() {
        if(!paused) {
            // trace("PhysicsEngine update");

            // space.step( Luxe.physics.step_delta * Luxe.timescale);
        } //paused

    } //update

    public override function destroy() {

        space.destroy();
        space = null;

    } //destroy

        //unit's are pixels/second/second
    override function set_gravity( _gravity:Vector ) {

        if(space != null) {
            space.gravity = _gravity.clone();
        }

        return super.set_gravity(_gravity);

    } //set_gravity

    override public function set_draw(_draw:Bool):Bool {

        // if (debugdraw != null) {
        //     debugdraw.visible = _draw;
        // }

        return draw = _draw;

    } //set_draw

} //PhysicsNape
