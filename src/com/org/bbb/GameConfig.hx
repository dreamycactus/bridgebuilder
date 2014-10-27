package com.org.bbb;

import com.org.bbb.BuildMat;
import com.org.mes.Cmp;
import com.org.mes.CmpManager;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.callbacks.CbType;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import openfl.Assets;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

enum JointType
{
    BEAM;
    MULTISTIFF;
    MULTIELASTIC;
    ANCHOR;
    SHARED;
    CABLEEND;
    CABLELINK;
}

class GameConfig
{
    public static var camDragCoeff = 5;
    
    public static var cableSegWidth = 50.0;
    public static var beamStressHp = 600;
    public static var sharedJointRadius = 15;
    public static var multiBeamFrequencyDecay = 0.007;
    public static var multiBeamJointDecay = 9e4;
    public static var distanceJointMin = 0;
    public static var distanceJointMax = 40;
    
    public static var spawnCDCar = 2000;
    public static var carSpeed = 20;
    
    public static var gridCellWidth = 40;
    public static var maxBeamCells = 6;
    
    public static var panBorder = 0.1;
    public static var panRate = 10;
    public static var cameraElasticEdge = 0.1;
    
    public static var cgBeam        = 1;
    public static var cgDeck        = 2;
    public static var cgBeamSplit   = 4;
    public static var cgSharedJoint = 8;
    public static var cgAnchor      = 16;
    public static var cgLoad        = 32;
    public static var cgCable       = 64;
    public static var cgSensor      = (1<<11);
    public static var cgEnd         = 256;
    public static var cgSpawn       = 512;
    
    public static var cmSharedJoint = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmBeam = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmDeck = ~(cgBeam | cgDeck | cgSharedJoint | cgAnchor);
    public static var cmCable = cgSensor;
    public static var cmEditable = cgSensor;
    public static var cmAnchor = ~(GameConfig.cgBeam | GameConfig.cgBeamSplit | GameConfig.cgDeck);
    
    public static var cbCable = new CbType();
    public static var cbMulti = new CbType();
    public static var cbCar = new CbType();
    public static var cbTruck = new CbType();
    public static var cbEnd = new CbType();
    
    public static var matWood : BuildMat = new BuildMat("wood", MatType.BEAM, materialWood, 0
                                            , 300, 300, 888, 20
                                            , 7,2, false);
    public static var matConcrete : BuildMat = new BuildMat("concrete", MatType.BEAM, materialConcrete, 0
                                               , 400, 2000, 888, 20
                                               , 7,3, true );
    public static var matSteel: BuildMat =new BuildMat("steel", MatType.BEAM, materialSteel, 0, 550
                                            , 550, 888, 20, 7,4
                                            , false );
    public static var matCable : BuildMat = new BuildMat("cable", MatType.CABLE, materialCable, 0, 1000
                                            , -1, 888, 10, 30,1
                                            , false);
    public static var matSuperCable : BuildMat = new BuildMat("supercable", MatType.CABLE,materialSuperCable, 0
                                                 , 2e5, -1, 888, 20, 30,1
                                                 , false );

    static var materialSteel = new Material();
    static var materialWood = new Material();
    static var materialConcrete = new Material();
    static var materialCable = new Material(0,1,2,0.0001);
    static var materialSuperCable = new Material();
    
    public static var stageWidth;
    public static var stageHeight;
    
    public static function init()
    {
        Cmp.cmpManager = new CmpManager();
        Cmp.cmpManager.adopt(CmpRender, [CmpRenderGrid, CmpRenderControlBuild, CmpRenderControlUI
                                       , CmpRenderMultiBeam, CmpRenderSlide]);
        Cmp.cmpManager.adopt(CmpPhys, [CmpBeamBase, CmpJoint, CmpAnchor,
                                       CmpSharedJoint, CmpMover, CmpMoverCar, CmpSpawn, CmpEnd]);
        Cmp.cmpManager.adopt(CmpBeamBase, [CmpBeam, CmpCable, CmpMultiBeam]);
        Cmp.cmpManager.adopt(CmpControl, [CmpControlBuild, CmpControlCar, CmpControlSlide]);
        Cmp.cmpManager.adopt(CmpObjective, [CmpObjectiveEndBridgeIntact, CmpObjectiveAllPass, CmpObjectiveTimerUp]);
        Cmp.cmpManager.adopt(CmpSpawn, []);
        
        
        stageWidth = Lib.current.stage.stageWidth;
        stageHeight = Lib.current.stage.stageHeight;
    }
    
    public static function basicTextField(text : String, sz : Int, colour : Int, align : TextFieldAutoSize) : TextField
    {
        var font = Assets.getFont("fonts/LibreBaskerville-Regular.ttf");
        var ret = new TextField();
        var tf = new TextFormat(font.fontName, sz, colour);
        ret.defaultTextFormat = tf;
        ret.text = text;
        ret.selectable = false;
        ret.embedFonts = true;
        ret.autoSize = align;
        
        return ret;
    }
    
    public static function pivotJoint(type : JointType) : PivotJoint
    {
        var ret : PivotJoint = new PivotJoint(null, null, Vec2.weak(), Vec2.weak() );
        switch(type)
        {
        case BEAM:
            //ret.stiff = true;
            //ret.damping = 30;
            ret.frequency = 10;
            
            //ret.breakUnderError = true;
            //ret.maxError = 1e9;
            //ret.breakUnderForce = true;
            //ret.maxForce = 1e10;
        case MULTISTIFF:
            ret.stiff = true;
            ret.ignore = true;
            ret.breakUnderError = true;
            //ret.maxError = 1e4;
            ret.breakUnderForce = true;
            ret.maxForce = 1e9;
        case MULTIELASTIC:
            ret.stiff = false;
            ret.ignore = true;
            ret.breakUnderError = true;
            //ret.maxError = 1e4;
            ret.breakUnderForce = true;
            ret.maxForce = 1e9;
            
        case SHARED:
            //ret.stiff = true;
            ret.maxForce = 1e7;
            ret.breakUnderForce = true;
            //ret.frequency = 40;
        case CABLEEND:
            ret.stiff = true;
            ret.maxForce = 1e9;
        case CABLELINK:
            ret.stiff = true;
            ret.maxForce = 1e9;
        default:
        }
        return ret;
    }
    
    public static function getWeldJoint() : WeldJoint
    {
            var ret = new WeldJoint(null, null, Vec2.weak(), Vec2.weak());
            ret.stiff = true;
            //ret.breakUnderError = true;
            //ret.maxError = 1e9;
            //ret.breakUnderForce = true;
            ret.maxForce = 1e40;
            return ret;
    }
    
    public static function sharedJointShape()
    {
        var s = new Circle(sharedJointRadius);
        s.filter.collisionGroup = cgSharedJoint;
        s.filter.collisionMask = cmSharedJoint;
        return s;
    }
    
}