package com.org.bbb.physics ;
import com.org.bbb.physics.CmpMover;
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

/**
 * ...
 * @author 
 */
class CmpMoverTruckTrailer extends CmpMover
{
    public var motorFront : MotorJoint;
    public var motorBack : MotorJoint;
    public var compound : Compound;
    var material : Material;
    var speed : Float;

    var wheelFrontPos : Vec2;
    var wheelBackPos : Vec2;

    public function new(pos : Vec2) 
    {
        super(null);
        this.compound = new Compound();

        body = new Body(); // Chassis
        var w = GameConfig.truckSemiTrailerDim.w;
        var h = GameConfig.truckSemiTrailerDim.h;

        var p = Polygon.box(w, h);
        var trailer = new Polygon(p, GameConfig.materialTruck, new InteractionFilter(GameConfig.cgLoad));
        trailer.transform(GameConfig.truckSemiTrailerOffset);

        body.shapes.add(trailer);
        body.cbTypes.add(GameConfig.cbCar);
        body.compound = compound;
        body.position = pos;

        var bw = new Body(); // Rear wheel
        bw.shapes.add(new Circle(12, null, new Material(0.15, 1, 2, 9, 2), new InteractionFilter(GameConfig.cgLoad)) );
        var offBw = Vec2.get( -w * 0.5 + 5, h * 0.5 - 3);
        bw.position = pos.add(offBw);
        bw.compound = compound;

        var bwj = new PivotJoint(body, bw, offBw, Vec2.weak());
        bwj.ignore = true;
        bwj.compound = compound;

        offBw.dispose();

        bwj.ignore = true;
        bwj.compound = compound;
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
