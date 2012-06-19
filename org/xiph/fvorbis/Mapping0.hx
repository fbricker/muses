package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class Mapping0 extends FuncMapping {
    /*
     * generated source for Mapping0
     */
    static var seq : Int = 0;

    // modifiers: 
    override function free_info(imap : Dynamic) : Void {
    }

    // modifiers: 
    override function free_look(imap : Dynamic) : Void {
    }

    // modifiers: 
    override function look(vd : DspState, vm : InfoMode, m : Dynamic) : Dynamic {
        var vi : Info = vd.vi;
        var look : LookMapping0 = new LookMapping0();
        var info : InfoMapping0 = look.map = m;
        look.mode = vm;
        // look.time_look = new Object[info.submaps];
        // look.floor_look = new Object[info.submaps];
        // look.residue_look = new Object[info.submaps];
        // look.time_func = new FuncTime[info.submaps];
        // look.floor_func = new FuncFloor[info.submaps];
        // look.residue_func = new FuncResidue[info.submaps];
        look.time_look = ArrayTools.alloc(info.submaps);
        look.floor_look = ArrayTools.alloc(info.submaps);
        look.residue_look = ArrayTools.alloc(info.submaps);
        look.time_func = ArrayTools.alloc(info.submaps);
        look.floor_func = ArrayTools.alloc(info.submaps);
        look.residue_func = ArrayTools.alloc(info.submaps);
        // for-while;
        var i : Int = 0;
        while (i < info.submaps) {
            var timenum : Int = info.timesubmap[i];
            var floornum : Int = info.floorsubmap[i];
            var resnum : Int = info.residuesubmap[i];
            look.time_func[i] = FuncTime.time_P[vi.time_type[timenum]];
            look.time_look[i] = look.time_func[i].look(vd, vm, vi.time_param[timenum]);
            look.floor_func[i] = FuncFloor.floor_P[vi.floor_type[floornum]];
            look.floor_look[i] = look.floor_func[i].look(vd, vm, vi.floor_param[floornum]);
            look.residue_func[i] = FuncResidue.residue_P[vi.residue_type[resnum]];
            look.residue_look[i] = look.residue_func[i].look(vd, vm, vi.residue_param[resnum]);
            i++;
        };
        if ((vi.psys != 0) && (vd.analysisp != 0)) {
        };
        look.ch = vi.channels;
        return look;
    }

    // modifiers: 
    override function pack(vi : Info, imap : Dynamic, opb : Buffer) : Void {
        var info : InfoMapping0 = imap;
        if (info.submaps > 1) {
            opb.write(1, 1);
            opb.write(info.submaps - 1, 4);
        }
        else {
            opb.write(0, 1);
        };
        if (info.coupling_steps > 0) {
            opb.write(1, 1);
            opb.write(info.coupling_steps - 1, 8);
            // for-while;
            var i : Int = 0;
            while (i < info.coupling_steps) {
                opb.write(info.coupling_mag[i], ilog2(vi.channels));
                opb.write(info.coupling_ang[i], ilog2(vi.channels));
                i++;
            };
        }
        else {
            opb.write(0, 1);
        };
        opb.write(0, 2);
        if (info.submaps > 1) {
            // for-while;
            var i : Int = 0;
            while (i < vi.channels) {
                opb.write(info.chmuxlist[i], 4);
                i++;
            };
        };
        // for-while;
        var i : Int = 0;
        while (i < info.submaps) {
            opb.write(info.timesubmap[i], 8);
            opb.write(info.floorsubmap[i], 8);
            opb.write(info.residuesubmap[i], 8);
            i++;
        };
    }

    // modifiers: 
    override function unpack(vi : Info, opb : Buffer) : Dynamic {
        var info : InfoMapping0 = new InfoMapping0();
        if (opb.read(1) != 0) {
            info.submaps = (opb.read(4) + 1);
        }
        else {
            info.submaps = 1;
        };
        if (opb.read(1) != 0) {
            info.coupling_steps = (opb.read(8) + 1);
            // for-while;
            var i : Int = 0;
            while (i < info.coupling_steps) {
                var testM : Int = info.coupling_mag[i] = opb.read(ilog2(vi.channels));
                var testA : Int = info.coupling_ang[i] = opb.read(ilog2(vi.channels));
                if (((((testM < 0) || (testA < 0)) || (testM == testA)) || (testM >= vi.channels)) || (testA >= vi.channels)) {
                    info.free();
                    return;
                };
                i++;
            };
        };
        if (opb.read(2) > 0) {
            info.free();
            return;
        };
        if (info.submaps > 1) {
            // for-while;
            var i : Int = 0;
            while (i < vi.channels) {
                info.chmuxlist[i] = opb.read(4);
                if (info.chmuxlist[i] >= info.submaps) {
                    info.free();
                    return;
                };
                i++;
            };
        };
        // for-while;
        var i : Int = 0;
        while (i < info.submaps) {
            info.timesubmap[i] = opb.read(8);
            if (info.timesubmap[i] >= vi.times) {
                info.free();
                return;
            };
            info.floorsubmap[i] = opb.read(8);
            if (info.floorsubmap[i] >= vi.floors) {
                info.free();
                return;
            };
            info.residuesubmap[i] = opb.read(8);
            if (info.residuesubmap[i] >= vi.residues) {
                info.free();
                return;
            };
            i++;
        };
        return info;
    }

    // discarded initializer: 'null';
    var pcmbundle : Array<Vector<Float>>;
    // discarded initializer: 'null';
    var zerobundle : Vector<Int>;
    // discarded initializer: 'null';
    var nonzero : Vector<Int>;
    // discarded initializer: 'null';
    var floormemo : Array<Dynamic>;

    // modifiers: synchronized
    override function inverse(vb : Block, l : Dynamic) : Int {
        var vd : DspState = vb.vd;
        var vi : Info = vd.vi;
        var look : LookMapping0 = l;
        var info : InfoMapping0 = look.map;
        var mode : InfoMode = look.mode;
        var n : Int = vb.pcmend = vi.blocksizes[vb.W];
        var window : Vector<Float> = vd.window[vb.W][vb.lW][vb.nW][mode.windowtype];
        if ((pcmbundle == null) || (pcmbundle.length < vi.channels)) {
            // pcmbundle = new float[vi.channels];
            // nonzero = new int[vi.channels];
            // zerobundle = new int[vi.channels];
            // floormemo = new Object[vi.channels];
            ////pcmbundle = new Vector(vi.channels, true);
            pcmbundle = ArrayTools.alloc(vi.channels);
            nonzero = new Vector(vi.channels, true);
            zerobundle = new Vector(vi.channels, true);
            //floormemo = new Vector(vi.channels, true);
            floormemo = ArrayTools.alloc(vi.channels);
        };
        // for-while;
        var i : Int = 0;
        while (i < vi.channels) {
            var pcm : Vector<Float> = vb.pcm[i];
            var submap : Int = info.chmuxlist[i];
            floormemo[i] = look.floor_func[submap].inverse1(vb, look.floor_look[submap], floormemo[i]);
            if (floormemo[i] != null) {
                nonzero[i] = 1;
            }
            else {
                nonzero[i] = 0;
            };
            // for-while;
            var j : Int = 0;
            while (j < (n / 2)) {
                pcm[j] = 0;
                j++;
            };
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < info.coupling_steps) {
            if ((nonzero[info.coupling_mag[i]] != 0) || (nonzero[info.coupling_ang[i]] != 0)) {
                nonzero[info.coupling_mag[i]] = 1;
                nonzero[info.coupling_ang[i]] = 1;
            };
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < info.submaps) {
            var ch_in_bundle : Int = 0;
            // for-while;
            var j : Int = 0;
            while (j < vi.channels) {
                if (info.chmuxlist[j] == i) {
                    if (nonzero[j] != 0) {
                        zerobundle[ch_in_bundle] = 1;
                    }
                    else {
                        zerobundle[ch_in_bundle] = 0;
                    };
                    pcmbundle[ch_in_bundle++] = vb.pcm[j];
                };
                j++;
            };
            look.residue_func[i].inverse(vb, look.residue_look[i], pcmbundle, zerobundle, ch_in_bundle);
            i++;
        };
        // for-while;
        var i : Int = info.coupling_steps - 1;
        while (i >= 0) {
            var pcmM : Vector<Float> = vb.pcm[info.coupling_mag[i]];
            var pcmA : Vector<Float> = vb.pcm[info.coupling_ang[i]];
            // for-while;
            var j : Int = 0;
            while (j < (n / 2)) {
                var mag : Float = pcmM[j];
                var ang : Float = pcmA[j];
                if (mag > 0) {
                    if (ang > 0) {
                        pcmM[j] = mag;
                        pcmA[j] = (mag - ang);
                    }
                    else {
                        pcmA[j] = mag;
                        pcmM[j] = (mag + ang);
                    };
                }
                else {
                    if (ang > 0) {
                        pcmM[j] = mag;
                        pcmA[j] = (mag + ang);
                    }
                    else {
                        pcmA[j] = mag;
                        pcmM[j] = (mag - ang);
                    };
                };
                j++;
            };
            i--;
        };
        // for-while;
        var i : Int = 0;
        while (i < vi.channels) {
            var pcm : Vector<Float> = vb.pcm[i];
            var submap : Int = info.chmuxlist[i];
            look.floor_func[submap].inverse2(vb, look.floor_look[submap], floormemo[i], pcm);
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < vi.channels) {
            var pcm : Vector<Float> = vb.pcm[i];
            vd.transform[vb.W][0].backward(pcm, pcm);
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < vi.channels) {
            var pcm : Vector<Float> = vb.pcm[i];
            if (nonzero[i] != 0) {
                // for-while;
                var j : Int = 0;
                while (j < n) {
                    pcm[j] *= window[j];
                    j++;
                };
            }
            else {
                // for-while;
                var j : Int = 0;
                while (j < n) {
                    pcm[j] = 0.;
                    j++;
                };
            };
            i++;
        };
        return 0;
    }

    // modifiers: static, private
    static private function ilog2(v : Int) : Int {
        var ret : Int = 0;
        while (v > 1) {
            ret++;
            v >>>= 1;
        };
        return ret;
    }

    public function new() {
        pcmbundle = null;
        zerobundle = null;
        nonzero = null;
        floormemo = null;
    }
}


