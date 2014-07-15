package com.org.bbb;
import haxe.ds.Vector;
import nape.constraint.MotorJoint;
import nape.geom.Vec2;
import nape.phys.Compound;
import nape.phys.Material;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpMoverCar extends CmpMover
{
    public var compound : Compound;
    var material : Material;
    var speed : Float;
    
    var wheelFrontPos : Vec2;
    var wheelBackPos : Vec2;
    
    var motorFront : MotorJoint;
    var motorBack : MotorJoint;
    
    public function new() 
    {
        this.compound = new Compound;
    }
    
    override function set_space(space : Space) : Space
    {
        compound.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return compound.space;
    }
    
}