package com.org.mes;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

/**
 * ...
 * @author ...
 */
// Keeps track of entity types.. but doesn't really handle entities that dynamically add and remove components
class EntityTypeManager
{
    var types : StringMap<Array<Entity>> = new StringMap();
    var nameToEntityType : StringMap<EntityType> = new StringMap();
    
    public function new() 
    {
        
    }
    
    public function registerType(et : EntityType) : Void
    {
        types.set(et.name, new Array<Entity>());
        nameToEntityType.set(et.name, et);
    }
    
    public function getEntitiesOfType(name) : Array<Entity>
    {
        return types.get(name);
    }
    
    public function onInserted(entity : Entity) : Void
    {
        for (et in nameToEntityType.iterator()) {
            if (et.matches(entity)) {
                var arr = types.get(et.name);
                if (arr != null) {
                    arr.push(entity);
                }
            }
        }
    }
    
    public function onRemoved(entity : Entity) : Void
    {
        for (et in nameToEntityType.iterator()) {
            if (et.matches(entity)) {
                var arr = types.get(et.name);
                if (arr != null) {
                    arr.remove(entity);
                }
            }
        }
    }
    
    public function getEntityType(name : String) : EntityType
    {
        return nameToEntityType.get(name);
    }
}