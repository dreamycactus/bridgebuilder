package com.org.bbb;
import nape.constraint.PivotJoint;

typedef BeamMat =
{
    var contactBreak : Float;
    var momentBreak  : Float;
    var tensionBreak : Float;
    var compressionBreak :Float;
}

enum JointType
{
    BEAM;
}

class Config
{
    public static var cgBeam        = 1;
    public static var cgDeck        = 2;
    public static var cgBeamSplit   = 16;
    
    public static function pivotJoint(type : JointType) : PivotJoint
    {
        var ret : PivotJoint = new PivotJoint(null, null, null, null);
        switch(type)
        {
        case BEAM:
            ret.stiff = false;
            ret.damping = 3;
            ret.frequency = 15;
            
            ret.breakUnderError = true;
            ret.maxError = 1e9;
            ret.breakUnderForce = true;
            ret.maxForce = 1e10;
            
        default:
        }
        return ret;
    }
}