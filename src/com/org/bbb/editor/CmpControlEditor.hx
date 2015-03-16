package com.org.bbb.editor ;
import com.org.bbb.control.CmpBridgeBuild;
import com.org.bbb.control.CmpControl;
import com.org.bbb.editor.CmpAnchorInstance;
import com.org.bbb.level.CmpGrid;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.level.LevelParser;
import com.org.bbb.level.LevelSerializer;
import com.org.bbb.physics.BuildMat;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpTransform;
import com.org.bbb.render.Camera;
import com.org.bbb.states.StateBridgeLevel;
import com.org.bbb.systems.SysRender;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
import com.org.utils.ArrayHelper;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.net.SharedObject;
import openfl.ui.Keyboard;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Floating;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;

using com.org.bbb.Util;

/**
 * ...
 * @author ...
 */
enum EditMode
{
    EDIT;
    BUILD;
    PLAY;
}
class CmpControlEditor extends CmpControl
{
    var stage : Stage;
    var top : Top;
    var state : MESState;
    
    public var level : CmpLevel;
    public var camera : Camera;
    var cmpGrid : CmpGrid;
    
    var inited : Bool = false;
    public var builder : CmpBridgeBuild;
    //var material(get, set) : BuildMat;
    var prevMouse : Vec2;
    var editPanel : Widget;
    var editPanelTitle : Text;
    
    // Edit State
    var selectedEntity : Entity = null;
    var activeInstances : Array<EditorCmpInstance> = new Array();
    var isDrag : Bool = false;
    var isDragEntity : Bool = false;
    var mode(default, set) : EditMode;
    
    public function new(bridgebuilder : CmpBridgeBuild)
    {
        super();
        
        this.builder = bridgebuilder;
        this.builder.material = GameConfig.matSteel;
        
        this.stage = builder.stage;
        this.top = builder.top;
        this.state = builder.state;
        this.level = builder.level;
        this.camera = builder.camera;
        this.cmpGrid = builder.cmpGrid;
        
        inited = true;
    }
    
    override public function init()
    {
        regEvents();
        editPanel = UIBuilder.get('cmpedit');
        editPanelTitle = cast(UIBuilder.get('cmpeditTitle'), Text);
        camera.isUnlocked = true;
        
        //material = level.materialsAllowed.length > 0 ?
            //GameConfig.nameToMat(level.materialsAllowed[0]) :
        
    }
    
