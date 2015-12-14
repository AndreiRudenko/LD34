package game;

import luxe.Input;
import luxe.Vector;
import components.Collider;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.resource.Resource;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Camera;
import utils.Fps;
import entities.Circle;
import entities.Player;
import entities.Ant;


class Spawner  {
    public var rocksAmount:Int;
    public var sandAmount:Int;
    public var antsAmount:Int;
    var diffMaxDist:Float = 70;
    var dDist:Float = 0;
    var diff:Array<Int>;
    var diffNum:Int = 0;

    public function new(){
        diff = [1,2,3,1,3,4,2,4,5,1,2,4,2,3,5,2,1,3,4,1,3,4,2,4,5,1,4,5,2,3,6,2,2,2,3,5,2,1,3,4,1,3,4,2,4,6,1,4,5,2,3,6,2,1,3,4,2,1,7,6,3,1,2];
        rocksAmount = 2;
        sandAmount = 2;
        antsAmount = 2;
        dDist = diffMaxDist;
    }

    public function spawn() {

        if(Main.score > dDist){
            dDist += diffMaxDist;

            diffNum++;
            if(diffNum >= diff.length-1){
                diffNum = 0;
            }
            rocksAmount = diff[diffNum];
            sandAmount = diff[diffNum];
            antsAmount = diff[diffNum];
        }

        spawnRocks(Std.random(2) + Std.random(rocksAmount), Std.random(rocksAmount) + Std.random(rocksAmount));
        spawnSand(Std.random(3) + Std.random(sandAmount), Std.random(sandAmount) + Std.random(sandAmount));
        spawnAnts(Std.random(2) + Std.random(antsAmount), Std.random(antsAmount) + Std.random(antsAmount));
    }

    public function reset() {
        rocksAmount = 2;
        sandAmount = 2;
        antsAmount = 2;
        dDist = diffMaxDist;
        diffNum = 0;
    }


    function spawnRocks(_num1:Int, _num2:Int) {
        for (i in 0..._num1) {
            var rX:Float = Std.random(360);
            var rY:Float = Std.random(400)-500;
            for (j in 0..._num2) {
                new Circle({
                    name : 'Circle' + i,
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    pos: new Vector(Std.random(24) + rX - 24 , Std.random(24) + rY - 24),
                    radius: Std.random(24) + 16,
                    depth:2,
                    // texture:Luxe.resources.texture('assets/circle.png')
                });
            }
        }
    }

    function spawnSand(_num1:Int, _num2:Int) {
        for (i in 0..._num1) {
            var rX:Float = Std.random(360);
            var rY:Float = Std.random(400)-500;
            for (j in 0..._num2) {
                new Circle({
                    name : 'Circle' + i,
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    pos: new Vector(Std.random(64) + rX - 64 , Std.random(64) + rY - 64),
                    radius: Std.random(12) + 4,
                    depth:2,
                    // texture:Luxe.resources.texture('assets/circle.png')
                });
            }
        }
    }

    function spawnAnts(_num1:Int, _num2:Int) {
        for (i in 0..._num1) {
            var rX:Float = Std.random(360);
            var rY:Float = Std.random(400)-500;
            for (j in 0..._num2) {
                new Ant({
                    name : 'Ant' + i,
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    pos: new Vector(Std.random(64) + rX - 64 , Std.random(64) + rY - 64),
                    radius: Std.random(8) + 8,
                    depth:2,
                    // texture:Luxe.resources.texture('assets/circle.png')
                });
            }
        }
    }

}
