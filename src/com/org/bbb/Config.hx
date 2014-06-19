package com.org.bbb;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.shape.Circle;
import nape.shape.Polygon;


typedef BeamMat =
{
    var contactBreak : Float;
    var momentBreak  : Float;
    var tensionBreak : Float;
    var compressionBreak :Float;
    var height : Float;
}
typedef CableMat =
{
    var maxTension : Float;
    var segHeight : Float;
    var segWidth : Float;
}
enum BuildMat { STEELBEAM; CABLE; }

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
    public static var cgBeam        = 1;
    public static var cgDeck        = 2;
    public static var cgBeamSplit   = 4;
    public static var cgSharedJoint = 8;
    public static var cgAnchor      = 16;
    public static var cgLoad        = 32;
    public static var cgSensor      = 2048;
    
    public static var sharedJointRadius = 15;
    
    public static var cmSharedJoint = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor);
    public static var cmBeam = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor);
    public static var cmDeck = ~(cgBeam|cgDeck|cgSharedJoint|cgAnchor);
    
    public static var matIron = { contactBreak : 0, momentBreak : 0, tensionBreak : 0, height : 24 };
    
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
            //ret.stiff = true;
            //ret.damping = 1e7;
            //ret.frequency = 200;
            //
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