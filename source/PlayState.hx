package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

import base.PlatformObject;
import base.NormalObject;

import object.SolidGround;
import object.Tree;
import object.Player;
import object.LilyPad;
import object.Goal;

import UndoStack;

class PlayState extends FlxState
{
	public var platformGrid:Grid;

	private var undoStack:UndoStack;

	public var gridWidth:Int = 10;
	public var gridHeight:Int = 10;

	public var platforms:FlxTypedGroup<PlatformObject>;
	public var objects:FlxTypedGroup<NormalObject>;

	public var turnRunning:Bool = false;

	override public function create():Void
	{

		undoStack = new UndoStack(this);

		var level:LevelLoader = new LevelLoader("assets/data/map-1.tmx", this);

		platforms = level.platforms;
		objects = level.objects;

		add(level.bgTilemaps);

		add(level.platforms);
		add(level.objects);

		platformGrid = level.platformGrid;
		
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

		if (FlxG.keys.justPressed.Z)
		{
			undoStack.popState();
		}

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

	public function deleteAll() : Void
	{
		platformGrid = [for (x in 0...gridWidth) [for (y in 0...gridHeight) null]];
		platforms.clear(); // NOTE: do I need to destroy everything?
		objects.clear();
	}
	
	public function startTurn()
	{
		undoStack.pushState();
	}

	public function endTurn()
	{
		turnRunning = false;
	}
}
