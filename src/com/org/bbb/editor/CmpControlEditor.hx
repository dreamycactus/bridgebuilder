package com.org.bbb.editor ;
import com.org.bbb.control.CmpBridgeBuild;
import com.org.bbb.control.CmpControl;
import com.org.bbb.editor.CmpAnchorInstance;
import com.org.bbb.level.CmpGrid;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.physics.BuildMat;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpTransform;
import com.org.bbb.render.Camera;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
import com.org.utils.ArrayHelper;
import nape.geom.Vec2;
import openfl.display.Stage;
import openfl.events.MouseEvent;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author ...
 */
using com.org.bbb.Util;
class CmpControlEditor extends CmpControl
{
    var stage : Stage;
    var top : Top;
    var state : MESState;
    
    public var level : CmpLevel;
    public var camera : Camera;
    var cmpGrid : CmpGrid;
    
    var inited : Bool = false;
    var builder : CmpBridgeBuild;
    //var material(get, set) : BuildMat;
    var prevMouse : Vec2;
    var editPanel : Widget;
    var editPanelTitle : Text;
    
    // Edit State
    var selectedEntity : Entity = null;
    var activeInstances : Array<EditorCmpInstance> = new Array();
    var isDrag : Bool = false;
    
    public function new(bridgebuilder : CmpBridgeBuild)
    {
        super();
        
        this.builder = bridgebuilder;
        
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
        prevMouse = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
    }
    function regEvents() : Void
    {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rmouseDown);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, rmouseUp);
    }
    
    function mouseDown(_) : Void
    {
        var mouse = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        var ents = state.getEntitiesOfType(GameConfig.tTransform); // Get entities having CmpTransform
        var res : Array<{area : Float, entity :Entity}> = new Array();
        var bodies = level.space.bodiesUnderPoint(mouse);
        for (b in bodies) {
            if (b.userData.entity != null) {
                res.push( { area : 1e5, entity : b.userData.entity } );
            }
        }
        for (e in ents) {
            var ct = e.getCmp(CmpTransform);
            if (ct.bbox != null && Util.pointInRect(mouse, ct.bbox)) {
                ArrayHelper.insertInPlace(res, { area : ct.bbox.width * ct.bbox.height, entity : e }, ascendingArea); 
            }
        }
        if (res.length != 0) {
            selectEntity(res[0].entity);
        } else {
            
        }
    }
    function mouseUp(_) : Void
    {
    }
    
    function rmouseDown(_) : Void
    {
        isDrag = true;
    }
    
    function rmouseUp(_) : Void
    {
        isDrag = false;
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
    
    //public function createEntity(EntityType
}