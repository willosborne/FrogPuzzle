package base; 

import flixel.FlxSprite;

@:keepSub class NormalObject extends FlxSprite 
{
    public var rotates:Bool;

    var state:PlayState;

    public var gridX:Int;
    public var gridY:Int;

    public var platform:PlatformObject;

    public var faceDir:FaceDirection;

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
    }

    public function takeTurn():Void
    {

    }

    public function onBump()
    {

    }

    public function setFaceDir(dir:FaceDirection)
    {
        faceDir = dir;
    }
}