package com.org.bbb.render ;
import com.org.bbb.physics.CmpSharedJoint;
import com.org.mes.Cmp;

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
        displayLayer = GameConfig.zSharedJoint;
        refreshgfx();
    }
    
    override public function render(dt : Float) : Void
    {
        var pos = cmpSharedJoint.body.position;
        sprite.x = pos.x;
        sprite.y = pos.y;
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void 
    {
        switch (msgType) {
        case Msgs.ENTMOVE:
            sprite.x = options.x;
            sprite.y = options.y;
        case Msgs.REFRESH:
            refreshgfx();
        }
    }
        
    function refreshgfx()
    {
        var g = sprite.graphics;
        g.beginFill(0xFFFFFF);
        var pos = cmpSharedJoint.body.position;
        g.drawCircle(0, 0, GameConfig.sharedJointRadius);
        g.endFill();
        sprite.x = cmpSharedJoint.body.position.x;
        sprite.y = cmpSharedJoint.body.position.y;
    }
}