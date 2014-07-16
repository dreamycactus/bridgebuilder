package com.org.mes;

class MESState
{
    public var renderSys : System;
    public var sys : Array<System>;
    public var ents : Array<Entity>;
    public var top : Top;
    
    public function new(top : Top) 
    {
        this.top = top;
        this.sys = new Array();
        ents = new Array();
    }
    
    public function init()
    {
        for (s in sys) {
            top.insertSystem(s);
            s.init();
        }
        for (e in ents) {
            top.insertEnt(e);
        }
    }
    
    public function deinit()
    {
        // Cleanup old
        for (e in ents) {
            top.deleteEnt(e);
        }
        for (s in sys) {
            top.removeSystem(s);
            s.deinit();
        }
    }

}