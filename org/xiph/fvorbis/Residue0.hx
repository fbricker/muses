package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class Residue0 extends FuncResidue {
    /*
     * generated source for Residue0
     */

    // modifiers: 
    override function pack(vr : Dynamic, opb : Buffer) : Void {
        var info : InfoResidue0 = vr;
        var acc : Int = 0;
        opb.write(info.begin, 24);
        opb.write(info.end, 24);
        opb.write(info.grouping - 1, 24);
        opb.write(info.partitions - 1, 6);
        opb.write(info.groupbook, 8);
        // for-while;
        var j : Int = 0;
        while (j < info.partitions) {
            if (ilog(info.secondstages[j]) > 3) {
                opb.write(info.secondstages[j], 3);
                opb.write(1, 1);
                opb.write(info.secondstages[j] >>> 3, 5);
            }
            else {
                opb.write(info.secondstages[j], 4);
            };
            acc += icount(info.secondstages[j]);
            j++;
        };
        // for-while;
        var j : Int = 0;
        while (j < acc) {
            opb.write(info.booklist[j], 8);
            j++;
        };
    }

    // modifiers: 
    override function unpack(vi : Info, opb : Buffer) : Dynamic {
        var acc : Int = 0;
        var info : InfoResidue0 = new InfoResidue0();
        info.begin = opb.read(24);
        info.end = opb.read(24);
        info.grouping = (opb.read(24) + 1);
        info.partitions = (opb.read(6) + 1);
        info.groupbook = opb.read(8);
        // for-while;
        var j : Int = 0;
        while (j < info.partitions) {
            var cascade : Int = opb.read(3);
            if (opb.read(1) != 0) {
                cascade |= (opb.read(5) << 3);
            };
            info.secondstages[j] = cascade;
            acc += icount(cascade);
            j++;
        };
        // for-while;
        var j : Int = 0;
        while (j < acc) {
            info.booklist[j] = opb.read(8);
            j++;
        };
        if (info.groupbook >= vi.books) {
            free_info(info);
            return null;
        };
        // for-while;
        var j : Int = 0;
        while (j < acc) {
            if (info.booklist[j] >= vi.books) {
                free_info(info);
                return null;
            };
            j++;
        };
        return info;
    }

    // modifiers: 
    override function look(vd : DspState, vm : InfoMode, vr : Dynamic) : Dynamic {
        var info : InfoResidue0 = vr;
        var look : LookResidue0 = new LookResidue0();
        var acc : Int = 0;
        var dim : Int;
        var maxstage : Int = 0;
        look.info = info;
        look.map = vm.mapping;
        look.parts = info.partitions;
        look.fullbooks = vd.fullbooks;
        look.phrasebook = vd.fullbooks[info.groupbook];
        dim = look.phrasebook.dim;
        //look.partbooks = new int[look.parts];
        look.partbooks = ArrayTools.alloc(look.parts);
        // for-while;
        var j : Int = 0;
        while (j < look.parts) {
            var stages : Int = ilog(info.secondstages[j]);
            if (stages != 0) {
                if (stages > maxstage) {
                    maxstage = stages;
                };
                //look.partbooks[j] = new int[stages];
                look.partbooks[j] = new Vector(stages, true);
                // for-while;
                var k : Int = 0;
                while (k < stages) {
                    if ((info.secondstages[j] & (1 << k)) != 0) {
                        look.partbooks[j][k] = info.booklist[acc++];
                    };
                    k++;
                };
            };
            j++;
        };
        look.partvals = Math.round(Math.pow(look.parts, dim));
        look.stages = maxstage;
        //look.decodemap = new int[look.partvals];
        look.decodemap = new Array();
        // for-while;
        var j : Int = 0;
        while (j < look.partvals) {
            var val : Int = j;
            var mult : Int = Std.int(look.partvals / look.parts);
            //look.decodemap[j] = new int[dim];
            look.decodemap[j] = new Vector(dim, true);
            // for-while;
            var k : Int = 0;
            while (k < dim) {
                var deco : Int = Std.int(val / mult);
                val -= (deco * mult);
                mult=Math.round(mult / look.parts);
                look.decodemap[j][k] = deco;
                k++;
            };
            j++;
        };
        return look;
    }

    // modifiers: 
    override function free_info(i : Dynamic) : Void {
    }

    // modifiers: 
    override function free_look(i : Dynamic) : Void {
    }

    // modifiers: 
    override function forward(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, ch : Int) : Int {
        trace("Residue0.forward: not implemented");
        return 0;
    }

    //static var partword : Array<Array<Array<Int>>> = new int[2];
    static var partword : Array<Array<Vector<Int>>> = [null, null];

    // modifiers: static, synchronized
    static function _inverse01(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, ch : Int, decodepart : Int) : Int {
        var i : Int;
        var j : Int;
        var k : Int;
        var l : Int;
        var s : Int;
        var look : LookResidue0 = vl;
        var info : InfoResidue0 = look.info;
        var samples_per_partition : Int = info.grouping;
        var partitions_per_word : Int = look.phrasebook.dim;
        var n : Int = info.end - info.begin;
        var partvals : Int = Std.int(n / samples_per_partition);
        var partwords : Int = Std.int(((partvals + partitions_per_word) - 1) / partitions_per_word);
        if (partword.length < ch) {
            //Residue0.partword = new int[ch];
            partword = ArrayTools.alloc(ch);
            // for-while;
            j = 0;
            while (j < ch) {
                //Residue0.partword[j] = new int[partwords];
                partword[j] = ArrayTools.alloc(partwords);
                j++;
            };
        }
        else {
            // for-while;
            j = 0;
            while (j < ch) {
                if ((partword[j] == null) || (partword[j].length < partwords)) {
                    //Residue0.partword[j] = new int[partwords];
                    partword[j] = ArrayTools.alloc(partwords);
                };
                j++;
            };
        };
        // for-while;
        s = 0;
        while (s < look.stages) {
            // for-while;
            i = 0;
            l = 0;
            while (i < partvals) {
                if (s == 0) {
                    // for-while;
                    j = 0;
                    while (j < ch) {
                        var temp : Int = look.phrasebook.decode(vb.opb);
                        if (temp == -1) {
                            return 0;
                        };
                        partword[j][l] = look.decodemap[temp];
                        if (partword[j][l] == null) {
                            return 0;
                        };
                        j++;
                    };
                };
                // for-while;
                k = 0;
                while ((k < partitions_per_word) && (i < partvals)) {
                    // for-while;
                    j = 0;
                    while (j < ch) {
                        var offset : Int = info.begin + (i * samples_per_partition);
                        if ((info.secondstages[partword[j][l][k]] & (1 << s)) != 0) {
                            var stagebook : CodeBook = look.fullbooks[look.partbooks[partword[j][l][k]][s]];
                            if (stagebook != null) {
                                if (decodepart == 0) {
                                    if (stagebook.decodevs_add(in_[j], offset, vb.opb, samples_per_partition) == -1) {
                                        return 0;
                                    };
                                }
                                else {
                                    if (decodepart == 1) {
                                        if (stagebook.decodev_add(in_[j], offset, vb.opb, samples_per_partition) == -1) {
                                            return 0;
                                        };
                                    };
                                };
                            };
                        };
                        j++;
                    };
                    k++; i++;
                };
                l++;
            };
            s++;
        };
        return 0;
    }

    // modifiers: static
    static function _inverse2(vb : Block, vl : Dynamic, in_ : Array<Vector<Float>>, ch : Int) : Int {
        var i : Int;
        var j : Int;
        var k : Int;
        var l : Int;
        var s : Int;
        var look : LookResidue0 = vl;
        var info : InfoResidue0 = look.info;
        var samples_per_partition : Int = info.grouping;
        var partitions_per_word : Int = look.phrasebook.dim;
        var n : Int = info.end - info.begin;
        var partvals : Int = Std.int(n / samples_per_partition);
        var partwords : Int = Std.int(((partvals + partitions_per_word) - 1) / partitions_per_word);
        //var partword : Array<Array<Int>> = new int[partwords];
        var partword : Array<Vector<Int>> = new Array();
        // for-while;
        s = 0;
        while (s < look.stages) {
            // for-while;
            i = 0;
            l = 0;
            while (i < partvals) {
                if (s == 0) {
                    var temp : Int = look.phrasebook.decode(vb.opb);
                    if (temp == -1) {
                        return 0;
                    };
                    partword[l] = look.decodemap[temp];
                    if (partword[l] == null) {
                        return 0;
                    };
                };
                // for-while;
                k = 0;
                while ((k < partitions_per_word) && (i < partvals)) {
                    var offset : Int = info.begin + (i * samples_per_partition);
                    if ((info.secondstages[partword[l][k]] & (1 << s)) != 0) {
                        var stagebook : CodeBook = look.fullbooks[look.partbooks[partword[l][k]][s]];
                        if (stagebook != null) {
                            if (stagebook.decodevv_add(in_, offset, ch, vb.opb, samples_per_partition) == -1) {
                                return 0;
                            };
                        };
                    };
                    k++; i++;
                };
                l++;
            };
            s++;
        };
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
            return _inverse01(vb, vl, in_, used, 0);
        }
        else {
            return 0;
        };
    }

    // modifiers: static, private
    static private function ilog(v : Int) : Int {
        var ret : Int = 0;
        while (v != 0) {
            ret++;
            v >>>= 1;
        };
        return ret;
    }

    // modifiers: static, private
    static private function icount(v : Int) : Int {
        var ret : Int = 0;
        while (v != 0) {
            ret += (v & 1);
            v >>>= 1;
        };
        return ret;
    }

    public function new() {
    }
}


