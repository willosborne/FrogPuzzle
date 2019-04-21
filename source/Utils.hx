package;

import flixel.math.FlxPoint;

class Utils
{
    public static inline var tileWidth:Int = 24;
    public static inline var tileHeight:Int = 24;

    // public static var gridOffset:FlxPoint = new FlxPoint(0, 0);
    public static var gridOffsetX:Int = 0;
    public static var gridOffsetY:Int = 0;

    public static function gridToWorldX(X:Int) : Int
    {
        return X * tileWidth + gridOffsetX;
    }
    
    public static function gridToWorldY(Y:Int) : Int
    {
        return Y * tileHeight + gridOffsetY;
    }
    
    public static function gridToWorldCentreX(X:Int) : Int
    {
        return X * tileWidth + gridOffsetX + Std.int(tileWidth / 2);
    }
    
    public static function gridToWorldCentreY(Y:Int) : Int
    {
        return Y * tileHeight + gridOffsetY + Std.int(tileHeight / 2);
    }

    public static function worldToGridX(X:Float) : Int 
    {
        return Std.int((X - gridOffsetX) / tileWidth);
    }

    public static function worldToGridY(Y:Float) : Int 
    {
        return Std.int((Y - gridOffsetY) / tileHeight);
    }

    public static function worldToGridXAbs(X:Float) : Int 
    {
        return Std.int(X / tileWidth);
    }

    public static function worldToGridYAbs(Y:Float) : Int 
    {
        return Std.int(Y / tileHeight);
    }

    public static function sign(K:Float):Int 
    {
        if (K < 0)
            return -1;
        else if (K == 0)
            return 0;
        else
            return 1;
    }
}