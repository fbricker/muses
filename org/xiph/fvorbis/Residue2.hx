package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class Residue2 extends Residue0 {
    /*
     * generated source for Residue2
     */

    // modifiers: 
    override function forward(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, ch : Int) : Int {
        trace("Residue0.forward: not implemented");
        return 0;
    }

    // modifiers: 
    override function inverse(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, nonzero : Vector<Int>, ch : Int) : Int {
        var i : Int = 0;
        // for-while;
        i = 0;
        while (i < ch) {
            if (nonzero[i] != 0) {
                break;
            };
            i++;
        };
        if (i == ch) {
            return 0;
        };
        return Residue0._inverse2(vb, vl, in_, ch);
    }

    public function new() {
        super();
    }
}
