package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class CodeBook {
    /*
     * generated source for CodeBook
     */
    public var dim : Int;
    var entries : Int;
    // discarded initializer: 'StaticCodeBook()';
    var c : StaticCodeBook;
    var valuelist : Vector<Float>;
    var codelist : Vector<Int>;
    var decode_tree : DecodeAux;

    // modifiers: 
    function encode(a : Int, b : Buffer) : Int {
        b.write(codelist[a], c.lengthlist[a]);
        return c.lengthlist[a];
    }

    // modifiers: 
    function errorv(a : Vector<Float>) : Int {
        var best : Int = best(a, 1);
        // for-while;
        var k : Int = 0;
        while (k < dim) {
            a[k] = valuelist[(best * dim) + k];
            k++;
        };
        return best;
    }

    // modifiers: 
    function encodev(best : Int, a : Vector<Float>, b : Buffer) : Int {
        // for-while;
        var k : Int = 0;
        while (k < dim) {
            a[k] = valuelist[(best * dim) + k];
            k++;
        };
        return encode(best, b);
    }

    // modifiers: 
    function encodevs(a : Vector<Float>, b : Buffer, step : Int, addmul : Int) : Int {
        var best : Int = besterror(a, step, addmul);
        return encode(best, b);
    }

    // discarded initializer: 'new int[15]';
    private var t : Vector<Int>;

    // modifiers: synchronized
    public function decodevs_add(a : Vector<Float>, offset : Int, b : Buffer, n : Int) : Int {
        var step : Int = Std.int(n / dim);
        var entry : Int;
        var i : Int;
        var j : Int;
        var o : Int;
        if (t.length < step) {
            //t = new int[step];
            t = new Vector(step);
        };
        // for-while;
        i = 0;
        while (i < step) {
            entry = decode(b);
            if (entry == -1) {
                return -1;
            };
            t[i] = (entry * dim);
            i++;
        };
        // for-while;
        i = 0;
        o = 0;
        while (i < dim) {
            // for-while;
            j = 0;
            while (j < step) {
                a[(offset + o) + j] += valuelist[t[j] + i];
                j++;
            };
            i++; o += step;
        };
        return 0;
    }

    // modifiers: 
    public function decodev_add(a : Vector<Float>, offset : Int, b : Buffer, n : Int) : Int {
        var i : Int;
        var j : Int;
        var entry : Int;
        var t : Int;
        if (dim > 8) {
            // for-while;
            i = 0;
            while (i < n) {
                entry = decode(b);
                if (entry == -1) {
                    return -1;
                };
                t = (entry * dim);
                // for-while;
                j = 0;
                while (j < dim) {
                    // HAXE200BUG
                    // a[offset + i++] += valuelist[t + j++];
                    a[offset + i] += valuelist[t + j];
                    i++; j++;
                };
            };
        }
        else {
            // for-while;
            i = 0;
            while (i < n) {
                entry = decode(b);
                if (entry == -1) {
                    return -1;
                };
                t = (entry * dim);
                j = 0;

                {
                    // FIXME: why isn't this a loop, but some voodoo
                    // sideeffects-and-oh-wait-a-switch?!
                    var fall : Bool = false;
                    if (dim == 8) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                        fall = true;
                    };
                    if (fall || dim == 7) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                        fall = true;
                    };
                    if (fall || dim == 6) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                        fall = true;
                    };
                    if (fall || dim == 5) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                        fall = true;
                    };
                    if (fall || dim == 4) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                        fall = true;
                    };
                    if (fall || dim == 3) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                        fall = true;
                    };
                    if (fall || dim == 2) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                        fall = true;
                    };
                    if (fall || dim == 1) {
                        // HAXE200BUG
                        // a[offset + i++] += valuelist[t + j++];
                        a[offset + i] += valuelist[t + j];
                        i++; j++;
                    };
                    /*
                    if dim == 0 {
                    };
                    */
                };
            };
        };
        return 0;
    }

    // modifiers: 
    public function decodev_set(a : Vector<Float>, offset : Int, b : Buffer, n : Int) : Int {
        var i : Int;
        var j : Int;
        var entry : Int;
        var t : Int;
        // for-while;
        i = 0;
        while (i < n) {
            entry = decode(b);
            if (entry == -1) {
                return -1;
            };
            t = (entry * dim);
            // for-while;
            j = 0;
            while (j < dim) {
                a[offset + i++] = valuelist[t + j++];
            };
        };
        return 0;
    }

    // modifiers: 
    public function decodevv_add(a : Array<Vector<Float>>, offset : Int, ch : Int, b : Buffer, n : Int) : Int {
        var i : Int;
        var j : Int;
        var k : Int;
        var entry : Int;
        var chptr : Int = 0;
        // for-while;
        i = Std.int(offset / ch);
        while (i < ((offset + n) / ch)) {
            entry = decode(b);
            if (entry == -1) {
                return -1;
            };
            var t : Int = entry * dim;
            // for-while;
            j = 0;
            while (j < dim) {
                // HAXE200BUG
                // haXe 2.00 has a bug causing the following code line
                // to increment chptr twice (because of the "+=" operator?):
                //   a[chptr++][i] += valuelist[t + j];
                a[chptr][i] += valuelist[t + j];
                chptr++;
                if (chptr == ch) {
                    chptr = 0;
                    i++;
                };
                j++;
            };
        };
        return 0;
    }

    // modifiers: 
    public function decode(b : Buffer) : Int {
        var ptr : Int = 0;
        var t : DecodeAux = decode_tree;
        var lok : Int = b.look(t.tabn);
        if (lok >= 0) {
            ptr = t.tab[lok];
            b.adv(t.tabl[lok]);
            if (ptr <= 0) {
                return -ptr;
            };
        };
        do {
            {
                var swval = b.read1();
                if (swval == 0) {
                    ptr = t.ptr0[ptr];
                } else if (swval == 1) {
                    ptr = t.ptr1[ptr];
                } else {
                    return -1;
                };
            };
        } while (ptr > 0);

        return -ptr;
    }

    // modifiers: 
    public function decodevs(a : Vector<Float>, index : Int, b : Buffer, step : Int, addmul : Int) : Int {
        var entry : Int = decode(b);
        if (entry == -1) {
            return -1;
        };

        switch (addmul) {
        case -1:
            // for-while;
            var i : Int = 0;
            var o : Int = 0;
            while (i < dim) {
                a[index + o] = valuelist[(entry * dim) + i];
                i++; o += step;
            };

        case 0:
            // for-while;
            var i : Int = 0;
            var o : Int = 0;
            while (i < dim) {
                a[index + o] += valuelist[(entry * dim) + i];
                i++; o += step;
            };

        case 1:
            // for-while;
            var i : Int = 0;
            var o : Int = 0;
            while (i < dim) {
                a[index + o] *= valuelist[(entry * dim) + i];
                i++; o += step;
            };

        default:
            trace("CodeBook.decodeves: addmul=" + addmul);
        };

        return entry;
    }

    // modifiers: 
    function best(a : Vector<Float>, step : Int) : Int {
        var nt : EncodeAuxNearestMatch = c.nearest_tree;
        var tt : EncodeAuxThreshMatch = c.thresh_tree;
        var ptr : Int = 0;
        if (tt != null) {
            var index : Int = 0;
            // for-while;
            var k : Int = 0;
            var o : Int = step * (dim - 1);
            while (k < dim) {
                var i : Int;
                // for-while;
                i = 0;
                while (i < (tt.threshvals - 1)) {
                    if (a[o] < tt.quantthresh[i]) {
                        break;
                    };
                    i++;
                };
                index = ((index * tt.quantvals) + tt.quantmap[i]);
                k++; o -= step;
            };
            if (c.lengthlist[index] > 0) {
                return index;
            };
        };
        if (nt != null) {
            while (true) {
                var c : Float = 0.;
                var p : Int = nt.p[ptr];
                var q : Int = nt.q[ptr];
                // for-while;
                var k : Int = 0;
                var o : Int = 0;
                while (k < dim) {
                    c += ((valuelist[p + k] - valuelist[q + k]) * (a[o] - ((valuelist[p + k] + valuelist[q + k]) * 0.5)));
                    k++; o += step;
                };
                if (c > 0.) {
                    ptr = -nt.ptr0[ptr];
                }
                else {
                    ptr = -nt.ptr1[ptr];
                };
                if (ptr <= 0) {
                    break;
                };
            };
            return -ptr;
        };
        var besti : Int = -1;
        var best : Float = 0.;
        var e : Int = 0;
        // for-while;
        var i : Int = 0;
        while (i < entries) {
            if (c.lengthlist[i] > 0) {
                var _this : Float = CodeBook.dist(dim, valuelist, e, a, step);
                if ((besti == -1) || (_this < best)) {
                    best = _this;
                    besti = i;
                };
            };
            e += dim;
            i++;
        };
        return besti;
    }

    // modifiers: 
    function besterror(a : Vector<Float>, step : Int, addmul : Int) : Int {
        var best : Int = best(a, step);
        switch (addmul) {
        case 0:
            // for-while;
            var i : Int = 0;
            var o : Int = 0;
            while (i < dim) {
                a[o] -= valuelist[(best * dim) + i];
                i++; o += step;
            };

        case 1:
            // for-while;
            var i : Int = 0;
            var o : Int = 0;
            while (i < dim) {
                var val : Float = valuelist[(best * dim) + i];
                if (val == 0) {
                    a[o] = 0;
                }
                else {
                    a[o] /= val;
                };
                i++; o += step;
            };
        };
        return best;
    }

    // modifiers: 
    function clear() : Void {
    }

    // modifiers: static, private
    static private function dist(el : Int, ref : Vector<Float>, index : Int, b : Vector<Float>, step : Int) : Float {
        var acc : Float = 0.;
        // for-while;
        var i : Int = 0;
        while (i < el) {
            var val : Float = ref[index + i] - b[i * step];
            acc += (val * val);
            i++;
        };
        return acc;
    }

    // modifiers: 
    public function init_decode(s : StaticCodeBook) : Int {
        c = s;
        entries = s.entries;
        dim = s.dim;
        valuelist = s.unquantize();
        decode_tree = make_decode_tree();
        if (decode_tree == null) {
            clear();
            return -1;
        };
        return 0;
    }

    // modifiers: static
    static function make_words(l : Vector<Int>, n : Int) : Vector<Int> {
        //var marker : Vector<Int> = new int[33];
        var marker : Vector<Int> = new Vector(33, true);
        //var r : Vector<Int> = new int[n];
        var r : Vector<Int> = new Vector(n, true);

        // for-while;
        var i : Int = 0;
        while (i < n) {
            var length : Int = l[i];
            if (length > 0) {
                var entry : Int = marker[length];
                if ((length < 32) && ((entry >>> length) != 0)) {
                    return null;
                };
                r[i] = entry;
                // for-while;
                var j : Int = length;
                while (j > 0) {
                    if ((marker[j] & 1) != 0) {
                        if (j == 1) {
                            marker[1]++;
                        }
                        else {
                            marker[j] = (marker[j - 1] << 1);
                        };
                        break;
                    };
                    marker[j]++;
                    j--;
                };
                // for-while;
                var j : Int = length + 1;
                while (j < 33) {
                    if ((marker[j] >>> 1) == entry) {
                        entry = marker[j];
                        marker[j] = (marker[j - 1] << 1);
                    }
                    else {
                        break;
                    };
                    j++;
                };
            };
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < n) {
            var temp : Int = 0;
            // for-while;
            var j : Int = 0;
            while (j < l[i]) {
                temp <<= 1;
                temp |= ((r[i] >>> j) & 1);
                j++;
            };
            r[i] = temp;
            i++;
        };
        return r;
    }

    // modifiers: 
    function make_decode_tree() : DecodeAux {
        var top : Int = 0;
        var t : DecodeAux = new DecodeAux();
        //var ptr0 : Vector<Int> = t.ptr0 = new int[entries * 2];
        var ptr0 : Vector<Int> = t.ptr0 = new Vector(entries * 2, true);
        //var ptr1 : Vector<Int> = t.ptr1 = new int[entries * 2];
        var ptr1 : Vector<Int> = t.ptr1 = new Vector(entries * 2, true);
        var codelist : Vector<Int> = make_words(c.lengthlist, c.entries);
        if (codelist == null) {
            return null;
        };
        t.aux = (entries * 2);
        // for-while;
        var i : Int = 0;
        while (i < entries) {
            if (c.lengthlist[i] > 0) {
                var ptr : Int = 0;
                var j : Int;
                // for-while;
                j = 0;
                while (j < (c.lengthlist[i] - 1)) {
                    var bit : Int = (codelist[i] >>> j) & 1;
                    if (bit == 0) {
                        if (ptr0[ptr] == 0) {
                            ptr0[ptr] = ++top;
                        };
                        ptr = ptr0[ptr];
                    }
                    else {
                        if (ptr1[ptr] == 0) {
                            ptr1[ptr] = ++top;
                        };
                        ptr = ptr1[ptr];
                    };
                    j++;
                };
                if (((codelist[i] >>> j) & 1) == 0) {
                    ptr0[ptr] = -i;
                }
                else {
                    ptr1[ptr] = -i;
                };
            };
            i++;
        };
        t.tabn = (ilog(entries) - 4);
        if (t.tabn < 5) {
            t.tabn = 5;
        };
        var n : Int = 1 << t.tabn;
        //t.tab = new int[n];
        t.tab = new Vector(n, true);
        //t.tabl = new int[n];
        t.tabl = new Vector(n, true);

        // for-while;
        var i : Int = 0;
        while (i < n) {
            var p : Int = 0;
            var j : Int = 0;
            // for-while;
            j = 0;
            while ((j < t.tabn) && ((p > 0) || (j == 0))) {
                if ((i & (1 << j)) != 0) {
                    p = ptr1[p];
                }
                else {
                    p = ptr0[p];
                };
                j++;
            };
            t.tab[i] = p;
            t.tabl[i] = j;
            i++;
        };
        return t;
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

    public function new() {
        // discarded initializer: 'StaticCodeBook()';
        c = new StaticCodeBook();
        // discarded initializer: 'new int[15]';
        t = new Vector(15, true);
    }

}

class DecodeAux {
    /*
     * generated source for DecodeAux
     */
    public var tab : Vector<Int>;
    public var tabl : Vector<Int>;
    public var tabn : Int;
    public var ptr0 : Vector<Int>;
    public var ptr1 : Vector<Int>;
    public var aux : Int;

    public function new() {
    }
}