class LookResidue0 {
    /*
     * generated source for LookResidue0
     */
    public var info : InfoResidue0;
    public var map : Int;
    public var parts : Int;
    public var stages : Int;
    public var fullbooks : Array<CodeBook>;
    public var phrasebook : CodeBook;
    public var partbooks : Array<Vector<Int>>;
    public var partvals : Int;
    public var decodemap : Array<Vector<Int>>;
    public var postbits : Int;
    public var phrasebits : Int;
    public var frames : Int;

    public function new() {
    }
}
class InfoResidue0 {
    /*
     * generated source for InfoResidue0
     */
    public var begin : Int;
    public var end : Int;
    public var grouping : Int;
    public var partitions : Int;
    public var groupbook : Int;
    // discarded initializer: 'new int[64]';
    public var secondstages : Vector<Int>;
    // discarded initializer: 'new int[256]';
    public var booklist : Vector<Int>;
    // discarded initializer: 'new float[64]';
    public var entmax : Vector<Float>;
    // discarded initializer: 'new float[64]';
    public var ampmax : Vector<Float>;
    // discarded initializer: 'new int[64]';
    public var subgrp : Vector<Int>;
    // discarded initializer: 'new int[64]';
    public var blimit : Vector<Int>;

    public function new() {
        secondstages = new Vector(64);
        booklist = new Vector(256);
        entmax = new Vector(64);
        ampmax = new Vector(64);
        subgrp = new Vector(64);
        blimit = new Vector(64);
    }
}

