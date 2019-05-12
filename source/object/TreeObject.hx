package object; 

import flixel.util.FlxColor;

import base.NormalObject;
import base.BumpAction;

/**
Invisible object that blocks movement and cannot be affected by anything.
**/
class TreeObject extends NormalObject 
{
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);

        loadGraphic("assets/images/tree-sheet.png", false, 24, 48);
        
        offset.set(0, 24);
    }

    override public function onBump(?dX:Int=0, ?dY:Int=0):BumpAction
    {
        return BLOCK;
    }
}