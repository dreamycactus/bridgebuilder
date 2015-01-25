package com.org.bbb.render ;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.filters.ColorMatrixFilter;
import openfl.geom.Point;
import openfl.geom.Rectangle;

enum ColorMethod
{
    GRAY;
    GRADIENT;
    RANDOM;
    DEFAULT;
}

enum DropLength
{
    LONG;
    SHORT;
}

class CmpRenderRain extends CmpRender
{
    var spriteFrame : Sprite = new Sprite();
    var bitmap : Bitmap = new Bitmap();
    var frameBD : BitmapData;

    public var gravity : Float = 1;
    
    //The linked list onStageList is a list of all the raindrops currently
    //being animated.
    private var onStageList : List<ParticleRaindrop> = new List();
    //The recycleBin stores raindrops that are no longer part of the animation, but 
    //which can be used again when new drops are needed.
    private var recycleBin : List<ParticleRaindrop> = new List();
    
    public var displayWidth : Int;
    public var displayHeight : Int;
    
    //a vector defining wind velocity : 
    public var wind : Point = new Point();
            
    public var defaultInitialVelocity : Point = new Point();
    public var defaultDropThickness : Float = 1;
    public var windOnSplash : Float = 0.2;
    public var noSplashes : Bool = false;
    
    //the defaultDropColor is only used when drops are not randomly colored by
    //grayscale, gradient, or fully random color.
    public var defaultDropColor : Int = 0xFFFFFF;
    
    public var randomizeColor : Bool = true;
    public var colorMethod : ColorMethod = ColorMethod.GRAY;
    public var minGray : Int = 0;
    public var maxGray : Int = 1;
    public var gradientColor1(default, set_gradientColor1) : Int = 0x0000FF;
    public var gradientColor2(default, set_gradientColor2) : Int = 0x00FFFF;
    public var dropLength : DropLength = DropLength.SHORT;
    public var minSplashDrops : Int = 4;
    public var maxSplashDrops : Int = 8;
    public var defaultDropAlpha : Float = 1;
    public var splashAlpha : Float = 0.6;
    public var splashThickness : Float = 1;
    public var splashMinVelX : Float = -2.5;
    public var splashMaxVelX : Float = 2.5;
    public var splashMinVelY : Float = -2.5;
    public var splashMaxVelY : Float = 2.5;
    public var terminalVelocity : Float = 10;
    
    //If drops go outside of the xRange of the viewable window, they can be
    //removed from the animation or kept in play.  If the wind is rapidly changing,
    //there is a possibility of the raindrops reemerging from the side, so
    //you may wish to keep the following variable set to false.
    public var removeDropsOutsideXRange : Bool = true;
    
    //These variance parameters allow for controlled random variation in
    //raindrop velocities.
    public var initialVelocityVarianceX : Float = 0;
    public var initialVelocityVarianceY : Float = 0;
    public var initialVelocityVariancePercent : Float = 0;
    
    public var globalBreakawayTime : Float = 0;
    public var breakawayTimeVariance : Float = 0;
    
    private var displayMask : Sprite;
    private var left : Float;
    private var right : Float;
    private var r1 : Int;
    private var g1 : Int;
    private var b1 : Int;
    private var r2 : Int;
    private var g2 : Int;
    private var b2 : Int;
    private var param : Float;
    private var r : Int;
    private var g : Int;
    private var b : Int;
    private var numSplashDrops : Int;
    private var outsideTest : Bool;
    private var variance : Float;
    private var dropX : Float;
    
    public function new(w : Int, h : Int, useMask=true) 
    {
        super(true);
        displayWidth = w;
        displayHeight = h;
        
        if (useMask) {
            displayMask = new Sprite();
            displayMask.graphics.beginFill(0xFFFF00);
            displayMask.graphics.drawRect(0,0,w,h);
            displayMask.graphics.endFill();
            sprite.addChild(displayMask);
            sprite.mask = displayMask;
        }
        sprite.addChild(bitmap);
        frameBD = new BitmapData(displayWidth, displayHeight, true, 0);
    }
    
