package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class FuncResidue {
    /*
     * generated source for FuncResidue
     */
    //static public var residue_P : Array<FuncResidue> = [Residue0(), Residue1(), Residue2()];
    static public var residue_P : Array<FuncResidue> = null;

    // modifiers: abstract
    public function pack(vr : Dynamic, opb : Buffer) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function unpack(vi : Info, opb : Buffer) : Dynamic {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function look(vd : DspState, vm : InfoMode, vr : Dynamic) : Dynamic {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function free_info(i : Dynamic) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    function free_look(i : Dynamic) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    function forward(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, ch : Int) : Int {
        throw "UnimplementedAbstractMethod";
        return 0;
    }

    // modifiers: abstract
    public function inverse(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, nonzero : Vector<Int>, ch : Int) : Int {
        throw "UnimplementedAbstractMethod";
        return 0;
    }

    private static function __static_init__() : Void {
        //residue_P = new Vector(3, true);
        residue_P = ArrayTools.alloc(3);
        residue_P[0] = new Residue0();
        residue_P[1] = new Residue1();
        residue_P[2] = new Residue2();
    }

    public static function _s_init() : Void {
        if (residue_P == null) {
            __static_init__();
        }
    }

    /*
    private static function __init__() : Void {
        //__static_init__();
    }
    */
}

