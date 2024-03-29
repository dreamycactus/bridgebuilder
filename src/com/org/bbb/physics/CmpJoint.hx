package com.org.bbb.physics ;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Cmp;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.phys.Body;
import nape.space.Space;

/** TODO: DELETE
 * ...
 * @author 
 */
class CmpJoint extends CmpPhys
{
    public var joint : Constraint;
    public var pivotJoint(get_pivotJoint, null) : PivotJoint;
    public var weldJoint(get_weldJoint, null) : WeldJoint;
    public var jointType(default, set_jointType) : JointType;
    
    public function new(trans : CmpTransform, joint : Constraint, jointType : JointType) 
    {
        super(trans);
        this.joint = joint;
        this.jointType = jointType;
    }
    
    private function set_jointType(jointType : JointType) : JointType
    {
        if (this.jointType != jointType) {
            
        }
        return jointType;
    }
    
    private function get_pivotJoint() : PivotJoint
    {
        if (joint != null) {
            switch(jointType)
            {
            case JointType.BEAM:
                return cast(joint, PivotJoint);
            default:
            }
        }
        return null;
    }
    
    private function get_weldJoint() : WeldJoint
    {
        if (joint != null) {
            switch(jointType)
            {
            //case JointType.MULTIJOINT:
                //return cast(joint, WeldJoint);
            default:
            }
        }
        return null;
    }
    
    override function set_space(space : Space) : Space
    {
        if (joint.compound == null) {
            joint.space = space;
        }
        return space;
    }
    
    override function get_space() : Space
    {
        return joint.space;
    }
}