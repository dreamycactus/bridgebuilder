package com.org.mes;
import com.org.bbb.EntFactory;
import haxe.ds.StringMap;
@:access(com.org.mes.Entity)
class MESState
{
    public var entityTypeManager : EntityTypeManager = new EntityTypeManager();
    public var renderSys : System;
    public var sys : Array<System>;
    public var ents : Array<Entity>;
    public var top : Top;
    public var isTransitioning : Bool = false;
    public var msgSubscribers : StringMap<Array<Subscriber>> = new StringMap();
    public var index = 0;
    
    public function new(top : Top) 
    {
        this.top = top;
        this.sys = new Array();
        this.ents = new Array();
    }
    
    public function init()
    {
    }
    
    public function deinit()
    {
        // Cleanup old
        for (e in ents) {
            deleteEnt(e);
        }
        ents = null;
        for (s in sys) {
            s.active = false;
            s.deinit();
        }
        sys = null;
    }
    
    public function update() : Void 
    {
        var i = 0;
        for (s in sys) {
            s.update();
        }
        while (i < ents.length) {
            var e = ents[i];
            if (e.toDelete) {
                reallyDelete(e);
            } else {
                e.update();
                i++;
            }
        }

    }
    
    public function createEnt(name : String = "") : Entity
    {
        if (index == 0x3FFFFFFF) {
            trace('max index for entity reached. Resetting');
            index = 0;
        }

        var e = new Entity(index++);
        e.name = name;
        return e;
    }
    
    public function insertEnt(e : Entity)
    {
        ents.push(e);
        if (e.state != null && e.state != this) {
            trace('overwriting entity ${e.id} state ${e.state} with ${this}');
        }
        e.state = this;
        entityTypeManager.onInserted(e);
        for (s in sys) {
            s.onInserted(e);
        }
    }
    
    public function removeEnt(e : Entity) : Entity
    {
        entityTypeManager.onRemoved(e);
        if (e.state == null) { return e; }
        ents.remove(e);
        e.state = null;
        entityTypeManager.onRemoved(e);
        
        for (s in sys) {
            s.onRemoved(e);
        }
        return e;
    }
    
    public function registerType(et : EntityType) : Void
    {
        entityTypeManager.registerType(et);
    }
    
    
    public function getEntitiesOfType(name : String) : Array <Entity>
    {
        return entityTypeManager.getEntitiesOfType(name);
    }
    
    public function deleteEnt(e : Entity)
    {
        e.toDelete = true;
    }
    
    inline function reallyDelete(e : Entity) {
        removeEnt(e);
        //TODO assign indicies to entities that are reusable like artemis to allow fast access and removal
    }
    
    public function onEntChanged(e : Entity)
    {
        for (s in sys) {
            s.onEntChanged(e);
        }
    }
    
    public function insertSystem(s : System)
    {
        if (sys != null) {
            sys.push(s);
            s.init();
            s.active = true;
        } else {
            throw "System is " + s + "... cannot add to top";
        }
    }
    
    public function removeSystem(s : System)
    {
        sys.remove(s);
    }
    
    public function getSystem<T>(t:Class<T>) : T
    {
        for (s in sys) {
            if (Type.getClassName(Type.getClass(s) ) == Type.getClassName(t) ) {
                return cast(s);
                break;
            }
        }
        return null;
    }
    
    public function onLeaveState(newState : MESState) : Void {}
    
    public function registerSubscriber(msgType : String, subscriber : Subscriber) : Void
    {
        if (!msgSubscribers.exists(msgType)) {
            msgSubscribers.set(msgType, new Array());
        }
        msgSubscribers.get(msgType).push(subscriber);
    }    
    
    public function unregisterSubscriber(msgType : String, subscriber : Subscriber) : Bool
    {
        var subscribers = msgSubscribers.get(msgType);
        for (s in msgSubscribers) {
            trace(s);
        }
        if (subscribers == null || subscribers.length == 0) {
            trace('No msg subscribers exist of type $msgType');
            return false;
        }
        return subscribers.remove(subscriber);

    }
    
    public function distributeMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        var subscribers = msgSubscribers.get(msgType);
        #if debug
        if (subscribers == null || subscribers.length == 0) {
            trace('No msg subscribers exist of type $msgType');
            return;
        }
        #end
        for (s in subscribers) {
            s.recieveMsg(msgType, sender, options);
        }

    }

}