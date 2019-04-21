package object; 

import flixel.util.FlxColor;

import base.NormalObject;

class Goal extends NormalObject
{
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);
        
        makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.YELLOW);
        centerOrigin();
    }
}