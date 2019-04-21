package; 

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTilePropertySet;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;

import haxe.io.Path;

import base.PlatformObject;
import base.NormalObject;

class LevelLoader extends TiledMap
{
    private static inline var TILESET_PATH = "assets/images/";

    public var bgTilemaps:FlxGroup;

    public var platforms:FlxTypedGroup<PlatformObject>;
    public var objects:FlxTypedGroup<NormalObject>;

	public var platformGrid:Array<Array<PlatformObject>>;

    public var gridWidth:Int;
    public var gridHeight:Int;

    private var state:PlayState;

    public function new(tiledLevel:Dynamic, state:PlayState)
    {
        super(tiledLevel);

        bgTilemaps = new FlxGroup();

        trace('Loading level');
        trace('Width: $width, height: $height');

        gridWidth = width;
        gridHeight = height;

        Utils.tileWidth = tileWidth;
        Utils.tileHeight = tileWidth;

        this.state = state;

        // trace(tilesetArray);

        // for (tileLayer in layers)
        // {
        //     var tileSheetName:String = tileLayer.properties.get("tileset");
        //     if (tileSheetName == null)
        //     {
        //         throw "'tileset' property not defined for layer " + tileLayer.name;
        //     }
        // }

        bgTilemaps = loadTileLayer("bgTiles");

        loadPlatforms();
        loadObjects();
    }

    function loadTileLayer(layerName:String) : FlxGroup 
    {
        var group = new FlxGroup();

        var layer:TiledLayer = getLayer(layerName);

        if (layer == null)
            throw 'Error: $layerName does not exist';

        if (layer.type != TiledLayerType.TILE)
            throw 'Error: $layerName is not a tile layer';

        var tileLayer:TiledTileLayer = cast layer;

        var tileSheetName:String = tileLayer.properties.get("tileset");
        if (tileSheetName == null)
            throw "'tileset' property not defined for layer " + tileLayer.name;

        var tileset:TiledTileSet = null;
        for (ts in tilesets) 
        {
            if (ts.name == tileSheetName)
            {
                tileset = ts;
                break;
            }
        }
        if (tileset == null)
        {
            throw 'TileSet $tileSheetName not found.'; 
        }

        //TODO: rewrite to use external tilesets, then merge them here
        // http://forum.haxeflixel.com/topic/764/another-invalid-field-access-__s-issue/3

        // resolve full path to image
        var rawPath = new Path(tileset.imageSource);
        var processedPath = TILESET_PATH + rawPath.file + "." + rawPath.ext;

        trace('Loading tileset image $processedPath');

        var tilemap:FlxTilemapExt = new FlxTilemapExt();
        tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
            tileset.tileWidth, tileset.tileHeight, OFF, tileset.firstGID, 1, 1);

        tilemap.x = tileWidth / 2;
        tilemap.y = tileHeight / 2;


        // TODO: animated tiles here

        group.add(tilemap);

        return group;
    }

    /**
        Load the platforms group.
        
        Side effects: 
         - initialises `platformGrid` with objects.
         - sets `platforms` to platform group

        @return new contents of `platforms` group.
    **/
    function loadPlatforms() : FlxTypedGroup<PlatformObject>
    {
        var group = new FlxTypedGroup<PlatformObject>();

		platformGrid = [for (x in 0...gridWidth) [for (y in 0...gridHeight) null]];

        var layer = getLayer("platforms");
        if (layer == null)
            throw "platforms layer not found in map";
        
        if (layer.type != TiledLayerType.OBJECT)
            throw "platforms layer has wrong type. Should contain objects";
        var objectLayer:TiledObjectLayer = cast layer;

        for (o in objectLayer.objects)
        {
            var plat:PlatformObject = createPlatform(o);

            if (platformGrid[plat.gridX][plat.gridY] != null)
                throw "Only one platform per grid space.\n" +
                        'Multiple objects at (${plat.gridX}, ${plat.gridY}).';

            platformGrid[plat.gridX][plat.gridY] = plat;

            group.add(plat);
        }

        platforms = group;

        return group;
    }


    /**
        Load the normal objects group.
        
        Side effects: 
         - initialises `platformGrid` with objects.
         - sets `objects` to object group

        @return new contents of `platforms` group.
    **/
    function loadObjects() : FlxTypedGroup<NormalObject>
    {
        var group = new FlxTypedGroup<NormalObject>();

        var layer = getLayer("objects");
        if (layer == null)
            throw "objects layer not found in map";
        
        if (layer.type != TiledLayerType.OBJECT)
            throw "objects layer has wrong type. Should contain objects";
        var objectLayer:TiledObjectLayer = cast layer;

        for (o in objectLayer.objects)
        {
            var obj:NormalObject = createObject(o);
            if (obj == null)
                trace("Null object?");

            var plat:PlatformObject = platformGrid[obj.gridX][obj.gridY];

            if (plat != null)
            {
                if (!plat.hasObject())
                {
                    trace ("Set platform object");
                    plat.setObject(obj);
                    obj.platform = plat;
                }
                else
                    throw "Only one platform per grid space.\n" +
                        'Multiple objects at (${obj.gridX}, ${obj.gridY}).';
            }
            else 
            {
                throw "All objects must have platforms." +
                    'Object without platform at (${obj.gridX}, ${obj.gridY}).';
            }

            group.add(obj);
        }

        objects = group;

        return group;
    }

    function createPlatform(o:TiledObject) : PlatformObject
    {
        var x:Int = o.x;
        var y:Int = o.y;

        var gridX:Int = Std.int(x / tileWidth);
        var gridY:Int = Std.int(y / tileWidth) - 1; // different indexing

        var objName:String = o.type;

        // trace('Type to create: object.$objName');
        // trace('Grid position: ($gridX, $gridY)');

        var obj:PlatformObject = Type.createInstance(Type.resolveClass("object." + objName),
                                    [state, gridX, gridY]);

        return obj;
    }


    function createObject(o:TiledObject) : NormalObject
    {
        var x:Int = o.x;
        var y:Int = o.y;

        var gridX:Int = Std.int(x / tileWidth);
        var gridY:Int = Std.int(y / tileWidth) - 1; // different indexing

        var objName:String = o.type;
        
        // trace('Type to create: object.$objName');
        // trace('Grid position: ($gridX, $gridY)');

        var obj:NormalObject = Type.createInstance(Type.resolveClass("object." + objName),
                                    [state, gridX, gridY]);

        return obj;
    }
}