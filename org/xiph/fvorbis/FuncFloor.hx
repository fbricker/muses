package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class FuncFloor {
    /*
     * generated source for FuncFloor
     */
    //static public var floor_P : Array<FuncFloor> = [Floor0(), Floor1()];
    //static public var floor_P : Vector<FuncFloor> = null;
    static public var floor_P : Array<FuncFloor> = null;

    // modifiers: abstract
    public function pack(i : Dynamic, opb : Buffer) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function unpack(vi : Info, opb : Buffer) : Dynamic {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function look(vd : DspState, mi : InfoMode, i : Dynamic) : Dynamic {
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
    function free_state(vs : Dynamic) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    function forward(vb : Block, i : Dynamic, in_ : Vector<Float>, out : Vector<Float>, vs : Dynamic) : Int {
        throw "UnimplementedAbstractMethod";
        return 0;
    }

    // modifiers: abstract
    public function inverse1(vb : Block, i : Dynamic, memo : Dynamic) : Dynamic {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function inverse2(vb : Block, i : Dynamic, memo : Dynamic, out : Vector<Float>) : Int {
        throw "UnimplementedAbstractMethod";
        return 0;
    }

    private static function __static_init__() : Void {
        //floor_P = new Vector(2, true);
        floor_P = ArrayTools.alloc(2);
        floor_P[0] = new Floor0();
        floor_P[1] = new Floor1();
    }

    public static function _s_init() : Void {
        if (floor_P == null) {
            __static_init__();
        }
    }

    /*
    private static function __init__() : Void {
        //__static_init__();
    }
    */

}

