package com.org.bbb;
import haxe.ds.Vector;
import nape.constraint.MotorJoint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Compound;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
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
    
    public function new(pos : Vec2)
    {
        super(null);
        this.compound = new Compound();
        
        var b = new Body(); // Chassis
        b.shapes.add( new Polygon(Polygon.box(50, 20), null, new InteractionFilter(Config.cgLoad)) );
        b.compound = compound;
        b.position = pos;
        
        var fw = new Body(); // Front wheel
        fw.shapes.add( new Circle(10, null, null, new InteractionFilter(Config.cgLoad)) );
        fw.position = pos.add(Vec2.weak( -20, 7));
        fw.compound = compound;
        
        var bw = new Body(); // Front wheel
        bw.shapes.add( new Circle(10, null, null, new InteractionFilter(Config.cgLoad)) );
        bw.position = pos.add(Vec2.weak( 20, 7));
        bw.compound = compound;
        
        var fwj = new PivotJoint(b, fw, Vec2.weak( -20, 7), Vec2.weak());
        fwj.ignore = true;
        fwj.compound = compound;
        
        var bwj = new PivotJoint(b, bw, Vec2.weak( 20, 7), Vec2.weak());
        bwj.ignore = true;
        bwj.compound = compound;
        
        motorFront = new MotorJoint(null, fw, 0);
        motorFront.compound = compound;
        
        motorBack = new MotorJoint(null, bw, 0);
        motorBack.compound = compound;
    }
    
    override function update()
    {
        motorFront.rate = 100;
        motorBack.rate = 100;
    }
    
    override function set_space(space : Space) : Space
    {
        motorFront.body1 = space.world;
        motorBack.body1 = space.world;
        compound.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return compound.space;
    }
    
}