    //var canvas = new BitmapData(displayWidth, displayHeight, true, 0);

    override public function render(dt  :  Float)  :  Void
    {
        sprite.graphics.clear();
        var numSamples = 5;
        //var bd = new BitmapData(1280, 480, true, 0);
        frameBD.fillRect(new Rectangle(0, 0, frameBD.width, frameBD.height), 0);
        //frameBD.draw(spriteFrame);
        var tilesheet = new Tilesheet(frameBD);
        tilesheet.addTileRect(new Rectangle(0, 0, displayWidth, displayHeight));
        
        //sourceBD.applyFilter(sourceBD, sourceBD.rect, new Point(), filt);
        //
        //var canvas = new BitmapData(displayWidth, displayHeight, true, 0);
        var tilearray : Array<Float> = new Array();
        for (i in 0...numSamples) {
            tilearray.push(0);
            tilearray.push(i * 10);
            tilearray.push(0);
            tilearray.push(0.2);
            
            //canvas.copyPixels(sourceBD, sourceBD.rect, new Point(0, i * 10), null, null, true);
        }
        //tilesheet.drawTiles(sprite.graphics, tilearray, false, Tilesheet.TILE_ALPHA);
        //bitmap.bitmapData = canvas;
        //sprite.graphics.beginBitmapFill(canvas);
                       
    }
    
    public function addDrop(x0 : Float, y0 : Float, args : Dynamic) : ParticleRaindrop
    {
        var drop : ParticleRaindrop;
        var dropColor : Int;
        var dropThickness : Float;
        
        if (args.dropColor != null) { 
            dropColor = args.dropColor;
        }
        
        switch(colorMethod) {
        case GRAY:
            param = (255 * (minGray + (maxGray - minGray) * Math.random()));
            var pparam = Std.int(param);
            dropColor = pparam << 16 | pparam << 8 | pparam;
        case GRADIENT:
            param = Math.random();
            r = r1 + Std.int(param * (r2 - r1));
            g = g1 + Std.int(param * (g2 - g1));
            b = b1 + Std.int(param * (b2 - b1));
            dropColor = (r << 16) | (g << 8) | b;
        case RANDOM:
            dropColor = Std.int(Math.random() * 0xFFFFFF);
        default:
            dropColor = defaultDropColor;
        }
        
        (args.dropThickness != null) ?
        dropThickness = args.dropThickness :
        dropThickness = defaultDropThickness;
        
        if (!recycleBin.isEmpty()) {
            drop = recycleBin.pop();
            if (drop.next != null) {
                drop.next.prev = null;
            }
            drop.resetPosition(x0, y0);
            drop.visible = true;
        } else {
            drop = new ParticleRaindrop(x0, y0);
            spriteFrame.addChild(drop);
        }

        drop.thickness = dropThickness;
        drop.color = dropColor;
        
        drop.prev = null;
        if (onStageList.isEmpty()) {
            drop.next = null;
        } else {
            drop.next = onStageList.first();
            onStageList.first().prev = drop;
        }
        onStageList.push(drop);
        
        variance = 1 + Math.random() * initialVelocityVariancePercent;
        (args.velX != null) ? 
        drop.vel.x = args.velX :
        drop.vel.x = defaultInitialVelocity.x * variance * Math.random() * initialVelocityVarianceX;
        
        (args.velY != null) ? 
        drop.vel.y = args.velY :
        drop.vel.y = defaultInitialVelocity.y * variance * Math.random() * initialVelocityVarianceY;
        
        (args.alpha != null) ? 
        drop.alpha = args.alpha :
        drop.alpha = defaultDropAlpha;
        
        (args.splashing != null) ?
        drop.splashing = args.splashing :
        drop.splashing = !noSplashes;
        
        drop.atTerminalVelocity = false;
        drop.lifespan = 0;
        drop.breakawayTime = globalBreakawayTime * (1 + breakawayTimeVariance * Math.random());
        
        return drop;
            
    }
    
