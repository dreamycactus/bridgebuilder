package com.org.glengine;

/**
 * ...
 * @author ...
 */
class VertexArray
{
    var attributes : Array<Int> = new Array();
    var buffer : Array<Float> = new Array();
    var numVertices : Int;
    
    public function new(attributes : Array<Int>, numVertices : Int) 
    {
        this.attributes = attributes;
        this.numVertices = numVertices;
    }
    
}