package com.org.glengine;

/**
 * ...
 * @author ...
 */
class BrSubscene implements BrBatchDrawable
{
    public var drawLayer : Int = 1;
    public var children : Array<BrBatchDrawable> = new Array();
    
    public function new() 
    {
    }
    
    public function drawBatched(batch : BrSpriteBatch)
    {
        for (c in children) {
            c.drawBatched(batch);
        }
    }
    
}