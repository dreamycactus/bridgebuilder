package com.org.bbb;

/**
 * ...
 * @author ...
 */
class CmpRenderSharedJoint extends CmpRender
{
	var cmpSharedJoint : CmpSharedJoint;
	public function new(cmpSharedJoint : CmpSharedJoint) 
	{
		super(true);
		this.cmpSharedJoint = cmpSharedJoint;
		var g = sprite.graphics;
		g.beginFill(0xFFFFFF);
		var pos = cmpSharedJoint.body.position;
		g.drawCircle(0, 0, GameConfig.sharedJointRadius);
		g.endFill();
		sprite.x = pos.x;
		sprite.y = pos.y;
	}
	
	override public function render(dt : Float) : Void
	{
		var pos = cmpSharedJoint.body.position;
		sprite.x = pos.x;
		sprite.y = pos.y;
	}
	
}