    override public function deinit()
    {
        //unregEvents();
    }
    override public function update()
    {
        if (isDrag) {
            dragCamera();
        } 
        var mp = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        if (isDragEntity && selectedEntity != null) {
            var trans = selectedEntity.getCmp(CmpTransform);
            if (trans != null) {
                var delta = mp.sub(prevMouse);
                trans.x += delta.x;
                trans.y += delta.y;
                trans.refreshWidgets();
                trace('${trans.x}, ${trans.y}');
            }
        }
        prevMouse = mp;
    }
    function set_mode(m) 
    {
        if (m == mode) return m;
        if (mode != null) {
            switch(this.mode) {
            case EDIT:
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
                stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
            case BUILD:
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, buildMouseDown);
                stage.removeEventListener(MouseEvent.MOUSE_UP, buildMouseUp);
            case PLAY:
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, playMouseDown);
                stage.removeEventListener(MouseEvent.MOUSE_UP, playMouseUp);
            }
        }
        switch(m) {
        case EDIT:
            stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
        case BUILD:
            stage.addEventListener(MouseEvent.MOUSE_DOWN, buildMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, buildMouseUp);
        case PLAY:
            stage.addEventListener(MouseEvent.MOUSE_DOWN, playMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, playMouseUp);
        }
        return mode = m;
    }
    
    function regEvents() : Void
    {
        mode = EditMode.EDIT;
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rmouseDown);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, rmouseUp);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
    }
    
    // Editor Handlers
    function mouseDown(_) : Void
    {
        var localmouse = Vec2.get(stage.mouseX, stage.mouseY);
        if (localmouse.x > GameConfig.stageWidth - 300) {
            return;
        }
        var mouse = camera.screenToWorld(localmouse);
        var ents = state.getEntitiesOfType(GameConfig.tTransform); // Get entities having CmpTransform
        var res : Array<{area : Float, entity :Entity}> = new Array();
        var bodies = level.space.bodiesUnderPoint(mouse, new InteractionFilter(GameConfig.cgSensor));
        for (b in bodies) {
            if (b.userData.entity != null) {
                res.push( { area : 1e5, entity : b.userData.entity } );
            }
        }
        for (e in ents) {
            var ct = e.getCmp(CmpEditorBox);
            if (ct != null && ct.bbox != null && Util.pointInRect(mouse, ct.bbox)) {
                ArrayHelper.insertInPlace(res, { area : ct.bbox.width * ct.bbox.height, entity : e }, ascendingArea); 
            }
        }
        if (res.length != 0) {
            selectEntity(res[0].entity);
            isDragEntity = true;
        } else {
            isDragEntity = false;
        }
    }
    function mouseUp(_) : Void
    {
        isDragEntity = false;
    }
    
    function rmouseDown(_) : Void
    {
        isDrag = true;
    }
    
    function rmouseUp(_) : Void
    {
        isDrag = false;
    }
    
    // Build Handlers
    function buildMouseDown(e) : Void
    {
        builder.beamDown();
    } 
    function buildMouseUp(e) : Void
    {
        var e = builder.beamUp();
        if (e != null) {
            level.ents.push(e);
        }
        
    }
    function playMouseDown(e) : Void
    {
        builder.beamDown();
    } 
    function playMouseUp(e) : Void
    {
        builder.beamUp();
    }
    
    // Other handlers
    function keydown(e:KeyboardEvent) : Void
    {
        if (e.keyCode == Keyboard.PAGE_UP) {
            camera.zoom += 0.2;
        } else if (e.keyCode == Keyboard.PAGE_DOWN) {
            camera.zoom -= 0.2;
        }
    }
    
    function toggleDrawDebug() : Void
    {
        var re = state.getSystem(SysRender);
        re.drawDebug = ! re.drawDebug;
    }
    
    function dragCamera()
    {
        camera.dragCamera(camera.screenToWorld(Vec2.weak(stage.mouseX, stage.mouseY)).sub(
                            prevMouse).mul(
                                GameConfig.camDragCoeff) );
    }
    
    function ascendingArea(a : { area : Float, entity :Entity }, b : { area : Float, entity :Entity }) : Bool
    {
        return a.area < b.area;
    }
    
    function selectEntity(e : Entity) : Void 
    {
        if (e == selectedEntity) {
            return;
        }
        if (selectedEntity != null) {
            for (c in selectedEntity.cmps) {
                if (c.hasEditorInstance) {
                    c.deleteWidget();
                }
            }
        }
        selectedEntity = e;
        if (e != null) {
            editPanelTitle.text = 'Entity: ${e.id}';
        } else {
            editPanelTitle.text = 'Entity:';
        }
        for (c in e.cmps) {
            if (c.hasEditorInstance) {
                c.createEditorWidget();
                editPanel.addChild(c.widget);
            }
        }
        //var ca = e.getCmp(CmpAnchor);
        //ca.createEditorWidget();
        //editPanel.addChild(e.getCmp(CmpAnchor).widget);
    }   
    
    public function createDefaultEntity(type : String) : Void
    {
        var e : Entity = null;
        var offset = Vec2.get(200, 200);
        switch (type) {
        case "anchor":
            e = EntFactory.inst.createAnchor(offset, { w : 100, h : 100 }, false, AnchorStartEnd.NONE, false);
        case "terrain":
            e = EntFactory.inst.createTerrain("", level.space, offset);
        case "sprite":
            e = EntFactory.inst.createStaticSprite('img/editorsprite.png', 200, 200, 5);
        }
        state.insertEnt(e);
        level.ents.push(e);
    }
    
    public function loadLevel(json : String)
    {
        var par = new LevelParser(state);
        var l = par.parseLevelFromString(json);
        state.deinit();
        top.changeState(StateBridgeLevel.createFromLevel(cast(state), top, l));
    }
    
    function saveLevel() : Void
    {
        var state = cast(state, StateBridgeLevel);
        var ser = new LevelSerializer(state);
        cast(UIBuilder.get('saveFloating'), Floating).visible = true;
        var t = cast(UIBuilder.get('saveText'), Text);
        t.text = ser.generateJson(state);
    }
}