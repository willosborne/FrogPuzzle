package object; 

import flixel.util.FlxColor;

import base.PlatformObject;

class Tree extends PlatformObject
{
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY, rotates);
        
        makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.BROWN);
        centerOrigin();
    }

    override public function hasObject()
    {
        // cannot remove object; always blocked
        return true;
    }
}