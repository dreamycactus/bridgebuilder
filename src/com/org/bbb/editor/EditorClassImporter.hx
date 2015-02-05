package com.org.bbb.editor ;
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassField;
#if macro
#else
#end

using Lambda;
/**
 * ...
 * @author ...
 */
class EditorClassImporter
{
    #if macro
    public static function build() : Array<haxe.macro.Field> 
    {
        // Exit if no 'editor' metadata tag for the class
        var classmetadata = Context.getLocalClass().get().meta.get();
        if (classmetadata.find(function(m) { return m.name == 'editor'; } ) == null) {
            return null;
        }
        var fields = Context.getBuildFields();
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
            name : 'widget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FVar(widgetPath)
        });
        
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
        
        for (w in widgetFields) {
            Sys.println('wid : $w');
            switch(w.kind) {
            case FProp(g, s, t, _):
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
                switch(t) {
                case TPath(p):
                    typeName = p.name;
                case _:
                }
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
                    func = macro inline function(s : String) : Bool {
                        var ss = s.toLowerCase();
                        if (ss == 'true') {
                            return true;
                        }
                        return false;
                    }
                default:
                    
                }
                // Create input textfield and change event
                var parse = 'parseFloat';
                states.push(macro $p{['this', '$fieldInput']} = ru.stablex.ui.UIBuilder.create(com.org.bbb.widgets.MyInputText, {
                    text : Std.string($p { ['this', w.name]}),
                    defaults : 'EditorCmpField',
                    onTextChange : 
                        function() {
                        var parsed = ${func}($p { ['this', fieldInput] } .text);
                        if (parsed != null) {
                            $p { ['this', w.name] } = parsed;
                        }
                    }
                }));
                states.push(macro inputRows.push($p{['this', '$fieldInput']}));
                
            case _:
            }
        }
        // Setup columns and main widget
        states.push(macro $p{['this', 'col1Widget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.VBox, {
            align : 'top, left',
            children : $i{'labelRows'}
            //defaults : 'EditorCmpLabel'
        }));
        states.push(macro $p{['this', 'col2Widget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.VBox, {
            align : 'top, left',
            children : $i{'inputRows'}
            //defaults : 'EditorCmpLabel'
        }));
        var colId = 'col';
        states.push(macro var $colId = new ru.stablex.ui.layouts.Column());
        states.push(macro $i{colId}.cols = [80, 120]);
        states.push(macro $p{['this', 'fieldsWidget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.VBox, {
            w : 200,
            layout : $i{colId},
            children : [ $p{['this','col1Widget']}, $p{['this','col2Widget']}]
        }));
        
        // Create widget
        var classname = Context.getClassPath().join('.');
        states.push(macro $p{['this', 'title']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.Text, {
            text : '$classname',
            defaults : 'EditorCmpLabel'
        }));
        states.push(macro $p{['this', 'widget']} = ru.stablex.ui.UIBuilder.create(ru.stablex.ui.widgets.VBox, {
            w : 200,
            align : 'top, left',
            children : [$p{['this', 'title']}, $p{['this', 'fieldsWidget']}]
        }));
        fields.push( {
            name : 'createEditorWidget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro $b { states },
                params : [],
                ret : widgetPath
            })
        });
        states.push(macro return new ru.stablex.ui.widgets.Widget());
        
        var deleteStates = [];
        fields.push( {
            name : 'deleteWidget',
            access : [APublic],
            pos : Context.currentPos(),
            kind : FFun( {
                args : [],
                expr : macro $b { states },
                params : [],
                ret : null
            })
        });
        return fields;
    }
    
    static inline function parseFloat(f : String) : Null<Float>
    {
        var parsed = Std.parseFloat(f);
        if (Math.isFinite(parsed)) {
            return parsed;
        }
        return null;
    }

    static var widgetPath : ComplexType = TPath( { pack : ['ru', 'stablex', 'ui', 'widgets'], name : 'Widget' } );
    static var myInputPath : ComplexType = TPath( { pack : ['com', 'org', 'bbb', 'widgets'], name : 'MyInputText' } );
    #end
}