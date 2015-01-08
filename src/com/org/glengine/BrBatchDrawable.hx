package com.org.glengine;

interface BrBatchDrawable
{
    var drawLayer : Int;
    function drawBatched(batch : BrSpriteBatch) : Void;
}