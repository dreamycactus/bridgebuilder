package com.org.bbb;

import com.org.bbb.CmpMover;
import nape.constraint.DistanceJoint;
import nape.constraint.LineJoint;
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

class CmpMoverTrainEngine extends CmpMover
{

    public var compound : Compound;
    var material : Material;
    var speed : Float;
    
    var wheelFrontPos : Vec2;
    var wheelBackPos : Vec2;
    
    public var motorFront : MotorJoint;
    public var motorBack : MotorJoint;
    public var children : Array<CmpMoverTrainCar> = new Array();
    
    public function new(pos : Vec2) 
    {
        super(null);
        this.compound = new Compound();
        
        var w = GameConfig.trainEngineDim.w;
        var h = GameConfig.trainEngineDim.h;
        body = new Body(); // Chassis
        var p = Polygon.box(w, h);
        
        body.shapes.add(new Polygon(p, GameConfig.materialTrain, new InteractionFilter(GameConfig.cgLoad)));
        body.cbTypes.add(GameConfig.cbCar);
        body.compound = compound;
        body.position = pos;
        
        var fw = new Body(); // Front wheel
        fw.shapes.add(new Circle(15, null, new Material(0.15, 40, 200, 3, 200), new InteractionFilter(GameConfig.cgLoad)) );
        var offFw = Vec2.get(w * 0.5 - 5, h * 0.5 - 3);
        fw.position = pos.add(offFw);
        fw.compound = compound;
        
        var bw = new Body(); // Front wheel
        bw.shapes.add(new Circle(15, null, new Material(0.15, 40, 200, 3, 200), new InteractionFilter(GameConfig.cgLoad)) );
        var offBw = Vec2.get(-w * 0.5 + 5, h * 0.5 - 3);
        bw.position = pos.add(offBw);
        bw.compound = compound;
        
        var fwj = new PivotJoint(body, fw, offFw, Vec2.weak());
        //fwj.stiff = true;
        fwj.ignore = true;
        fwj.compound = compound;
        
        var bwj = new PivotJoint(body, bw, offBw, Vec2.weak());
        //bwj.stiff = true;
        bwj.ignore = true;
        bwj.compound = compound;
        offFw.dispose();
        offBw.dispose();
       
        
        motorFront = new MotorJoint(null, fw, 0);
        motorFront.rate = 20;
        motorFront.compound = compound;
        
        motorBack = new MotorJoint(null, bw, 0);
        motorBack.rate = 20;
        motorBack.compound = compound;
        
        
        
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
    
    public function addCar(car : CmpMoverTrainCar) : Void
    {
        var lj = new LineJoint(body, car.body, Vec2.weak(-GameConfig.trainEngineDim.w*0.5-GameConfig.trainMargin, -5), Vec2.weak(GameConfig.trainCarDim.w*0.5+GameConfig.trainMargin, 0), Vec2.weak(1, 0), 0, 20);
        lj.ignore = true;
        lj.compound = compound;
    }
    
}