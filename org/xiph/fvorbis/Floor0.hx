package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class Floor0 extends FuncFloor {
    /*
     * generated source for Floor0
     */

    // modifiers: 
    override function pack(i : Dynamic, opb : Buffer) : Void {
        var info : InfoFloor0 = i;
        opb.write(info.order, 8);
        opb.write(info.rate, 16);
        opb.write(info.barkmap, 16);
        opb.write(info.ampbits, 6);
        opb.write(info.ampdB, 8);
        opb.write(info.numbooks - 1, 4);
        // for-while;
        var j : Int = 0;
        while (j < info.numbooks) {
            opb.write(info.books[j], 8);
            j++;
        };
    }

    // modifiers: 
    override function unpack(vi : Info, opb : Buffer) : Dynamic {
        var info : InfoFloor0 = new InfoFloor0();
        info.order = opb.read(8);
        info.rate = opb.read(16);
        info.barkmap = opb.read(16);
        info.ampbits = opb.read(6);
        info.ampdB = opb.read(8);
        info.numbooks = (opb.read(4) + 1);
        if ((((info.order < 1) || (info.rate < 1)) || (info.barkmap < 1)) || (info.numbooks < 1)) {
            return null;
        };
        // for-while;
        var j : Int = 0;
        while (j < info.numbooks) {
            info.books[j] = opb.read(8);
            if ((info.books[j] < 0) || (info.books[j] >= vi.books)) {
                return null;
            };
            j++;
        };
        return info;
    }

    // modifiers: 
    override function look(vd : DspState, mi : InfoMode, i : Dynamic) : Dynamic {
        var scale : Float;
        var vi : Info = vd.vi;
        var info : InfoFloor0 = i;
        var look : LookFloor0 = new LookFloor0();
        look.m = info.order;
        look.n = Std.int(vi.blocksizes[mi.blockflag] / 2);
        look.ln = info.barkmap;
        look.vi = info;
        look.lpclook.init(look.ln, look.m);
        scale = (look.ln / toBARK(info.rate / 2.));
        //look.linearmap = new int[look.n];
        look.linearmap = new Vector(look.n, true);
        // for-while;
        var j : Int = 0;
        while (j < look.n) {
            var val : Int = Math.floor(toBARK(((info.rate / 2.) / look.n) * j) * scale);
            if (val >= look.ln) {
                val = look.ln;
            };
            look.linearmap[j] = val;
            j++;
        };
        return look;
    }

    // modifiers: static
    static function toBARK(f : Float) : Float {
        return ((13.1 * Math.atan(0.00074 * f)) + (2.24 * Math.atan((f * f) * 1.85e-8))) + (1e-4 * f);
    }

    // modifiers: 
    function state(i : Dynamic) : Dynamic {
        var state : EchstateFloor0 = new EchstateFloor0();
        var info : InfoFloor0 = i;
        //state.codewords = new int[info.order];
        state.codewords = new Vector(info.order, true);
        //state.curve = new float[info.barkmap];
        state.curve = new Vector(info.barkmap, true);
        state.frameno = -1;
        return state;
    }

    // modifiers: 
    override function free_info(i : Dynamic) : Void {
    }

    // modifiers: 
    override function free_look(i : Dynamic) : Void {
    }

    // modifiers: 
    override function free_state(vs : Dynamic) : Void {
    }

    // modifiers: 
    override function forward(vb : Block, i : Dynamic, in_ : Vector<Float>, out : Vector<Float>, vs : Dynamic) : Int {
        return 0;
    }

    // discarded initializer: 'null';
    var lsp : Vector<Float>;

    // modifiers: 
    function inverse(vb : Block, i : Dynamic, out : Vector<Float>) : Int {
        var look : LookFloor0 = i;
        var info : InfoFloor0 = look.vi;
        var ampraw : Int = vb.opb.read(info.ampbits);
        if (ampraw > 0) {
            var maxval : Int = (1 << info.ampbits) - 1;
            var amp : Float = (ampraw / maxval) * info.ampdB;
            var booknum : Int = vb.opb.read(ilog(info.numbooks));
            if ((booknum != -1) && (booknum < info.numbooks)) {
                // synchronized (this) ...;
                {
                    if ((lsp == null) || (lsp.length < look.m)) {
                        //lsp = new float[look.m];
                        lsp = new Vector(look.m, true);
                    }
                    else {
                        // for-while;
                        var j : Int = 0;
                        while (j < look.m) {
                            lsp[j] = 0.;
                            j++;
                        };
                    };
                    var b : CodeBook = vb.vd.fullbooks[info.books[booknum]];
                    var last : Float = 0.;
                    // for-while;
                    var j : Int = 0;
                    while (j < look.m) {
                        out[j] = 0.0;
                        j++;
                    };
                    // for-while;
                    var j : Int = 0;
                    while (j < look.m) {
                        if (b.decodevs(lsp, j, vb.opb, 1, -1) == -1) {
                            // for-while;
                            var k : Int = 0;
                            while (k < look.n) {
                                out[k] = 0.0;
                                k++;
                            };
                            return 0;
                        };
                        j += b.dim;
                    };
                    // for-while;
                    var j : Int = 0;
                    while (j < look.m) {
                        // for-while;
                        var k : Int = 0;
                        while (k < b.dim) {
                            lsp[j] += last;
                            k++; j++;
                        };
                        last = lsp[j - 1];
                    };
                    Lsp.lsp_to_curve(out, look.linearmap, look.n, look.ln, lsp, look.m, amp, info.ampdB);
                    return 1;
                };
            };
        };
        return 0;
    }

    // modifiers: 
    override function inverse1(vb : Block, i : Dynamic, memo : Dynamic) : Dynamic {
        var look : LookFloor0 = i;
        var info : InfoFloor0 = look.vi;
        var lsp : Vector<Float> = null;
        /*
        if (isinstance(memo, (Vector<Float>))) {
            lsp = memo;
        };
        */
        if (Std.is(memo, Vector)) {
            lsp = memo;
        }
        var ampraw : Int = vb.opb.read(info.ampbits);
        if (ampraw > 0) {
            var maxval : Int = (1 << info.ampbits) - 1;
            var amp : Float = (ampraw / maxval) * info.ampdB;
            var booknum : Int = vb.opb.read(ilog(info.numbooks));
            if ((booknum != -1) && (booknum < info.numbooks)) {
                var b : CodeBook = vb.vd.fullbooks[info.books[booknum]];
                var last : Float = 0.;
                if ((lsp == null) || (lsp.length < look.m + 1)) {
                    //lsp = new float[look.m + 1];
                    lsp = new Vector(look.m + 1, true);
                }
                else {
                    // for-while;
                    var j : Int = 0;
                    while (j < lsp.length) {
                        lsp[j] = 0.;
                        j++;
                    };
                };
                // for-while;
                var j : Int = 0;
                while (j < look.m) {
                    if (b.decodev_set(lsp, j, vb.opb, b.dim) == -1) {
                        return null;
                    };
                    j += b.dim;
                };
                // for-while;
                var j : Int = 0;
                while (j < look.m) {
                    // for-while;
                    var k : Int = 0;
                    while (k < b.dim) {
                        lsp[j] += last;
                        k++; j++;
                    };
                    last = lsp[j - 1];
                };
                lsp[look.m] = amp;
                return lsp;
            };
        };
        return null;
    }

    // modifiers: 
    override function inverse2(vb : Block, i : Dynamic, memo : Dynamic, out : Vector<Float>) : Int {
        var look : LookFloor0 = i;
        var info : InfoFloor0 = look.vi;
        if (memo != null) {
            var lsp : Vector<Float> = memo;
            var amp : Float = lsp[look.m];
            Lsp.lsp_to_curve(out, look.linearmap, look.n, look.ln, lsp, look.m, amp, info.ampdB);
            return 1;
        };
        // for-while;
        var j : Int = 0;
        while (j < look.n) {
            out[j] = 0.;
            j++;
        };
        return 0;
    }

    // modifiers: static
    static function fromdB(x : Float) : Float {
        return Math.exp(x * 0.11512925);
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

    // modifiers: static
    static function lsp_to_lpc(lsp : Vector<Float>, lpc : Vector<Float>, m : Int) : Void {
        var i : Int;
        var j : Int;
        var m2 : Int = Std.int(m / 2);
        //var O : Vector<Float> = new float[m2];
        var O : Vector<Float> = new Vector(m2, true);
        //var E : Vector<Float> = new float[m2];
        var E : Vector<Float> = new Vector(m2, true);
        var A : Float;
        //var Ae : Vector<Float> = new float[m2 + 1];
        var Ae : Vector<Float> = new Vector(m2 + 1, true);
        //var Ao : Vector<Float> = new float[m2 + 1];
        var Ao : Vector<Float> = new Vector(m2 + 1, true);
        var B : Float;
        //var Be : Vector<Float> = new float[m2];
        var Be : Vector<Float> = new Vector(m2, true);
        //var Bo : Vector<Float> = new float[m2];
        var Bo : Vector<Float> = new Vector(m2, true);
        var temp : Float;
        // for-while;
        i = 0;
        while (i < m2) {
            O[i] = -2. * Math.cos(lsp[i * 2]);
            E[i] = -2. * Math.cos(lsp[(i * 2) + 1]);
            i++;
        };
        // for-while;
        j = 0;
        while (j < m2) {
            Ae[j] = 0.;
            Ao[j] = 1.;
            Be[j] = 0.;
            Bo[j] = 1.;
            j++;
        };
        Ao[j] = 1.;
        Ae[j] = 1.;
        // for-while;
        i = 1;
        while (i < (m + 1)) {
            A = (B = 0.);
            // for-while;
            j = 0;
            while (j < m2) {
                temp = ((O[j] * Ao[j]) + Ae[j]);
                Ae[j] = Ao[j];
                Ao[j] = A;
                A += temp;
                temp = ((E[j] * Bo[j]) + Be[j]);
                Be[j] = Bo[j];
                Bo[j] = B;
                B += temp;
                j++;
            };
            lpc[i - 1] = ((((A + Ao[j]) + B) - Ae[j]) / 2);
            Ao[j] = A;
            Ae[j] = B;
            i++;
        };
    }

    // modifiers: static
    static function lpc_to_curve(curve : Vector<Float>, lpc : Vector<Float>, amp : Float, l : LookFloor0, name : String, frameno : Int) : Void {
        //var lcurve : Vector<Float> = new float[Math.max(l.ln * 2, (l.m * 2) + 2)];
        var lcurve : Vector<Float> = new Vector(System.max(l.ln * 2, (l.m * 2) + 2), true);
        if (amp == 0) {
            // for-while;
            var j : Int = 0;
            while (j < l.n) {
                curve[j] = 0.0;
                j++;
            };
            return;
        };
        l.lpclook.lpc_to_curve(lcurve, lpc, amp);
        // for-while;
        var i : Int = 0;
        while (i < l.n) {
            curve[i] = lcurve[l.linearmap[i]];
            i++;
        };
    }

    public function new() {
        lsp = null;
    }
}


class InfoFloor0 {
    /*
     * generated source for InfoFloor0
     */
    public var order : Int;
    public var rate : Int;
    public var barkmap : Int;
    public var ampbits : Int;
    public var ampdB : Int;
    public var numbooks : Int;
    // discarded initializer: 'new int[16]';
    public var books : Vector<Int>;

    public function new() {
        books = new Vector(16, true);
    }
}

class LookFloor0 {
    /*
     * generated source for LookFloor0
     */
    public var n : Int;
    public var ln : Int;
    public var m : Int;
    public var linearmap : Vector<Int>;
    public var vi : InfoFloor0;
    // discarded initializer: 'Lpc()';
    public var lpclook : Lpc;

    public function new() {
        lpclook = new Lpc();
    }
}

class EchstateFloor0 {
    /*
     * generated source for EchstateFloor0
     */
    public var codewords : Vector<Int>;
    public var curve : Vector<Float>;
    public var frameno : Int;
    public var codes : Int;

    public function new() {
    }
}

