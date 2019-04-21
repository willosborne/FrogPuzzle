package object; 

import flixel.util.FlxColor;

import base.NormalObject;

@:keep
class Goal extends NormalObject
{   
    @:keep
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);
        
        // makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.YELLOW);
        // centerOrigin();
        set_visible(false);
    }

    override public function onBump() 
    {
        trace("Win");
    }
}