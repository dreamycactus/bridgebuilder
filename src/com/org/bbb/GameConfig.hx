package com.org.bbb;

import com.org.mes.Cmp;
import com.org.mes.CmpManager;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.shape.Circle;
import nape.shape.Polygon;
import openfl.Assets;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;


typedef BuildMat =
{
    var name : String;
    var matType : MatType;
    var momentBreak  : Float;
    var tensionBreak : Float;
    var compressionBreak :Float;
    var height : Float;
    var maxLength : Int;
    var cost : Float;
};

enum MatType { BEAM; CABLE; DECK; }

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
    public static var camDragCoeff = 3;
    
    public static var cableSegWidth = 50;
    public static var beamStressHp = 100;
    public static var sharedJointRadius = 15;
    public static var multiBeamFrequencyDecay = 0.007;
    public static var multiBeamJointDecay = 9e4;
    public static var spawnCDCar = 2000;
    public static var carSpeed = 20;
    
    public static var gridCellWidth = 50;
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
    public static var cgSpawn       = 128;
    
    public static var cmSharedJoint = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmBeam = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmDeck = ~(cgBeam | cgDeck | cgSharedJoint | cgAnchor);
    public static var cmCable = cgSensor;
    public static var cmSpawn = cgSensor;
    public static var cmAnchor = ~(GameConfig.cgBeam | GameConfig.cgBeamSplit | GameConfig.cgDeck);
    
    public static var matSteelBeam : BuildMat = { name : "steelbeam", matType : MatType.BEAM, momentBreak : 0, tensionBreak : 1000, compressionBreak : 2000, height : 20, maxLength : 6, cost : 3 };
    public static var matSteelDeck : BuildMat = { name : "steeldeck", matType : MatType.DECK, momentBreak : 0, tensionBreak : 1000, compressionBreak : 2000, height : 20, maxLength : 6, cost : 3 };
    public static var matCable : BuildMat = { name : "cable", matType : MatType.CABLE, momentBreak : 0, tensionBreak : 1e5, compressionBreak : -1, height : 15, maxLength : 10, cost : 3 };

    public static var stageWidth;
    public static var stageHeight;
    
    public static function init()
    {
        Cmp.cmpManager = new CmpManager();
        Cmp.cmpManager.makeParentChild(CmpRender, [CmpRenderGrid, CmpRenderControlBuild, CmpRenderControlUI,
                                                   CmpRenderTile, CmpRenderMultiBeam, CmpRenderSlide]);
        Cmp.cmpManager.registerCmp(CmpPhys);
        Cmp.cmpManager.makeParentChild(CmpPhys, [CmpBeam, CmpJoint, CmpMultiBeam, CmpAnchor,
                                                CmpSharedJoint, CmpCable, CmpMover, CmpMoverCar]);
        Cmp.cmpManager.registerCmp(CmpControl);
        Cmp.cmpManager.makeParentChild(CmpControl, [CmpControlBuild, CmpControlCar, CmpControlSlide]);
        
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
            ret.stiff = true;
            //ret.damping = 30;
            ret.frequency = 10;
            
            //ret.breakUnderError = true;
            //ret.maxError = 1e9;
            //ret.breakUnderForce = true;
            //ret.maxForce = 1e10;
        case MULTISTIFF:
            ret.stiff = true;
            ret.ignore = true;
            //ret.breakUnderError = true;
            //ret.maxError = 1e4;
            ret.breakUnderForce = true;
            ret.maxForce = 1e9;
        case MULTIELASTIC:
            ret.stiff = false;
            ret.ignore = true;
            //ret.breakUnderError = true;
            //ret.maxError = 1e4;
            ret.breakUnderForce = true;
            ret.maxForce = 1e9;
            
        case ANCHOR:
            ret.frequency = 20;
            ret.damping = 10;
            //ret.stiff = true;
            //ret.breakUnderError = true;
            //ret.maxError = 1e9;
            //ret.breakUnderForce = true;
            //ret.maxForce = 1e6;
        case SHARED:
            ret.stiff = true;
        case CABLEEND:
            ret.stiff = true;
            ret.maxForce = 1e9;
        case CABLELINK:
            ret.stiff = true;
            ret.maxForce = 1e6;
        default:
        }
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