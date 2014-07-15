package com.org.bbb;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.shape.Circle;
import nape.shape.Polygon;


typedef BuildMat =
{
    var matType : MatType;
    var momentBreak  : Float;
    var tensionBreak : Float;
    var compressionBreak :Float;
    var height : Float;
}

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

class Config
{
    public static var camDragCoeff = 10;
    
    public static var cableSegWidth = 30;
    public static var stressHp = 500;
    
    public static var cgBeam        = 1;
    public static var cgDeck        = 2;
    public static var cgBeamSplit   = 4;
    public static var cgSharedJoint = 8;
    public static var cgAnchor      = 16;
    public static var cgLoad        = 32;
    public static var cgCable        = 64;
    public static var cgSensor      = 2048;
    
    public static var sharedJointRadius = 15;
    
    public static var cmSharedJoint = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmBeam = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor|cgLoad);
    public static var cmDeck = ~(cgBeam | cgDeck | cgSharedJoint | cgAnchor);
    public static var cmCable = cgSensor;
    public static var cmAnchor = ~(Config.cgBeam | Config.cgBeamSplit | Config.cgDeck);
    
    public static var matSteel : BuildMat = { matType : MatType.BEAM, momentBreak : 0, tensionBreak : 0, compressionBreak : -1, height : 24 };
    public static var matSteelDeck : BuildMat = { matType : MatType.DECK, momentBreak : 0, tensionBreak : 0, compressionBreak : -1, height : 24 };
    public static var matCable : BuildMat = { matType : MatType.CABLE, momentBreak : 0, tensionBreak : 1e5, compressionBreak : -1, height : 15 };

    public static function pivotJoint(type : JointType) : PivotJoint
    {
        var ret : PivotJoint = new PivotJoint(null, null, Vec2.weak(), Vec2.weak() );
        switch(type)
        {
        case BEAM:
            ret.stiff = false;
            //ret.damping = 30;
            ret.frequency = 30;
            
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