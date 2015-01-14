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
import openfl.Lib;

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
        var p = Polygon.box(40, 20);
        
        body.shapes.add(new Polygon(p, null, new InteractionFilter(GameConfig.cgLoad)));
        body.shapes.at(0).material = Material.rubber();
        body.cbTypes.add(GameConfig.cbCar);
        body.compound = compound;
        body.position = pos;
        
        var fw = new Body(); // Front wheel
        fw.shapes.add( new Circle(GameConfig.carWheelRadius, null, null, new InteractionFilter(GameConfig.cgLoad)) );
        fw.shapes.at(0).material = Material.rubber();
        fw.position = pos.add(Vec2.weak(15, 9));
        fw.compound = compound;
        
        var bw = new Body(); // Front wheel
        bw.shapes.add(new Circle(GameConfig.carWheelRadius, null, null, new InteractionFilter(GameConfig.cgLoad)) );
        bw.shapes.at(0).material = Material.rubber();
        bw.position = pos.add(Vec2.weak(-15, 9));
        bw.compound = compound;
        
        var fwj = new PivotJoint(body, fw, Vec2.weak(15, 9), Vec2.weak());
        fwj.ignore = true;
        fwj.compound = compound;
        
        var bwj = new PivotJoint(body, bw, Vec2.weak(-15, 9), Vec2.weak());
        bwj.ignore = true;
        bwj.compound = compound;
        
        motorFront = new MotorJoint(body, fw, 0);
        motorFront.compound = compound;
        
        motorBack = new MotorJoint(body, bw, 0);
        motorBack.compound = compound;
    }
    
    override function update()
    {
        if (body.position.y > Lib.current.stage.stageHeight + 1000) {
            entity.delete();
        }
        //if (body.rotation > Math.PI / 6) {
            //body.rotation = Math.PI / 6;
        //}
        //if (body.rotation < -Math.PI / 6) {
            //body.rotation = -Math.PI / 6;
        //}
    }
    
    override public function moveHor(extent : Float) : Void
    {
        motorFront.active = true;
        motorBack.active = true;
        motorFront.rate = GameConfig.carSpeed * extent;
        motorBack.rate = GameConfig.carSpeed * extent;
    }
    
    override public function moverNeutral() : Void
    {
        motorFront.active = false;
        motorBack.active = false;
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