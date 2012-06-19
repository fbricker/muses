package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class FuncTime {
    /*
     * generated source for FuncTime
     */
    //static public var time_P : Vector<FuncTime> = [Time0()];
    static public var time_P : Array<FuncTime> = null;

    // modifiers: abstract
    public function pack(i : Dynamic, opb : Buffer) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function unpack(vi : Info, opb : Buffer) : Dynamic {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function look(vd : DspState, vm : InfoMode, i : Dynamic) : Dynamic {
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
    function forward(vb : Block, i : Dynamic) : Int {
        throw "UnimplementedAbstractMethod";
        return 0;
    }

    // modifiers: abstract
    function inverse(vb : Block, i : Dynamic, in_ : Vector<Float>, out : Vector<Float>) : Int {
        throw "UnimplementedAbstractMethod";
        return 0;
    }

    private static function __static_init__() : Void {
        //time_P = new Vector(1, true);
        time_P = ArrayTools.alloc(1);
        time_P[0] = new Time0();
    }

    public static function _s_init() : Void {
        if (time_P == null) {
            __static_init__();
        }
    }

    /*
    private static function __init__() : Void {
        //__static_init__();
    }
    */
}

