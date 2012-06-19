package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class Residue1 extends Residue0 {
    /*
     * generated source for Residue1
     */

    // modifiers: 
    override function forward(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, ch : Int) : Int {
        trace("Residue0.forward: not implemented");
        return 0;
    }

    // modifiers: 
    override function inverse(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, nonzero : Vector<Int>, ch : Int) : Int {
        var used : Int = 0;
        // for-while;
        var i : Int = 0;
        while (i < ch) {
            if (nonzero[i] != 0) {
                in_[used++] = in_[i];
            };
            i++;
        };
        if (used != 0) {
            return Residue0._inverse01(vb, vl, in_, used, 1);
        }
        else {
            return 0;
        };
    }

    public function new() {
        super();
    }
}
