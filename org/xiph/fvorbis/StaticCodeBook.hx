package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;

class StaticCodeBook {
    /*
     * generated source for StaticCodeBook
     */
    public var dim : Int;
    public var entries : Int;
    public var lengthlist : Vector<Int>;
    var maptype : Int;
    var q_min : Int;
    var q_delta : Int;
    var q_quant : Int;
    var q_sequencep : Int;
    var quantlist : Vector<Int>;
    public var nearest_tree : EncodeAuxNearestMatch;
    public var thresh_tree : EncodeAuxThreshMatch;

    // modifiers: 
    public function new() {
    }

    // modifiers: 
    public function newWA(dim : Int, entries : Int, lengthlist : Vector<Int>, maptype : Int, q_min : Int, q_delta : Int, q_quant : Int, q_sequencep : Int, quantlist : Vector<Int>, nearest_tree : Dynamic, thresh_tree : Dynamic) {
        //this.new();
        this.dim = dim;
        this.entries = entries;
        this.lengthlist = lengthlist;
        this.maptype = maptype;
        this.q_min = q_min;
        this.q_delta = q_delta;
        this.q_quant = q_quant;
        this.q_sequencep = q_sequencep;
        this.quantlist = quantlist;
    }

    // modifiers: 
    public function pack(opb : Buffer) : Int {
        var i : Int;
        var ordered : Bool = false;
        opb.write(0x564342, 24);
        opb.write(dim, 16);
        opb.write(entries, 24);
        // for-while;
        i = 1;
        while (i < entries) {
            if (lengthlist[i] < lengthlist[i - 1]) {
                break;
            };
            i++;
        };
        if (i == entries) {
            ordered = true;
        };
        if (ordered) {
            var count : Int = 0;
            opb.write(1, 1);
            opb.write(lengthlist[0] - 1, 5);
            // for-while;
            i = 1;
            while (i < entries) {
                var _this : Int = lengthlist[i];
                var _last : Int = lengthlist[i - 1];
                if (_this > _last) {
                    // for-while;
                    var j : Int = _last;
                    while (j < _this) {
                        opb.write(i - count, StaticCodeBook.ilog(entries - count));
                        count = i;
                        j++;
                    };
                };
                i++;
            };
            opb.write(i - count, StaticCodeBook.ilog(entries - count));
        }
        else {
            opb.write(0, 1);
            // for-while;
            i = 0;
            while (i < entries) {
                if (lengthlist[i] == 0) {
                    break;
                };
                i++;
            };
            if (i == entries) {
                opb.write(0, 1);
                // for-while;
                i = 0;
                while (i < entries) {
                    opb.write(lengthlist[i] - 1, 5);
                    i++;
                };
            }
            else {
                opb.write(1, 1);
                // for-while;
                i = 0;
                while (i < entries) {
                    if (lengthlist[i] == 0) {
                        opb.write(0, 1);
                    }
                    else {
                        opb.write(1, 1);
                        opb.write(lengthlist[i] - 1, 5);
                    };
                    i++;
                };
            };
        };
        opb.write(maptype, 4);
        while (true) {
            if (maptype == 0) {
                break;
            } else if (maptype == 1 || maptype == 2) {
                if (quantlist == null) {
                    return -1;
                };
                opb.write(q_min, 32);
                opb.write(q_delta, 32);
                opb.write(q_quant - 1, 4);
                opb.write(q_sequencep, 1);

                {
                    var quantvals : Int = 0;
                    switch (maptype) {
                    case 1:
                        quantvals = maptype1_quantvals();
                        break;

                    case 2:
                        quantvals = (entries * dim);
                        break;
                    };
                    // for-while;
                    i = 0;
                    while (i < quantvals) {
                        opb.write(System.abs(quantlist[i]), q_quant);
                        i++;
                    };
                };
                break;
            };

            return -1;
        };
        return 0;
    }

    // modifiers: 
    public function unpack(opb : Buffer) : Int {
        var i : Int;
        if (opb.read(24) != 0x564342) {
            clear();
            return -1;
        };
        dim = opb.read(16);
        entries = opb.read(24);
        if (entries == -1) {
            clear();
            return -1;
        };

        switch (opb.read(1)) {
        case 0:
            //lengthlist = new int[entries];
            lengthlist = new Vector(entries, true);
            if (opb.read(1) != 0) {
                // for-while;
                i = 0;
                while (i < entries) {
                    if (opb.read(1) != 0) {
                        var num : Int = opb.read(5);
                        if (num == -1) {
                            clear();
                            return -1;
                        };
                        lengthlist[i] = (num + 1);
                    }
                    else {
                        lengthlist[i] = 0;
                    };
                    i++;
                };
            }
            else {
                // for-while;
                i = 0;
                while (i < entries) {
                    var num : Int = opb.read(5);
                    if (num == -1) {
                        clear();
                        return -1;
                    };
                    lengthlist[i] = (num + 1);
                    i++;
                };
            };

        case 1:
            var length : Int = opb.read(5) + 1;
            //lengthlist = new int[entries];
            lengthlist = new Vector(entries, true);

            // for-while;
            i = 0;
            while (i < entries) {
                var num : Int = opb.read(StaticCodeBook.ilog(entries - i));
                if (num == -1) {
                    clear();
                    return -1;
                };
                // for-while;
                var j : Int = 0;
                while (j < num) {
                    lengthlist[i] = length;
                    j++; i++;
                };
                length++;
            };

        default:
            return -1;
        };

        {
            var swval = maptype = opb.read(4);
            if (swval == 0) {
            } else if (swval == 1 || swval == 2) {
                q_min = opb.read(32);
                q_delta = opb.read(32);
                q_quant = (opb.read(4) + 1);
                q_sequencep = opb.read(1);

                {
                    var quantvals : Int = 0;
                    switch (maptype) {
                    case 1:
                        quantvals = maptype1_quantvals();
                    case 2:
                        quantvals = (entries * dim);
                    };

                    //quantlist = new int[quantvals];
                    quantlist = new Vector(quantvals, true);

                    // for-while;
                    i = 0;
                    while (i < quantvals) {
                        quantlist[i] = opb.read(q_quant);
                        i++;
                    };
                    if (quantlist[quantvals - 1] == -1) {
                        clear();
                        return -1;
                    };
                };
            } else {
                clear();
                return -1;
            }
        };
        return 0;
    }

