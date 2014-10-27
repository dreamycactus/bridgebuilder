package com.org.bbb;
import nape.phys.Material;

/**
 * ...
 * @author 
 */

enum MatType { BEAM; CABLE; DECK; WOOD; CONCRETE; }
 
class BuildMat
{
    public var name : String;
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
    
    public function new(name, matType, material, momentBreak, tensionBreak, compressionBreak, shearBreak, height, maxLength, cost, isRigid) 
    {
        this.name = name;
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