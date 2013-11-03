package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class Floor1 extends FuncFloor {
    /*
     * generated source for Floor1
     */
    inline static var floor1_rangedb : Int = 140;
    inline static var VIF_POSIT : Int = 63;

    // modifiers: 
    override function pack(i : Dynamic, opb : Buffer) : Void {
        var info : InfoFloor1 = i;
        var count : Int = 0;
        var rangebits : Int;
        var maxposit : Int = info.postlist[1];
        var maxclass : Int = -1;
        opb.write(info.partitions, 5);
        // for-while;
        var j : Int = 0;
        while (j < info.partitions) {
            opb.write(info.partitionclass[j], 4);
            if (maxclass < info.partitionclass[j]) {
                maxclass = info.partitionclass[j];
            };
            j++;
        };
        // for-while;
        var j : Int = 0;
        while (j < (maxclass + 1)) {
            opb.write(info.class_dim[j] - 1, 3);
            opb.write(info.class_subs[j], 2);
            if (info.class_subs[j] != 0) {
                opb.write(info.class_book[j], 8);
            };
            // for-while;
            var k : Int = 0;
            while (k < (1 << info.class_subs[j])) {
                opb.write(info.class_subbook[j][k] + 1, 8);
                k++;
            };
            j++;
        };
        opb.write(info.mult - 1, 2);
        opb.write(ilog2(maxposit), 4);
        rangebits = ilog2(maxposit);
        // for-while;
        var j : Int = 0;
        var k : Int = 0;
        while (j < info.partitions) {
            count += info.class_dim[info.partitionclass[j]];
            // for-while;
            while (k < count) {
                opb.write(info.postlist[k + 2], rangebits);
                k++;
            };
            j++;
        };
    }

    // modifiers: 
    override function unpack(vi : Info, opb : Buffer) : Dynamic {
        var count : Int = 0;
        var maxclass : Int = -1;
        var rangebits : Int;
        var info : InfoFloor1 = new InfoFloor1();
        info.partitions = opb.read(5);
        // for-while;
        var j : Int = 0;
        while (j < info.partitions) {
            info.partitionclass[j] = opb.read(4);
            if (maxclass < info.partitionclass[j]) {
                maxclass = info.partitionclass[j];
            };
            j++;
        };
        // for-while;
        var j : Int = 0;
        while (j < (maxclass + 1)) {
            info.class_dim[j] = (opb.read(3) + 1);
            info.class_subs[j] = opb.read(2);
            if (info.class_subs[j] < 0) {
                info.free();
                return null;
            };
            if (info.class_subs[j] != 0) {
                info.class_book[j] = opb.read(8);
            };
            if ((info.class_book[j] < 0) || (info.class_book[j] >= vi.books)) {
                info.free();
                return null;
            };
            // for-while;
            var k : Int = 0;
            while (k < (1 << info.class_subs[j])) {
                info.class_subbook[j][k] = (opb.read(8) - 1);
                if ((info.class_subbook[j][k] < -1) || (info.class_subbook[j][k] >= vi.books)) {
                    info.free();
                    return null;
                };
                k++;
            };
            j++;
        };
        info.mult = (opb.read(2) + 1);
        rangebits = opb.read(4);
        // for-while;
        var j : Int = 0;
        var k : Int = 0;
        while (j < info.partitions) {
            count += info.class_dim[info.partitionclass[j]];
            // for-while;
            while (k < count) {
                var t : Int = info.postlist[k + 2] = opb.read(rangebits);
                if ((t < 0) || (t >= (1 << rangebits))) {
                    info.free();
                    return null;
                };
                k++;
            };
            j++;
        };
        info.postlist[0] = 0;
        info.postlist[1] = (1 << rangebits);
        return info;
    }

    // modifiers: 
    override function look(vd : DspState, mi : InfoMode, i : Dynamic) : Dynamic {
        var _n : Int = 0;
        //var sortpointer : Vector<Int> = new int[Floor1.VIF_POSIT + 2];
        var sortpointer : Vector<Int> = new Vector(VIF_POSIT + 2, true);
        var info : InfoFloor1 = i;
        var look : LookFloor1 = new LookFloor1();
        look.vi = info;
        look.n = info.postlist[1];
        // for-while;
        var j : Int = 0;
        while (j < info.partitions) {
            _n += info.class_dim[info.partitionclass[j]];
            j++;
        };
        _n += 2;
        look.posts = _n;
        // for-while;
        var j : Int = 0;
        while (j < _n) {
            sortpointer[j] = j;
            j++;
        };
        var foo : Int;
        // for-while;
        var j : Int = 0;
        while (j < (_n - 1)) {
            // for-while;
            var k : Int = j;
            while (k < _n) {
                if (info.postlist[sortpointer[j]] > info.postlist[sortpointer[k]]) {
                    foo = sortpointer[k];
                    sortpointer[k] = sortpointer[j];
                    sortpointer[j] = foo;
                };
                k++;
            };
            j++;
        };
        // for-while;
        var j : Int = 0;
        while (j < _n) {
            look.forward_index[j] = sortpointer[j];
            j++;
        };
        // for-while;
        var j : Int = 0;
        while (j < _n) {
            look.reverse_index[look.forward_index[j]] = j;
            j++;
        };
        // for-while;
        var j : Int = 0;
        while (j < _n) {
            look.sorted_index[j] = info.postlist[look.forward_index[j]];
            j++;
        };

        switch (info.mult) {
        case 1:
            look.quant_q = 256;

        case 2:
            look.quant_q = 128;

        case 3:
            look.quant_q = 86;

        case 4:
            look.quant_q = 64;

        default:
            look.quant_q = -1;
        };

        // for-while;
        var j : Int = 0;
        while (j < (_n - 2)) {
            var lo : Int = 0;
            var hi : Int = 1;
            var lx : Int = 0;
            var hx : Int = look.n;
            var currentx : Int = info.postlist[j + 2];
            // for-while;
            var k : Int = 0;
            while (k < (j + 2)) {
                var x : Int = info.postlist[k];
                if ((x > lx) && (x < currentx)) {
                    lo = k;
                    lx = x;
                };
                if ((x < hx) && (x > currentx)) {
                    hi = k;
                    hx = x;
                };
                k++;
            };
            look.loneighbor[j] = lo;
            look.hineighbor[j] = hi;
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
    override function free_state(vs : Dynamic) : Void {
    }

    // modifiers: 
    override function forward(vb : Block, i : Dynamic, in_ : Vector<Float>, out : Vector<Float>, vs : Dynamic) : Int {
        return 0;
    }

    // modifiers: 
    override function inverse1(vb : Block, ii : Dynamic, memo : Dynamic) : Dynamic {
        var look : LookFloor1 = ii;
        var info : InfoFloor1 = look.vi;
        var books : Array<CodeBook> = vb.vd.fullbooks;
        if (vb.opb.read(1) == 1) {
            var fit_value : Vector<Int> = null;
            if (Std.is(memo, Vector)) {
                fit_value = memo;
            };
            if ((fit_value == null) || (fit_value.length < look.posts)) {
                //fit_value = new int[look.posts];
                fit_value = new Vector(look.posts, true);
            }
            else {
                // for-while;
                var i : Int = 0;
                while (i < fit_value.length) {
                    fit_value[i] = 0;
                    i++;
                };
            };
            fit_value[0] = vb.opb.read(ilog(look.quant_q - 1));
            fit_value[1] = vb.opb.read(ilog(look.quant_q - 1));
            // for-while;
            var i : Int = 0;
            var j : Int = 2;
            while (i < info.partitions) {
                var clss : Int = info.partitionclass[i];
                var cdim : Int = info.class_dim[clss];
                var csubbits : Int = info.class_subs[clss];
                var csub : Int = 1 << csubbits;
                var cval : Int = 0;
                if (csubbits != 0) {
                    cval = books[info.class_book[clss]].decode(vb.opb);
                    if (cval == -1) {
                        return null;
                    };
                };
                // for-while;
                var k : Int = 0;
                while (k < cdim) {
                    var book : Int = info.class_subbook[clss][cval & (csub - 1)];
                    cval >>>= csubbits;
                    if (book >= 0) {
                        if ((fit_value[j + k] = books[book].decode(vb.opb)) == -1) {
                            return null;
                        };
                    }
                    else {
                        fit_value[j + k] = 0;
                    };
                    k++;
                };
                j += cdim;
                i++;
            };
            // for-while;
            var i : Int = 2;
            while (i < look.posts) {
                var predicted : Int = render_point(info.postlist[look.loneighbor[i - 2]], info.postlist[look.hineighbor[i - 2]], fit_value[look.loneighbor[i - 2]], fit_value[look.hineighbor[i - 2]], info.postlist[i]);
                var hiroom : Int = look.quant_q - predicted;
                var loroom : Int = predicted;
                var room : Int = ((hiroom < loroom ? hiroom : loroom)) << 1;
                var val : Int = fit_value[i];
                if (val != 0) {
                    if (val >= room) {
                        if (hiroom > loroom) {
                            val = (val - loroom);
                        }
                        else {
                            val = (-1 - (val - hiroom));
                        };
                    }
                    else {
                        if ((val & 1) != 0) {
                            val = -((val + 1) >>> 1);
                        }
                        else {
                            val >>= 1;
                        };
                    };
                    fit_value[i] = (val + predicted);
                    fit_value[look.loneighbor[i - 2]] &= 0x7fff;
                    fit_value[look.hineighbor[i - 2]] &= 0x7fff;
                }
                else {
                    fit_value[i] = (predicted | 0x8000);
                };
                i++;
            };
            return fit_value;
        };
        return null;
    }

    // modifiers: static, private
    static private function render_point(x0 : Int, x1 : Int, y0 : Int, y1 : Int, x : Int) : Int {
        y0 &= 0x7fff;
        y1 &= 0x7fff;
        var dy : Int = y1 - y0;
        var adx : Int = x1 - x0;
        var ady : Int = System.abs(dy);
        var err : Int = ady * (x - x0);
        var off : Int = Std.int(err / adx);
        if (dy < 0) {
            return y0 - off;
        };
        return y0 + off;
    }

    // modifiers: 
    override function inverse2(vb : Block, i : Dynamic, memo : Dynamic, out : Vector<Float>) : Int {
        var look : LookFloor1 = i;
        var info : InfoFloor1 = look.vi;
        var n : Int = Std.int(vb.vd.vi.blocksizes[vb.mode] / 2);
        if (memo != null) {
            var fit_value : Vector<Int> = memo;
            var hx : Int = 0;
            var lx : Int = 0;
            var ly : Int = fit_value[0] * info.mult;
            // for-while;
            var j : Int = 1;
            while (j < look.posts) {
                var current : Int = look.forward_index[j];
                var hy : Int = fit_value[current] & 0x7fff;
                if (hy == fit_value[current]) {
                    hy *= info.mult;
                    hx = info.postlist[current];
                    render_line(lx, hx, ly, hy, out);
                    lx = hx;
                    ly = hy;
                };
                j++;
            };
            // for-while;
            var j : Int = hx;
            while (j < n) {
                out[j] *= out[j - 1];
                j++;
            };
            return 1;
        };
        // for-while;
        var j : Int = 0;
        while (j < n) {
            out[j] = 0.;
            j++;
        };
        return 0;
    }

    static private var FLOOR_fromdB_LOOKUP : Array<Float> = [1.0649863e-07, 1.1341951e-07, 1.2079015e-07, 1.2863978e-07, 1.3699951e-07, 1.4590251e-07, 1.5538408e-07, 1.6548181e-07, 1.7623575e-07, 1.8768855e-07, 1.9988561e-07, 2.128753e-07, 2.2670913e-07, 2.4144197e-07, 2.5713223e-07, 2.7384213e-07, 2.9163793e-07, 3.1059021e-07, 3.3077411e-07, 3.5226968e-07, 3.7516214e-07, 3.9954229e-07, 4.2550680e-07, 4.5315863e-07, 4.8260743e-07, 5.1396998e-07, 5.4737065e-07, 5.8294187e-07, 6.2082472e-07, 6.6116941e-07, 7.0413592e-07, 7.4989464e-07, 7.9862701e-07, 8.5052630e-07, 9.0579828e-07, 9.6466216e-07, 1.0273513e-06, 1.0941144e-06, 1.1652161e-06, 1.2409384e-06, 1.3215816e-06, 1.4074654e-06, 1.4989305e-06, 1.5963394e-06, 1.7000785e-06, 1.8105592e-06, 1.9282195e-06, 2.0535261e-06, 2.1869758e-06, 2.3290978e-06, 2.4804557e-06, 2.6416497e-06, 2.8133190e-06, 2.9961443e-06, 3.1908506e-06, 3.3982101e-06, 3.6190449e-06, 3.8542308e-06, 4.1047004e-06, 4.3714470e-06, 4.6555282e-06, 4.9580707e-06, 5.2802740e-06, 5.6234160e-06, 5.9888572e-06, 6.3780469e-06, 6.7925283e-06, 7.2339451e-06, 7.7040476e-06, 8.2047000e-06, 8.7378876e-06, 9.3057248e-06, 9.9104632e-06, 1.0554501e-05, 1.1240392e-05, 1.1970856e-05, 1.2748789e-05, 1.3577278e-05, 1.4459606e-05, 1.5399272e-05, 1.6400004e-05, 1.7465768e-05, 1.8600792e-05, 1.9809576e-05, 2.1096914e-05, 2.2467911e-05, 2.3928002e-05, 2.5482978e-05, 2.7139006e-05, 2.8902651e-05, 3.0780908e-05, 3.2781225e-05, 3.4911534e-05, 3.7180282e-05, 3.9596466e-05, 4.2169667e-05, 4.4910090e-05, 4.7828601e-05, 5.0936773e-05, 5.4246931e-05, 5.7772202e-05, 6.1526565e-05, 6.5524908e-05, 6.9783085e-05, 7.4317983e-05, 7.9147585e-05, 8.4291040e-05, 8.9768747e-05, 9.5602426e-05, 0.00010181521, 0.00010843174, 0.00011547824, 0.00012298267, 0.00013097477, 0.00013948625, 0.00014855085, 0.00015820453, 0.00016848555, 0.00017943469, 0.00019109536, 0.00020351382, 0.00021673929, 0.00023082423, 0.00024582449, 0.00026179955, 0.00027881276, 0.00029693158, 0.00031622787, 0.00033677814, 0.00035866388, 0.00038197188, 0.00040679456, 0.00043323036, 0.00046138411, 0.00049136745, 0.00052329927, 0.00055730621, 0.00059352311, 0.00063209358, 0.00067317058, 0.00071691700, 0.00076350630, 0.00081312324, 0.00086596457, 0.00092223983, 0.00098217216, 0.0010459992, 0.0011139742, 0.0011863665, 0.0012634633, 0.0013455702, 0.0014330129, 0.0015261382, 0.0016253153, 0.0017309374, 0.0018434235, 0.0019632195, 0.0020908006, 0.0022266726, 0.0023713743, 0.0025254795, 0.0026895994, 0.0028643847, 0.0030505286, 0.0032487691, 0.0034598925, 0.0036847358, 0.0039241906, 0.0041792066, 0.0044507950, 0.0047400328, 0.0050480668, 0.0053761186, 0.0057254891, 0.0060975636, 0.0064938176, 0.0069158225, 0.0073652516, 0.0078438871, 0.0083536271, 0.0088964928, 0.009474637, 0.010090352, 0.010746080, 0.011444421, 0.012188144, 0.012980198, 0.013823725, 0.014722068, 0.015678791, 0.016697687, 0.017782797, 0.018938423, 0.020169149, 0.021479854, 0.022875735, 0.024362330, 0.025945531, 0.027631618, 0.029427276, 0.031339626, 0.033376252, 0.035545228, 0.037855157, 0.040315199, 0.042935108, 0.045725273, 0.048696758, 0.051861348, 0.055231591, 0.058820850, 0.062643361, 0.066714279, 0.071049749, 0.075666962, 0.080584227, 0.085821044, 0.091398179, 0.097337747, 0.10366330, 0.11039993, 0.11757434, 0.12521498, 0.13335215, 0.14201813, 0.15124727, 0.16107617, 0.17154380, 0.18269168, 0.19456402, 0.20720788, 0.22067342, 0.23501402, 0.25028656, 0.26655159, 0.28387361, 0.30232132, 0.32196786, 0.34289114, 0.36517414, 0.38890521, 0.41417847, 0.44109412, 0.46975890, 0.50028648, 0.53279791, 0.56742212, 0.60429640, 0.64356699, 0.68538959, 0.72993007, 0.77736504, 0.82788260, 0.88168307, 0.9389798, 1.];

    // modifiers: static, private
    static private function render_line(x0 : Int, x1 : Int, y0 : Int, y1 : Int, d : Vector<Float>) : Void {
        var dy : Int = y1 - y0;
        var adx : Int = x1 - x0;
        var ady : Int = System.abs(dy);
        var base : Int = Std.int(dy / adx);
        var sy : Int = (dy < 0 ? base - 1 : base + 1);
        var x : Int = x0;
        var y : Int = y0;
        var err : Int = 0;
        ady -= System.abs(base * adx);
        d[x] *= FLOOR_fromdB_LOOKUP[y];
        while (++x < x1) {
            err = (err + ady);
            if (err >= adx) {
                err -= adx;
                y += sy;
            }
            else {
                y += base;
            };
            d[x] *= FLOOR_fromdB_LOOKUP[y];
        };
    }

    // modifiers: static
    static function ilog(v : Int) : Int {
        var ret : Int = 0;
        while (v != 0) {
            ret++;
            v >>>= 1;
        };
        return ret;
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
    }
}


class InfoFloor1 {
    /*
     * generated source for InfoFloor1
     */
    inline static var VIF_POSIT : Int = 63;
    inline static var VIF_CLASS : Int = 16;
    inline static var VIF_PARTS : Int = 31;
    public var partitions : Int;
    // discarded initializer: 'new int[VIF_PARTS]';
    public var partitionclass : Vector<Int>;
    // discarded initializer: 'new int[VIF_CLASS]';
    public var class_dim : Vector<Int>;
    // discarded initializer: 'new int[VIF_CLASS]';
    public var class_subs : Vector<Int>;
    // discarded initializer: 'new int[VIF_CLASS]';
    public var class_book : Vector<Int>;
    // discarded initializer: 'new int[VIF_CLASS]';
    public var class_subbook : Array<Vector<Int>>;
    public var mult : Int;
    // discarded initializer: 'new int[VIF_POSIT + 2]';
    public var postlist : Vector<Int>;
    var maxover : Float;
    var maxunder : Float;
    var maxerr : Float;
    var twofitminsize : Int;
    var twofitminused : Int;
    var twofitweight : Int;
    var twofitatten : Float;
    var unusedminsize : Int;
    var unusedmin_n : Int;
    var n : Int;

    // modifiers: 
    public function new() {
        partitionclass = new Vector(VIF_PARTS, true);
        class_dim = new Vector(VIF_CLASS, true);
        class_subs = new Vector(VIF_CLASS, true);
        class_book = new Vector(VIF_CLASS, true);
        class_subbook = new Array();
        postlist = new Vector(VIF_POSIT + 2, true);

        // for-while;
        var i : Int = 0;
        //while (i < class_subbook.length) {
        while (i < VIF_CLASS) {
            //class_subbook[i] = new int[8];
            class_subbook[i] = new Vector(8, true);
            i++;
        };
    }

    // modifiers: 
    public function free() : Void {
        partitionclass = null;
        class_dim = null;
        class_subs = null;
        class_book = null;
        class_subbook = null;
        postlist = null;
    }

    // modifiers: 
    function copy_info() : Dynamic {
        var info : InfoFloor1 = this;
        var ret : InfoFloor1 = new InfoFloor1();
        ret.partitions = info.partitions;
        // System.arraycopyV(info.partitionclass, 0, ret.partitionclass, 0, InfoFloor1.VIF_PARTS);
        // System.arraycopyV(info.class_dim, 0, ret.class_dim, 0, InfoFloor1.VIF_CLASS);
        // System.arraycopyV(info.class_subs, 0, ret.class_subs, 0, InfoFloor1.VIF_CLASS);
        // System.arraycopyV(info.class_book, 0, ret.class_book, 0, InfoFloor1.VIF_CLASS);

        ret.partitionclass = VectorTools.copyI(info.partitionclass, 0,
                                               ret.partitionclass, 0,
                                               VIF_PARTS);
        ret.class_dim = VectorTools.copyI(info.class_dim, 0,
                                          ret.class_dim, 0,
                                          VIF_CLASS);
        ret.class_subs = VectorTools.copyI(info.class_subs, 0,
                                           ret.class_subs, 0,
                                           VIF_CLASS);
        ret.class_book = VectorTools.copyI(info.class_book, 0,
                                           ret.class_book, 0,
                                           VIF_CLASS);

        // for-while;
        var j : Int = 0;
        while (j < VIF_CLASS) {
            //System.arraycopyV(info.class_subbook[j], 0, ret.class_subbook[j], 0, 8);
            ret.class_subbook[j] = VectorTools.copyI(info.class_subbook[j], 0,
                                                     ret.class_subbook[j], 0,
                                                     8);
            j++;
        };
        ret.mult = info.mult;
        //System.arraycopyV(info.postlist, 0, ret.postlist, 0, InfoFloor1.VIF_POSIT + 2);
        ret.postlist = VectorTools.copyI(info.postlist, 0, ret.postlist, 0,
                                         VIF_POSIT + 2);
        ret.maxover = info.maxover;
        ret.maxunder = info.maxunder;
        ret.maxerr = info.maxerr;
        ret.twofitminsize = info.twofitminsize;
        ret.twofitminused = info.twofitminused;
        ret.twofitweight = info.twofitweight;
        ret.twofitatten = info.twofitatten;
        ret.unusedminsize = info.unusedminsize;
        ret.unusedmin_n = info.unusedmin_n;
        ret.n = info.n;
        return ret;
    }

}
class LookFloor1 {
    /*
     * generated source for LookFloor1
     */
    inline static var VIF_POSIT : Int = 63;
    // discarded initializer: 'new int[VIF_POSIT + 2]';
    public var sorted_index : Vector<Int>;
    // discarded initializer: 'new int[VIF_POSIT + 2]';
    public var forward_index : Vector<Int>;
    // discarded initializer: 'new int[VIF_POSIT + 2]';
    public var reverse_index : Vector<Int>;
    // discarded initializer: 'new int[VIF_POSIT]';
    public var hineighbor : Vector<Int>;
    // discarded initializer: 'new int[VIF_POSIT]';
    public var loneighbor : Vector<Int>;
    public var posts : Int;
    public var n : Int;
    public var quant_q : Int;
    public var vi : InfoFloor1;
    public var phrasebits : Int;
    public var postbits : Int;
    public var frames : Int;

    public function new() {
        sorted_index = new Vector(VIF_POSIT + 2, true);
        forward_index = new Vector(VIF_POSIT + 2, true);
        reverse_index = new Vector(VIF_POSIT + 2, true);
        hineighbor = new Vector(VIF_POSIT, true);
        loneighbor = new Vector(VIF_POSIT, true);
    }

    // modifiers: 
    function free() : Void {
        sorted_index = null;
        forward_index = null;
        reverse_index = null;
        hineighbor = null;
        loneighbor = null;
    }

}
class Lsfit_acc {
    /*
     * generated source for Lsfit_acc
     */
    var x0 : Int;
    var x1 : Int;
    var xa : Int;
    var ya : Int;
    var x2a : Int;
    var y2a : Int;
    var xya : Int;
    var n : Int;
    var an : Int;
    var un : Int;
    var edgey0 : Int;
    var edgey1 : Int;
}
class EchstateFloor1 {
    /*
     * generated source for EchstateFloor1
     */
    var codewords : Vector<Int>;
    var curve : Vector<Float>;
    var frameno : Int;
    var codes : Int;
}

