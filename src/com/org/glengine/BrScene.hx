package com.org.glengine;
import openfl.utils.Float32Array;

using com.org.utils.ArrayHelper;

class BrScene
{   
    public var batch : BrSpriteBatch = new BrSpriteBatch();
    public var children : Array<BrBatchDrawable> = new Array();
    
    public function new() 
    {
        
    }
    
    public function render() : Void
    {
        batch.begin();
            for (s in children) {
                s.drawBatched(batch);
            }
        batch.end();
    }
    
    public function addToScene(d : BrBatchDrawable) : Void
    {
        children.insertInPlace(d, higherDrawLayer);
    }
    
    //TODO remove using binary search
    public function removeFromScene(d : BrBatchDrawable) : Bool
    {
        return children.remove(d);
    }
    
    function higherDrawLayer(a : BrBatchDrawable, b : BrBatchDrawable) : Bool
    {
        return a.drawLayer > b.drawLayer;
    }
    
}