
import luxe.Input;
import components.Collider;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.resource.Resource;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Camera;
import helpers.Fps;

class Main extends luxe.Game {
    public static var hud_batcher:Batcher;

    override function ready() {
        // Luxe.renderer.vsync = true;

        Luxe.physics.add_engine( Physics );
        Luxe.resources.load_json('assets/parcel.json').then(function(json:JSONResource) {
            var parcel = new Parcel();
            parcel.from_json(json.asset.json);

            var progress = new ParcelProgress({
                parcel      : parcel,
                background  : new Color(1,1,1,0.85),
                oncomplete  : assets_loaded
            });
            parcel.load();
        });
    }

    function assets_loaded(_) {
        create_hud();

    }

    function create_hud() {

        hud_batcher = new Batcher(Luxe.renderer, 'hud_batcher');
        var hud_view = new Camera();
        hud_batcher.view = hud_view;
        hud_batcher.layer = 2;
        Luxe.renderer.add_batch(hud_batcher);

        var fps:Fps = new Fps(hud_batcher);
    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    override function update(dt:Float) {

    }


}
