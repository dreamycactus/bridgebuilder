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
    
    public var motorFront : MotorJoint;
    public var motorBack : MotorJoint;
    
    public function new(pos : Vec2)
    {
        super(null);
        this.compound = new Compound();
        
        body = new Body(); // Chassis
        body.shapes.add( new Polygon(Polygon.box(50, 20), null, new InteractionFilter(Config.cgLoad)) );
        body.shapes.at(0).material = Material.steel();
        body.compound = compound;
        body.position = pos;
        
        var fw = new Body(); // Front wheel
        fw.shapes.add( new Circle(10, null, null, new InteractionFilter(Config.cgLoad)) );
        fw.position = pos.add(Vec2.weak( -20, 7));
        fw.compound = compound;
        
        var bw = new Body(); // Front wheel
        bw.shapes.add( new Circle(10, null, null, new InteractionFilter(Config.cgLoad)) );
        bw.position = pos.add(Vec2.weak( 20, 7));
        bw.compound = compound;
        
        var fwj = new PivotJoint(body, fw, Vec2.weak( -20, 7), Vec2.weak());
        fwj.ignore = true;
        fwj.compound = compound;
        
        var bwj = new PivotJoint(body, bw, Vec2.weak( 20, 7), Vec2.weak());
        bwj.ignore = true;
        bwj.compound = compound;
        
        motorFront = new MotorJoint(null, fw, 0);
        motorFront.compound = compound;
        
        motorBack = new MotorJoint(null, bw, 0);
        motorBack.compound = compound;
    }
    
    override function update()
    {
    }
    
    override function set_space(space : Space) : Space
    {
        if (space != null) {
            motorFront.body1 = space.world;
            motorBack.body1 = space.world;
        }
        compound.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return compound.space;
    }
    
}