package com.org.mes;

using Lambda;
/**
 * ...
 * @author 
 */
class CmpType
{   
    public var depth : Int;
    public var type : Class<Dynamic>;
    public var parent : CmpType;
    public var children : Array<CmpType>;
    
    public function new(type : Class<Dynamic>, parent : CmpType = null) 
    {
        this.depth = 0;
        this.type = type;
        this.parent = parent;
        this.children = new Array();
    }
    
    public function isAncestorOf(descendant : CmpType) : Bool
    {
        if (children.length == 0) {
            return false;
        }
        if (children.has(descendant) ) {
            return true;
        } else {
            for (c in children) {
                if (c.isAncestorOf(descendant) ) {
                    return true;
                }
            }
            return false;
        }
    }
    
    public function isDecendantOf(ancestor : CmpType) : Bool
    {
        var p = parent;
        while (p != null) {
            if (ancestor.hasChild(this) ) { 
                return true;
            }
            p = p.parent;
        }
        return false;
    }
    
    public function addChild(cmpType : CmpType) : Void 
    {
        if (isDecendantOf(cmpType) ) {
            throw "Recursive cmpType" + cmpType + ", " + this;
        }
        if (isAncestorOf(cmpType) ) {
            trace(this + "is already ancestor of " + cmpType);
            return;
        }
        children.push(cmpType);
        cmpType.parent = this;
        for (c in cmpType.children) {
            c.depth++;
            if (isDecendantOf(c) ) {
                throw "Recursive cmpType" + c + ", " + this;
            }
            if (isAncestorOf(c) ) {
                throw "Conflicting ancestry. Parent: " + this + ", " + cmpType + "child: " + c; 
            }
        }
        
        cmpType.depth = depth + 1;
    }
    
    public function hasChild(c : CmpType) : Bool
    {
        if (children.has(c) ) {
            return true;
        }
        return false;
    }
    
    public function toString() : String
    {
        return Type.getClassName(type);
    }
    
}