    // modifiers: private
    private function maptype1_quantvals() : Int {
        var vals : Int = Math.floor(Math.pow(entries, 1. / dim));
        while (true) {
            var acc : Int = 1;
            var acc1 : Int = 1;
            // for-while;
            var i : Int = 0;
            while (i < dim) {
                acc *= vals;
                acc1 *= (vals + 1);
                i++;
            };
            if ((acc <= entries) && (acc1 > entries)) {
                return vals;
            }
            else {
                if (acc > entries) {
                    vals--;
                }
                else {
                    vals++;
                };
            };
        };
        throw "NoValueToReturn";
    }

    // modifiers: 
    public function clear() : Void {
    }

    // modifiers: 
    public function unquantize() : Vector<Float> {
        if ((maptype == 1) || (maptype == 2)) {
            var quantvals : Int;
            var mindel : Float = StaticCodeBook.float32_unpack(q_min);
            var delta : Float = StaticCodeBook.float32_unpack(q_delta);
            //var r : Vector<Float> = new float[entries * dim];
            var r : Vector<Float> = new Vector(entries * dim, true);

            switch (maptype) {
            case 1:
                quantvals = maptype1_quantvals();

                // for-while;
                var j : Int = 0;
                while (j < entries) {
                    var last : Float = 0.;
                    var indexdiv : Int = 1;

                    // for-while;
                    var k : Int = 0;
                    while (k < dim) {
                        var index : Int = Std.int(j / indexdiv) % quantvals;
                        var val : Float = quantlist[index];
                        val = (((Math.abs(val) * delta) + mindel) + last);
                        if (q_sequencep != 0) {
                            last = val;
                        };
                        r[(j * dim) + k] = val;
                        indexdiv *= quantvals;
                        k++;
                    };
                    j++;
                };
            case 2:
                // for-while;
                var j : Int = 0;
                while (j < entries) {
                    var last : Float = 0.;
                    // for-while;
                    var k : Int = 0;
                    while (k < dim) {
                        var val : Float = quantlist[(j * dim) + k];
                        val = (((Math.abs(val) * delta) + mindel) + last);
                        if (q_sequencep != 0) {
                            last = val;
                        };
                        r[(j * dim) + k] = val;
                        k++;
                    };
                    j++;
                };
            };
            return r;
        };
        return null;
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

    inline static var VQ_FEXP : Int = 10;
    inline static var VQ_FMAN : Int = 21;
    inline static var VQ_FEXP_BIAS : Int = 768;

    // modifiers: static
    static function float32_pack(val : Float) : Int {
        var sign : Int = 0;
        var exp : Int;
        var mant : Int;
        if (val < 0) {
            sign = 0x80000000;
            val = -val;
        };
        exp = Math.floor(Math.log(val) / Math.log(2));
        mant = Math.round(Math.pow(val, (StaticCodeBook.VQ_FMAN - 1) - exp));
        exp = ((exp + StaticCodeBook.VQ_FEXP_BIAS) << StaticCodeBook.VQ_FMAN);
        return (sign | exp) | mant;
    }

    // modifiers: static
    static function float32_unpack(val : Int) : Float {
        var mant : Float = val & 0x1fffff;
        var sign : Float = val & 0x80000000;
        var exp : Float = (val & 0x7fe00000) >>> StaticCodeBook.VQ_FMAN;
        if ((val & 0x80000000) != 0) {
            mant = -mant;
        };
        return StaticCodeBook.ldexp(mant, (Std.int(exp) -
                                           (StaticCodeBook.VQ_FMAN - 1)) -
                                    StaticCodeBook.VQ_FEXP_BIAS);
    }

    // modifiers: static
    static function ldexp(foo : Float, e : Int) : Float {
        return foo * Math.pow(2, e);
    }

    /*
    // modifiers: inline
    inline function new() {
        // FIXME: implement disambiguation handler;
        //   __new_0();
        //   __new_1(dim : Int, entries : Int, lengthlist : Vector<Int>, maptype : Int, q_min : Int, q_delta : Int, q_quant : Int, q_sequencep : Int, quantlist : Vector<Int>, nearest_tree : Dynamic, thresh_tree : Dynamic);
        throw "NotImplementedError";
    }
    */

}

