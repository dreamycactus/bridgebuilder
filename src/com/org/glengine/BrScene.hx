package com.org.glengine;
import openfl.utils.Float32Array;

using com.org.utils.ArrayHelper;

class BrScene
{   
    public var batch : BrSpriteBatch = new BrSpriteBatch();
    public var sprites : Array<BrSprite> = new Array();
    
    public function new() 
    {
        
    }
    
    public function render() : Void
    {
        batch.begin();
            for (s in sprites) {
                s.drawBatched(batch);
            }
        batch.end();
    }
    
    public function addToScene(sprite : BrSprite) : Void
    {
        sprites.insertInPlace(sprite, higherDrawLayer);
    }
    
    //TODO remove using binary search
    public function removeFromScene(sprite : BrSprite) : Bool
    {
        return sprites.remove(sprite);
    }
    
    function higherDrawLayer(a : BrDrawable, b : BrDrawable) : Bool
    {
        return a.drawLayer > b.drawLayer;
    }
    
}