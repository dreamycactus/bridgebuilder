package com.org.mes;
using Lambda;
/**
 * ...
 * @author 
 */
class System implements Subscriber
{
    public var state : MESState;
    public var active(default, set_active) : Bool = false;
    var subscriptions : Array<String>;
    
    public function new(state : MESState) 
    {
        this.state = state;
        this.subscriptions = new Array();
        
        ents = new List();
    }
    
    public function init() : Void
    {
        
    }
    
    public function deinit() : Void { }
    
    public function update()
    {
    }
    
    public function inserted(e : Entity) : Void { }
    public function removed(e : Entity) : Void { }

    
    public function onInserted(e : Entity)
    {
        if (isValidEnt(e) ) {
            inserted(e);
            ents.add(e);
        }
    }
    
    
    public function onRemoved(e : Entity)
    {
        removed(e);
    }
    
    public function onEntChanged(e : Entity)
    {
        
    }
    
    public function isValidEnt(e : Entity) : Bool
    {
        return false;
    }
    
    
    public function subscribeToMsgs(ofType : String) : Void
    {
        subscriptions.push(ofType);
        if (state != null) {
            state.registerSubscriber(ofType, this);
        }
       
    }
    public function unsubscribeToMsgs(ofType : String) : Void
    {
        subscriptions.remove(ofType);
        if (state != null) {
            state.unregisterSubscriber(ofType, this);
        }
    }
    
    public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void {}
    //function broadcastMessage(name : String, sender : Cmp, options : Dynamic);
    
    public function sendMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        if (state != null) {
            state.distributeMsg(msgType, sender, options);
        }
    }
    function set_active(a : Bool) : Bool
    {
        active = a;
        return a;
    }
 
    var ents : List<Entity>;
}