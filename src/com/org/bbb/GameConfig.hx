package com.org.bbb;

import com.org.bbb.control.CmpControl;
import com.org.bbb.control.CmpControlBuild;
import com.org.bbb.control.CmpControlCar;
import com.org.bbb.control.CmpControlCarPlayer;
import com.org.bbb.editor.CmpControlEditor;
import com.org.bbb.editor.CmpEditorBox;
import com.org.bbb.physics.CmpEnd;
import com.org.bbb.level.CmpObjective;
import com.org.bbb.level.CmpObjectiveAllPass;
import com.org.bbb.level.CmpObjectiveBudget;
import com.org.bbb.level.CmpObjectiveEndBridgeIntact;
import com.org.bbb.level.CmpObjectiveTimerUp;
import com.org.bbb.level.CmpSpawn;
import com.org.bbb.physics.BuildMat;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpBeam;
import com.org.bbb.physics.CmpBeamBase;
import com.org.bbb.physics.CmpCable;
import com.org.bbb.physics.CmpJoint;
import com.org.bbb.physics.CmpMover;
import com.org.bbb.physics.CmpMoverCar;
import com.org.bbb.physics.CmpMoverTrainCar;
import com.org.bbb.physics.CmpMoverTrainEngine;
import com.org.bbb.physics.CmpMoverTruckRigid;
import com.org.bbb.physics.CmpMoverTruckTractor;
import com.org.bbb.physics.CmpMoverTruckTrailer;
import com.org.bbb.physics.CmpMultiBeam;
import com.org.bbb.physics.CmpPhys;
import com.org.bbb.physics.CmpSharedJoint;
import com.org.bbb.render.CmpRender;
import com.org.bbb.render.CmpRenderAnchor;
import com.org.bbb.render.CmpRenderBg;
import com.org.bbb.render.CmpRenderBgCityfield;
import com.org.bbb.render.CmpRenderBgStarfield;
import com.org.bbb.render.CmpRenderCable;
import com.org.bbb.render.CmpRenderCar;
import com.org.bbb.render.CmpRenderControlBuild;
import com.org.bbb.render.CmpRenderControlUI;
import com.org.bbb.render.CmpRenderEditorUI;
import com.org.bbb.render.CmpRenderGrid;
import com.org.bbb.render.CmpRenderMultiBeam;
import com.org.bbb.render.CmpRenderPony;
import com.org.bbb.render.CmpRenderRain;
import com.org.bbb.render.CmpRenderSharedJoint;
import com.org.bbb.render.CmpRenderSlide;
import com.org.bbb.render.CmpRenderSprite;
import com.org.bbb.render.CmpRenderTerrain;
import com.org.bbb.render.CmpRenderTrainCar;
import com.org.bbb.render.CmpRenderTrainLocomotive;
import com.org.bbb.render.CmpRenderTruckRigid;
import com.org.bbb.render.CmpRenderTruckTractor;
import com.org.bbb.render.CmpRenderTruckTrailer;
import com.org.mes.Cmp;
import com.org.mes.CmpManager;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.callbacks.CbType;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.geom.Mat23;
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

enum MaterialNames
{
    CABLE;
    SUPERCABLE;
    WOOD;
    CONCRETE;
    STEEL;
    NULL;
}

class GameConfig
{
    public static var camDragCoeff = 5;
    
    public static var cableSegWidth = 50.0;
    public static var beamStressHp = 900;
    public static var sharedJointRadius = 15;
    public static var multiBeamFrequencyDecay = 0.007;
    public static var multiBeamJointDecay = 9e5;
    public static var distanceJointMin = 0;
    public static var distanceJointMax = 40;
    
    public static var spawnCDCar = 2000;
    public static var carSpeed = 25;
    public static var carWheelRadius = 8;
    
    public static var gridCellWidth = 40;
    public static var maxBeamCells = 6;
    
    public static var panBorder = 0.1;
    public static var panRate = 10;
    public static var cameraElasticEdge = 0.1;
    
    public static var cgBeam        = 1<<11;
    public static var cgDeck        = 2;
    public static var cgBeamSplit   = 4;
    public static var cgSharedJoint = 8;
    public static var cgAnchor      = 16;
    public static var cgLoad        = 32;
    public static var cgCable       = 64;
    public static var cgSensor      = 1;
    public static var cgEnd         = 256;
    public static var cgSpawn       = 512;
    public static var cgNull        = 1024;
    
    public static var cmSharedJoint = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmBeam = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmDeck = ~(cgBeam | cgDeck | cgSharedJoint | cgAnchor);
    public static var cmCable = cgSensor;
    public static var cmEditable = cgSensor;
    public static var cmAnchor = ~(GameConfig.cgBeam | GameConfig.cgBeamSplit | GameConfig.cgDeck);
    
    public static var cbCable = new CbType();
    public static var cbGround = new CbType();
    public static var cbOneWay = new CbType();
    public static var cbMulti = new CbType();
    public static var cbCar = new CbType();
    public static var cbTruck = new CbType();
    public static var cbEnd = new CbType();
    
    static var materialSteel = new Material(0.2, 0.2, 0.3, 3, 2);
    static var materialWood = new Material(0.4, 0.4, 0.5, 0.5);
    static var materialConcrete = new Material(0.25, 0.5, 0.7, 7);
    static var materialCable = new Material(0.4, 0.2, 0.2, 1e-5);
    static var materialSuperCable = new Material(0.4, 0.2, 5e-5, 0.5);
    
