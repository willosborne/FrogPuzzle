package base; 

import flixel.FlxSprite;

import base.PlatformObject;


enum FaceDirection 
{
    UP;
    DOWN;
    LEFT;
    RIGHT;
}

class NormalObject extends FlxSprite 
{
    public var rotates:Bool;

    var state:PlayState;

    public var gridX:Int;
    public var gridY:Int;

    var platform:PlatformObject;

    public function new(state:PlayState, gridX:Int, gridY:Int, ?rotates:Bool=false) 
    {
        this.state = state;
        this.rotates = rotates;
        
        this.gridX = gridX;
        this.gridY = gridY;
        
        var cX = Utils.gridToWorldCentreX(gridX);
        var cY = Utils.gridToWorldCentreY(gridY);
        // var cX = Utils.gridToWorldX(gridX);
        // var cY = Utils.gridToWorldY(gridY);

        super(cX, cY);
        
        platform = state.getPlatform(gridX, gridY);
        if (platform == null)
            throw "Normal object created without platform";
    }

    public function takeTurn():Void
    {

    }
}