class InfoMapping0 {
    /*
     * generated source for InfoMapping0
     */
    public var submaps : Int;
    // discarded initializer: 'new int[256]';
    public var chmuxlist : Vector<Int>;
    // discarded initializer: 'new int[16]';
    public var timesubmap : Vector<Int>;
    // discarded initializer: 'new int[16]';
    public var floorsubmap : Vector<Int>;
    // discarded initializer: 'new int[16]';
    public var residuesubmap : Vector<Int>;
    // discarded initializer: 'new int[16]';
    public var psysubmap : Vector<Int>;
    public var coupling_steps : Int;
    // discarded initializer: 'new int[256]';
    public var coupling_mag : Vector<Int>;
    // discarded initializer: 'new int[256]';
    public var coupling_ang : Vector<Int>;

    public function new() {
        chmuxlist = new Vector(256, true);
        timesubmap = new Vector(16, true);
        floorsubmap = new Vector(16, true);
        residuesubmap = new Vector(16, true);
        psysubmap = new Vector(16, true);
        coupling_mag = new Vector(256, true);
        coupling_ang = new Vector(256, true);
    }

    // modifiers: 
    public function free() : Void {
        chmuxlist = null;
        timesubmap = null;
        floorsubmap = null;
        residuesubmap = null;
        psysubmap = null;
        coupling_mag = null;
        coupling_ang = null;
    }
}

class LookMapping0 {
    /*
     * generated source for LookMapping0
     */
    public var mode : InfoMode;
    public var map : InfoMapping0;
    public var time_look : Array<Dynamic>;
    public var floor_look : Array<Dynamic>;
    public var floor_state : Array<Dynamic>;
    public var residue_look : Array<Dynamic>;
    public var psy_look : Array<PsyLook>;
    public var time_func : Array<FuncTime>;
    public var floor_func : Array<FuncFloor>;
    public var residue_func : Array<FuncResidue>;
    public var ch : Int;
    public var decay : Array<Vector<Float>>;
    public var lastframe : Int;

    public function new() {
    }
}
