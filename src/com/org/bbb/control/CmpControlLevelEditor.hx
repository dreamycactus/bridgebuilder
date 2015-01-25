package com.org.bbb.control ;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.geom.Vec2;
import openfl.display.Stage;

/**
 * ...
 * @author ...
 */
class CmpControlLevelEditor extends CmpControl
{
    var stage : Stage;
    var top : Top;
    var state : MESState;
    
    public var level : CmpLevel;
    public var camera : Camera;
    var cmpGrid : CmpGrid;
    
    var inited : Bool = false;
    var builder : CmpBridgeBuild;
    var material(get, set) : BuildMat;
    var prevMouse : Vec2;
    
    public function new(bridgebuilder : CmpBridgeBuild)
    {
        super();
        
        this.builder = bridgebuilder;
        
        this.stage = builder.stage;
        this.top = builder.top;
        this.state = builder.state;
        this.level = builder.level;
        this.camera = builder.camera;
        this.cmpGrid = builder.cmpGrid;
    }
    
    override public function init()
    {
        regEvents();
        
        material = level.materialsAllowed.length > 0 ?
            GameConfig.nameToMat(level.materialsAllowed[0]) :
            GameConfig.matSteel;

        camera = state.getSystem(SysRender).camera;
        inited = true;
    }
    
    override public function deinit()
    {
        unregEvents();
    }
    
}