package com.org.mes;

/**
 * @author 
 */

class Cmp implements Subscriber
{
    public static var cmpManager : CmpManager;
    public var entity(default, set_entity) : Entity;
    public var type : CmpType;
    public var subscriptions : Array<String> = new Array();
    
    public function new(subscriptions : Array<String>=null)
    {
        this.subscriptions = subscriptions == null ? new Array() : subscriptions;
        type = cmpManager.registerCmp(Type.getClass(this) );
    }
    
    public function update() : Void {}
    
    function set_entity(e : Entity) : Entity 
    { 
        entity = e;
        return e;
    };
    
    public function subscribeToMsgs(ofType : String) : Void
    {
        subscriptions.push(ofType);
        if (entity != null && entity.state != null) {
            entity.state.registerSubscriber(ofType, this);
        }
       
    }
    public function unsubscribeToMsgs(ofType : String) : Void
    {
        subscriptions.remove(ofType);
        if (entity != null && entity.state != null) {
            entity.state.unregisterSubscriber(ofType, this);
        }
    }
    
    public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void {}
    //function broadcastMessage(name : String, sender : Cmp, options : Dynamic);
    
    public function sendMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        if (entity != null && entity.state != null) {
            entity.state.distributeMsg(msgType, sender, options);
        }
    }
}