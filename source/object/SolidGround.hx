package object; 

import flixel.util.FlxColor;

import base.PlatformObject;

class SolidGround extends PlatformObject
{
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);
        
        // makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.GRAY);
        // centerOrigin();
    }
}