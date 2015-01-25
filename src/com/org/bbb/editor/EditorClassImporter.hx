package com.org.bbb.editor ;
import haxe.macro.Context;
import haxe.macro.Type.AnonStatus;
import haxe.macro.Type.ClassField;
import haxe.macro.Type.ClassType;
import haxe.macro.Type.FieldKind;
import haxe.rtti.Meta;
import haxe.macro.Type.TypedExpr;
import haxe.macro.Expr;


/**
 * ...
 * @author ...
 */
class EditorClassImporter
{
    macro public static function test(cls : String) 
    {
        switch (Context.getType(cls))
        {
        case TInst(cl, _):
            trace(cl.get().meta.get());
            trace(cl.get().fields.get()[0].type);
        case _:
        }
        return null;
    }
    
    macro static public function createClassEditorInstance(cls : String) : Expr
    {
        var fields : Array<ClassField> = null;
        switch (Context.getType(cls))
        {
        case TInst(cl, _):
            fields = cl.get().fields.get();
        case _:
            trace("cls is not a class");
        }
        
        for (f in fields) {
            var meta = f.meta.get();
            var exposeToEditor = false;
            for (m in meta) {
                if (m.name == 'editor') {
                    exposeToEditor = true;
                    break;
                }
            }
            if (exposeToEditor) {
                switch(f.type) {
                case TInst(cl, _):
                    trace(cl);
                case TAbstract(ty, _):
                    trace(ty);
                case _:
                }
            }
        }
        return macro 1;
    }
    
}