package base; 

@:keepSub class PushableObject extends NormalObject
{
    public function new(state:PlayState, gridX:Int, gridY:Int, ?rotates:Bool=false) 
    {
        super(state, gridX, gridY, rotates);
    }


    override public function onBump() : BumpAction
    {
        return PUSH;
    }
}