package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

import base.PlatformObject;
import base.NormalObject;

import object.SolidGround;
import object.Tree;
import object.Player;
import object.LilyPad;

class PlayState extends FlxState
{
	var platformGrid:Array<Array<PlatformObject>>;

	public var gridWidth:Int = 10;
	public var gridHeight:Int = 10;

	var platforms:FlxTypedGroup<PlatformObject>;
	var objects:FlxTypedGroup<NormalObject>;

	public var turnRunning:Bool = false;

	override public function create():Void
	{
		platforms = new FlxTypedGroup<PlatformObject>();
		objects = new FlxTypedGroup<NormalObject>();

		add(platforms);
		add(objects);

		platformGrid = [for (x in 0...gridWidth) [for (y in 0...gridHeight) null]];

		addPlatform(new SolidGround(this, 5, 5));
		addPlatform(new SolidGround(this, 6, 5));
		addPlatform(new SolidGround(this, 7, 5));
		addPlatform(new SolidGround(this, 5, 6));
		addPlatform(new SolidGround(this, 0, 5));
		addPlatform(new LilyPad(this, 4, 5));
		addPlatform(new LilyPad(this, 0, 4));
		
		addPlatform(new SolidGround(this, 0, 0));
		addPlatform(new LilyPad(this, 1, 0));
		addPlatform(new Tree(this, 8, 0));

		addObject(new Player(this, 5, 5));
		
		// add(new FlxText(10, 10, 100, "Hello world!"));

		FlxG.mouse.visible = false;

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		#if sys
			if (FlxG.keys.anyJustPressed([Q, ESCAPE]))
			{
				Sys.exit(0);
			}
		#end

		super.update(elapsed);
	}

	public function addPlatform(obj:PlatformObject):Void 
	{
		platformGrid[obj.gridX][obj.gridY] = obj;
		platforms.add(obj);
	}

	public function addObject(obj:NormalObject):Void
	{
		objects.add(obj);
	}

	public function platformCellFree(gridX:Int, gridY:Int) : Bool
	{
		return getPlatform(gridX, gridY) == null;
	}

	public function getPlatform(gridX:Int, gridY:Int):PlatformObject
	{
		return platformGrid[gridX][gridY];
	}

	public function clearPlatform(gridX:Int, gridY:Int) : Void 
	{
		platformGrid[gridX][gridY] = null;
	}
	
	public function setPlatform(gridX:Int, gridY:Int, obj:PlatformObject) : Void 
	{
		platformGrid[gridX][gridY] = obj;
	}
}
