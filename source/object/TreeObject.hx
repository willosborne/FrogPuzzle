package object; 

import flixel.util.FlxColor;

import base.NormalObject;
import base.BumpAction;

/**
The bit on top of a tree that actually blocks stuff. Also draws the tree itself
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