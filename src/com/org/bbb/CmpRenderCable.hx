package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import openfl.display.Sprite;

using com.org.bbb.Util;
/**
 * ...
 * @author ...
 */
class CmpRenderCable extends CmpRender
{
	var sprites : Array<Sprite> = new Array();
	var cmpCable : CmpCable;
	public function new(cmpCable : CmpCable)
	{
		super(true);
		this.cmpCable = cmpCable;
		subscriptions = [Msgs.CABLEUPDATE];
		
	}
	
	public function updateGraphics() : Void
	{
		while (sprite.numChildren > 0) {
			sprite.removeChildAt(0);
		}
		for (seg in cmpCable.compound.bodies) {
			var area = seg.shapes.at(0).castPolygon.area;
			var w = area / cmpCable.material.height;
			var h = cmpCable.material.height;
			
			var s = new Sprite();
			var g = s.graphics;
			var halfDim = Vec2.get(w * 0.5, h * 0.5);
			var topLeft = seg.position.sub(halfDim);
			
			g.beginFill(0xFFFFFF);
			g.drawRect(topLeft.x, topLeft.y, w, h);
			g.endFill();
			s.rotateSprite(topLeft.add(halfDim), seg.rotation);

			halfDim.dispose();
			sprite.addChild(s);
		}
	}
	
	override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
	{
		updateGraphics();
	}
	
}