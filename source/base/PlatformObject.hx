package base; 

import flixel.FlxSprite;

@:keepSub
class PlatformObject extends FlxSprite 
{
    public var rotates:Bool;

    var state:PlayState;

    public var gridX:Int;
    public var gridY:Int;

    public var hasObjectInternal:Bool;
    var object:NormalObject = null;


    public var faceDir:FaceDirection;

    public function new(state:PlayState, gridX:Int=0, gridY:Int=0, ?rotates:Bool=false) 
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

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (hasObjectInternal)
        {
            object.x = x;
            object.y = y;
            object.gridX = gridX;
            object.gridY = gridY;
        }
    }

    private function snapToGrid() : Void 
    {
        x = Utils.gridToWorldCentreX(gridX);
        y = Utils.gridToWorldCentreY(gridY);
        // x = Utils.gridToWorldX(gridX);
        // y = Utils.gridToWorldY(gridY);
    }

    // allow us to pretend it has an object
    public function hasObject() : Bool 
    {
        return hasObjectInternal;
    }

    public function setObject(obj:NormalObject) : Void
    {
        object = obj;
        hasObjectInternal = true;
    }

    public function removeObject() : Void 
    {
        object = null;
        hasObjectInternal = false;
    }

    public function getObject() : NormalObject
    {
        if (hasObjectInternal)
        {
            return object;
        }
        return null;
    }

    public function takeTurn():Void
    {

    }

    public function onMove(dX:Int, dY:Int):Void 
    {

    }
    
    public function setFaceDir(dir:FaceDirection)
    {
        faceDir = dir;
    }
}