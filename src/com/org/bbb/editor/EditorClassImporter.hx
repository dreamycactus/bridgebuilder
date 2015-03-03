package com.org.bbb.editor ;
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;
/**
 * ...
 * @author ...
 */
class EditorClassImporter
{
    #if macro
    public static function smallBuild() : Array<haxe.macro.Field>
    {
        var fields = Context.getBuildFields();
        fields.push( {
            name : 'hasEditorInstance',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FProp('get', 'never', TPath({pack : [], name : 'Bool'}))
        });
        fields.push( {
            name : 'get_hasEditorInstance',
            access : [APrivate],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro return false,
                params : [],
                ret : TPath({pack : [], name : 'Bool'})
            })
        });
        fields.push( {
            name : 'widget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FVar(widgetPath)
        });
        
        fields.push( {
            name : 'col1Widget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FVar(widgetPath)
        });
        fields.push( {
            name : 'col2Widget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FVar(widgetPath)
        });
        fields.push( {
            name : 'fieldsWidget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FVar(widgetPath)
        });
        fields.push( {
            name : 'title',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FVar(widgetPath)
        });
        fields.push( {
            name : 'createEditorWidget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro return null,
                params : [],
                ret : null
            })
        });
        fields.push( {
            name : 'refreshWidgets',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro {},
                params : [],
                ret : null
            })
        });
        fields.push( {
            name : 'deleteWidget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro {},
                params : [],
                ret : null
            })
        });
        return fields;
    }
    
    public static function build() : Array<haxe.macro.Field> 
    {
        var fields = Context.getBuildFields();
        
        // Exit if no 'editor' metadata tag for the class
        var classmetadata = Context.getLocalClass().get().meta.get();
        if (classmetadata.find(function(m) { return m.name == 'editor'; } ) == null) {
            return fields;
        }
        //var clazz = Context.getLocalClass().get();
        //var ct : ClassType = clazz.superClass.t.get();
        //ct.fields.get();

        // Locate fields to expose to editor based on 'editor' tag
        var widgetFields = [];
        for (f in fields) {
            if (f.meta == null) continue;
            for (m in f.meta) {
                if (m.name == 'editor') {
                    widgetFields.push(f);
                }
            }
        }        
        var states = [];
        states.push(macro var labelRows = []);
        states.push(macro var inputRows = []);
        states.push(macro super.createEditorWidget());
        states.push(macro var superFieldWidget = $p { ['this', 'fieldsWidget'] } );
        var refreshStates = [];
        refreshStates.push(macro var i = 0);
        
        for (w in widgetFields) {
            //Sys.println('wid : $w');
            switch(w.kind) {
            case FProp(g, s, t, e):
                var fieldInput : String = '${w.name}Field';
                var fieldLabel : String = '${w.name}Label';
                // Create label widget
                fields.push( {
                    name : fieldInput,
                    access : [APrivate],
                    pos : Context.currentPos(),
                    kind : FVar(myInputPath)
                });
                states.push(macro var $fieldLabel = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.Text, {
                    text : '${w.name}',
                    defaults : 'EditorCmpLabel'
                }));
                states.push(macro labelRows.push( $i { fieldLabel } ));
                
                // Find type of the field to expose
                var func = null;
                var typeName = null;
                if (t != null) {
                    switch(t) {
                    case TPath(p):
                        typeName = p.name;
                    case _:
                    }
                } else {
                    switch(e.expr) {
                    case EConst(c):
                        switch(c) {
                        case CInt(v):
                            typeName = "Int";
                        case CFloat(v):
                            typeName = "Float";
                        case _:
                        }
                    case _:
                    }
                }
                
                var parseFunc = macro inline function (v:Dynamic) : String { return Std.string(v); };
                //var parseFunc = null;
                switch (typeName) {
                case 'Float':
                    func = macro inline function(f : String) : Null<Float> {
                    var parsed = Std.parseFloat(f);
                    if (Math.isFinite(parsed)) {
                        return parsed;
                    }
                    return null;
                    }
                case 'String':
                    func = macro inline function(s : String) : String {
                        return s;
                    }
                case 'Bool':
                    func = macro inline function(s : String) : Null<Bool> {
                        var ss = s.toLowerCase();
                        if (ss == 'true') {
                            return true;
                        }
                        return false;
                    }
                case 'Int':
                    func = macro inline function(f : String) : Null<Int> {
                    return Std.parseInt(f);
                    }
                case 'Vec2':
                    parseFunc = macro inline function (v : nape.geom.Vec2) : String {
                        if (v == null) { return "null"; }
                        return v.x + "," + v.y;
                    }
                    func  = macro inline function(f : String) : nape.geom.Vec2 {
                        var s = f.split(',');
                        if (s.length == 2) {
                            var x = Std.parseFloat(s[0]);
                            var y = Std.parseFloat(s[1]);
                            if (!Math.isNaN(x) && !Math.isNaN(y)) {
                                return new nape.geom.Vec2(x, y);
                            }
                        }
                        return null;
                    }
                    
                default:
                }
                
                // Create input textfield and change event
                states.push(macro $p{['this', '$fieldInput']} = ru.stablex.ui.UIBuilder.create(com.org.bbb.widgets.MyInputText, {
                    text : Std.string($p { ['this', w.name]}),
                    defaults : 'EditorCmpField',
                    onTextChange : 
                        function() {
                        var parsed = ${func}($p { ['this', fieldInput] } .text);
                        if (parsed != null) {
                            $p { ['this', w.name] } = parsed;
                        }
                    },
                    onFocus :
                        function() {
                            $p { ['this', 'refreshWidgets'] } ();
                        }
                }));
                states.push(macro inputRows.push($p { ['this', '$fieldInput'] } ));
                refreshStates.push(macro var t = cast($p { ['this', 'col2Widget'] } .getChildAt(i), ru.stablex.ui.widgets.Text));
                refreshStates.push(macro t.text = $ { parseFunc } ($p { ['this', w.name] } ));
                case _:
            }
            refreshStates.push(macro i++);
        }
        // Setup columns and main widget
        states.push(macro $p{['this', 'col1Widget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.VBox, {
            align : 'top, left',
            children : $i { 'labelRows' },
            skinName : 'matBut2'
        }));
        states.push(macro $p{['this', 'col2Widget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.VBox, {
            align : 'top, left',
            children : $i { 'inputRows' },
            skinName : 'matBut2'
        }));
        states.push(macro var col = new ru.stablex.ui.layouts.Column());
        states.push(macro col.cols = [150, 150]);
        states.push(macro $p{['this', 'fieldsWidget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.HBox, {
            w : 300,
            layout : col,
            defaults : 'EditorWidgetProperties',
            children : [ $p{['this','col1Widget']}, $p{['this','col2Widget']}]
        }));
        
        // Create widget
        var fclassname : String = Context.getLocalClass().toString();
        var classname = fclassname.split('.').pop();
        states.push(macro $p{['this', 'title']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.Text, {
            text : '$classname',
            defaults : 'EditorCmpLabel'
        }));
        states.push(macro $p{['this', 'widget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.VBox, {
            w : 200,
            defaults : 'EditorWidgetProperties',
            children : [$p{['this', 'title']}, $p{['this', 'fieldsWidget']}]
        }));
        states.push(macro if (superFieldWidget != null && superFieldWidget.numChildren > 1) {
            var c0 = cast(superFieldWidget.getChildAt(0), ru.stablex.ui.widgets.Widget);
            var c1 = cast(superFieldWidget.getChildAt(1), ru.stablex.ui.widgets.Widget);
            for (c in 0...c0.numChildren) {
                $p { ['this', 'col1Widget'] }.addChild(c0.getChildAt(c));
                $p { ['this', 'col2Widget'] }.addChild(c1.getChildAt(c));
            }
        });
        fields.push( {
            name : 'get_hasEditorInstance',
            access : [APrivate, AOverride],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro return true,
                params : [],
                ret : TPath({pack : [], name : 'Bool'})
            })
        });
        fields.push( {
            name : 'createEditorWidget',
            access : [APublic, AOverride],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro $b { states },
                params : [],
                ret : null
            })
        });
        fields.push( {
            name : 'refreshWidgets',
            access : [APublic, AOverride],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro $b { refreshStates },
                params : [],
                ret : null
            })
        });
        var deleteStates = [];
        deleteStates.push(macro $p { ['this', 'widget'] } .free(true));
        fields.push( {
            name : 'deleteWidget',
            access : [APublic, AOverride],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro $b { deleteStates },
                params : [],
                ret : null
            })
        });
        return fields;
    }
    

    static var widgetPath : ComplexType = TPath( { pack : ['ru', 'stablex', 'ui', 'widgets'], name : 'Widget' } );
    static var myInputPath : ComplexType = TPath( { pack : ['com', 'org', 'bbb', 'widgets'], name : 'MyInputText' } );
    #end
}