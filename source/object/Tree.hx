package object; 

import flixel.util.FlxColor;

import base.PlatformObject;

class Tree extends PlatformObject
{
    //TODO depth sorting 
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);

        
        // loadGraphic("assets/images/tree-sheet.png", false, 24, 48);
        
        // offset.set(0, 24);
        set_visible(false);

    }

    override public function create() : Void 
    {
        var obj = new TreeObject(state, gridX, gridY);
        this.setObject(obj);
        state.addObject(obj);
        super.create();
    }

    
}