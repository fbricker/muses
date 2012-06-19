package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class FuncMapping {
    /*
     * generated source for FuncMapping
     */
    //static public var mapping_P : Vector<FuncMapping> = [Mapping0()];
    static public var mapping_P : Array<FuncMapping> = null;

    // modifiers: abstract
    public function pack(info : Info, imap : Dynamic, buffer : Buffer) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function unpack(info : Info, buffer : Buffer) : Dynamic {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function look(vd : DspState, vm : InfoMode, m : Dynamic) : Dynamic {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function free_info(imap : Dynamic) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    function free_look(imap : Dynamic) : Void {
        throw "UnimplementedAbstractMethod";
    }

    // modifiers: abstract
    public function inverse(vd : Block, lm : Dynamic) : Int {
        throw "UnimplementedAbstractMethod";
        return 0;
    }

    private static function __static_init__() : Void {
        //mapping_P = new Vector(1, true);
        mapping_P = ArrayTools.alloc(1);
        mapping_P[0] = new Mapping0();
    }

    public static function _s_init() : Void {
        if (mapping_P == null) {
            __static_init__();
        }
    }

    /*
    private static function __init__() : Void {
        //__static_init__();
    }
    */
}