    override public function update() : Void 
    {
        for (i in 0...1) {
            addDrop(Math.random() * displayWidth, 0, {});
        }
        var drop : ParticleRaindrop = onStageList.first();
        var nextDrop : ParticleRaindrop;
        while (drop != null) {
            nextDrop = drop.next;
            drop.lifespan++;
            if (drop.lifespan > drop.breakawayTime) {
                drop.lastLastPos = drop.lastPos.clone();
                drop.lastPos = drop.p1.clone();
                if (drop.vel.y > terminalVelocity) {
                    drop.atTerminalVelocity = true;
                }
                if (!drop.atTerminalVelocity) {
                    drop.vel.y += gravity;
                }
                
                if (drop.splashing) {
                    drop.p1.x += drop.vel.x + wind.x;
                    drop.p1.y += drop.vel.y + wind.y;
                } else {
                    drop.p1.x += drop.vel.x + wind.x * windOnSplash;
                    drop.p1.y += drop.vel.y + wind.y * windOnSplash;
                }
                
                switch (dropLength) {
                case LONG:
                    drop.p0 = drop.lastLastPos.clone();
                case SHORT:
                    drop.p0 = drop.lastPos.clone();
                }
                
                if (removeDropsOutsideXRange) {
                    left = Math.min(drop.p0.x, drop.p1.x);
                    right = Math.max(drop.p0.x, drop.p1.x);
                    outsideTest = ((drop.p0.y > displayHeight) || (right<0)||(left > displayWidth));
                    drop.splashing = false;
                } else {
                    outsideTest = (drop.p0.y > displayHeight);
                }
                if (outsideTest) {
                    recycleDrop(drop);
                }
                drop.redraw();
                drop = nextDrop;
            }
        }
    }
    
    public function recycleDrop(drop:ParticleRaindrop) : Void
    {
        if (drop.splashing) {
            dropX = drop.p0.x + (displayHeight - drop.p0.y) * (drop.p1.x - drop.p0.x) / (drop.p1.y - drop.p0.y);
            createSplash(dropX, displayHeight, drop.color);
        }
        drop.visible = false;
        if (onStageList.first() == drop) {
            if (drop.next != null) {
                drop.next.prev = null;
            }
            onStageList.pop();
        } else {
            if (drop.prev != null) {
                drop.prev.next = drop.next;
            }
            if (drop.next != null) {
                drop.next.prev = drop.prev;
            }
            onStageList.remove(drop);
        }
        
        drop.prev = null;
        if (recycleBin.isEmpty()) {
            drop.next = null;
        } else {
            drop.next = recycleBin.first();
            recycleBin.first().prev = drop;
        }
        recycleBin.push(drop);
        
    }
    
    function createSplash(x0 : Float, y0 : Float, c : Int) : Void
    {
        numSplashDrops = Math.ceil(minSplashDrops + Math.random() * (maxSplashDrops - minSplashDrops));
        for (i in 0...numSplashDrops) {
            var randomSplashSize = 0.75 + 0.75 * Math.random();
            var velX = randomSplashSize * (splashMinVelX + Math.random() * (splashMaxVelX - splashMinVelX));
            var velY = randomSplashSize * (splashMinVelY + Math.random() * (splashMaxVelY - splashMinVelY));
            var thisDrop = addDrop(x0, y0, {
                  velX : velX
                , velY : velY
                , dropColor : c
                , dropThickness : splashThickness
                , alpha : splashAlpha
                , splashing : false
            });
            thisDrop.breakawayTime = 0;
        }
    }
    
    
    function set_gradientColor1(input) 
    {
        gradientColor1 = input;
        r1 = (gradientColor1 >>16) & 0xFF;
        g1 = (gradientColor1 >>8) & 0xFF;
        b1 = gradientColor1 & 0xFF;
        return input;
    }
    
    function set_gradientColor2(input) 
    {
        gradientColor2 = input;
        r2 = (gradientColor2 >>16) & 0xFF;
        g2 = (gradientColor2 >>8) & 0xFF;
        b2 = gradientColor2 & 0xFF;
        return input;
    }
    
    
    
}