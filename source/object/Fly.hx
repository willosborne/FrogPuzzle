package object; 

import flixel.util.FlxColor;

import base.FloatingObject;
import base.NormalObject;

import object.Player;

@:keep
class Fly extends FloatingObject 
{   
    @:keep
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);
        
        // makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.YELLOW);
        // centerOrigin();
        // loadGraphic(AssetPaths.goal__png, false, 24, 24);
        loadGraphic("assets/images/fly.png", false, 24, 24);
    }

    override public function onHover(obj:NormalObject)
    {
        if (Std.is(obj, Player))
        {
            this.kill();
            state.flies++;
            state.clearFloater(gridX, gridY);
        }
    }
}