    public static var materialCar = Material.steel();
    public static var materialTrain = new Material(0.4, 0.2, 0.3, 10);
    public static var materialTruck = new Material(0.4, 0.2, 0.3, 12);
    
    public static var trainEngineDim = { w : 100, h : 40 };
    public static var trainCarDim = { w : 130, h : 50 };
    public static var trainMargin = 15;

    public static var truckTractorCabDim = { w : 50, h : 40 };
    public static var truckTractorFrameDim = { w : 100, h : 12 };
    public static var truckTractorCabOffset = Mat23.translation( 25, -20 );
    public static var truckSemiTrailerDim = { w : 150, h : 35 };
    public static var truckSemiTrailerOffset = Mat23.translation(0, -25);
    public static var truckRigidCabDim = { w : 40, h : 35 };
    public static var truckRigidCargoDim = { w : 90, h : 45 };
    public static var truckTrailerMaxMargin = 30;
    
    // Moment Tension Compression Shear
    public static var matWood : BuildMat = new BuildMat(twood, MaterialNames.WOOD, MatType.BEAM, materialWood
                                            ,1.6e5, 370, 370, 888, 20
                                            , 7,3, false);
    public static var matConcrete : BuildMat = new BuildMat(tconcrete, MaterialNames.CONCRETE, MatType.BEAM, materialConcrete
                                            , 5e5, 700, 4000, 888, 20
                                               , 7,25, true );
    public static var matSteel: BuildMat = new BuildMat(tsteel, MaterialNames.STEEL, MatType.BEAM, materialSteel
                                            , 3.5e5, 2000, 2000, 888, 20, 7, 24
                                            , false );
    public static var matCable : BuildMat = new BuildMat(tcable, MaterialNames.CABLE, MatType.CABLE, materialCable
                                            , 0, 2000, -1, 888, 10, 30, 5
                                            , false);
    public static var matSuperCable : BuildMat = new BuildMat(tsupercable, MaterialNames.SUPERCABLE, MatType.CABLE, materialSuperCable
                                            , 0, 2e5, -1, 888, 20, 30, 20
                                                 , false );

    
    public static var tCar = "car";
    public static var tBeam = "beam";
    public static var tTransform = "transform";
    public static var tAnchor = "anchor";
    
    public static var tcable = "Cable";
    public static var tsupercable = "Supercable";
    public static var twood = "Wood";
    public static var tconcrete = "Concrete";
    public static var tsteel= "Steel";
    public static var tdelete = "Delete";
    
    public static var zStars : Int = 20;
    public static var zBG : Int = 10;
    public static var zCity : Int = 7;
    public static var zAnchor : Int = 9;
    public static var zBeam : Int = 5;
    public static var zSharedJoint : Int = 4;
    public static var zGrid : Int = 3;
    public static var zCar : Int = 6;
    public static var zRenderControlUI : Int = 2;
    public static var zControlUI : Int = 2;
    
    
    public static var stageWidth;
    public static var stageHeight;
    
    public static function init()
    {
        Cmp.cmpManager = new CmpManager();
        Cmp.cmpManager.adopt(CmpRender, [CmpRenderGrid, CmpRenderControlBuild, CmpRenderControlUI
                                      , CmpRenderMultiBeam, CmpRenderSlide, CmpRenderBg, CmpRenderBgStarfield, CmpRenderBgCityfield
                                      , CmpRenderAnchor, CmpRenderSharedJoint, CmpRenderCable, CmpRenderSprite, CmpRenderTerrain
                                      , CmpRenderCar, CmpRenderTruckRigid, CmpRenderTruckTractor, CmpRenderTruckTrailer, CmpRenderTrainLocomotive, CmpRenderTrainCar
                                      , CmpRenderRain, CmpRenderPony, CmpRenderEditorUI, CmpEditorBox]);
        Cmp.cmpManager.adopt(CmpPhys, [CmpBeamBase, CmpJoint, CmpAnchor,
                                       CmpSharedJoint, CmpMover, CmpMoverCar, CmpMoverTrainEngine, CmpMoverTrainCar, CmpMoverTruckTractor, CmpMoverTruckTrailer, CmpMoverTruckRigid, CmpSpawn, CmpEnd]);
        Cmp.cmpManager.adopt(CmpBeamBase, [CmpBeam, CmpCable, CmpMultiBeam]);
        Cmp.cmpManager.adopt(CmpControl, [CmpControlBuild, CmpControlEditor, CmpControlCar, CmpControlCarPlayer]);
        Cmp.cmpManager.adopt(CmpObjective, [CmpObjectiveEndBridgeIntact, CmpObjectiveAllPass, CmpObjectiveTimerUp, CmpObjectiveBudget]);
        Cmp.cmpManager.adopt(CmpSpawn, []);
        
        resize(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
    }
    
    public static function resize(w : Int, h : Int) : Void
    {
        stageWidth = w;
        stageHeight = h;
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
    
    public static function nameToMat(name : String) : BuildMat
    {
        if (name == GameConfig.tcable) {
            return matCable;
        } else if (name == GameConfig.tsupercable) {
            return matSuperCable;
        } else if (name == GameConfig.twood) {
            return matWood;
        } else if (name == GameConfig.tconcrete) {
            return matConcrete;
        } else if (name == GameConfig.tsteel) {
            return matSteel;
        } else {
            return null;
        }
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
            ret.breakUnderError = true;
            ret.maxError = 30;
            //ret.frequency = 10;
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
