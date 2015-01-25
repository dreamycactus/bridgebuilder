package com.org.bbb.physics ;
import com.org.bbb.GameConfig.MaterialNames;
import nape.phys.Material;

/**
 * ...
 * @author 
 */

enum MatType { BEAM; CABLE; DECK; WOOD; CONCRETE; NULL; }
 
class BuildMat
{
    public var name : String;
    public var ename : MaterialNames;
    public var material : Material;
    public var matType : MatType;
    public var momentBreak  : Float;
    public var tensionBreak : Float;
    public var compressionBreak :Float;
    public var shearBreak :Float;
    public var height : Float;
    public var maxLength : Int;
    public var cost : Float;
    public var isRigid : Bool;
    
    public function new(name, ename, matType, material, momentBreak, tensionBreak, compressionBreak, shearBreak, height, maxLength, cost, isRigid) 
    {
        this.name = name;
        this.ename = ename;
        this.matType = matType;
        this.material = material;
        this.momentBreak = momentBreak;
        this.tensionBreak = tensionBreak;
        this.compressionBreak = compressionBreak;
        this.shearBreak = shearBreak;
        this.height = height;
        this.maxLength = maxLength;
        this.cost = cost;
        this.isRigid = isRigid;
    }
    
}