package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class DspState {
    /*
     * generated source for DspState
     */
    inline static var M_PI : Float = 3.1415926539;
    inline static var VI_TRANSFORMB : Int = 1;
    inline static var VI_WINDOWB : Int = 1;
    public var analysisp : Int;
    public var vi : Info;
    public var modebits : Int;
    var pcm : Array<Vector<Float>>;
    var pcm_storage : Int;
    var pcm_current : Int;
    var pcm_returned : Int;
    var multipliers : Vector<Float>;
    var envelope_storage : Int;
    var envelope_current : Int;
    var eofflag : Int;
    public var lW : Int;
    var W : Int;
    public var nW : Int;
    var centerW : Int;
    var granulepos : Int;
    var sequence : Int;
    var glue_bits : Int;
    var time_bits : Int;
    var floor_bits : Int;
    var res_bits : Int;
    public var window : Array<Array<Array<Array<Vector<Float>>>>>;
    public var transform : Array<Array<Dynamic>>;
    public var fullbooks : Array<CodeBook>;
    public var mode : Array<Dynamic>;
    var header : Bytes;
    var header1 : Bytes;
    var header2 : Bytes;

    // modifiers: public
    public function __new_0() : Void {
        transform = new Array();
        window = new Array();
        window[0] = new Array();
        window[0][0] = new Array();
        window[0][1] = new Array();
        window[0][0][0] = new Array();
        window[0][0][1] = new Array();
        window[0][1][0] = new Array();
        window[0][1][1] = new Array();
        window[1] = new Array();
        window[1][0] = new Array();
        window[1][1] = new Array();
        window[1][0][0] = new Array();
        window[1][0][1] = new Array();
        window[1][1][0] = new Array();
        window[1][1][1] = new Array();
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

    // modifiers: static
    static function window_(type : Int, window : Int, left : Int, right : Int) : Vector<Float> {
        // FIXME: shadows variable 'window';
        //var ret : Array<Float> = new float[window];
        var ret : Vector<Float> = new Vector(window, true);
        if (type == 0) {
            var leftbegin : Int = Std.int(window / 4) - Std.int(left / 2);
            var rightbegin : Int = (window - Std.int(window / 4)) - Std.int(right / 2);

            // for-while;
            var i : Int = 0;
            while (i < left) {
                var x : Float = (((i + 0.5) / left) * DspState.M_PI) / 2.;
                x = Math.sin(x);
                x *= x;
                x *= (DspState.M_PI / 2.);
                x = Math.sin(x);
                ret[i + leftbegin] = x;
                i++;
            };

            // for-while;
            var i : Int = leftbegin + left;
            while (i < rightbegin) {
                ret[i] = 1.;
                i++;
            };

            // for-while;
            var i : Int = 0;
            while (i < right) {
                var x : Float = ((((right - i) - 0.5) / right) * DspState.M_PI) / 2.;
                x = Math.sin(x);
                x *= x;
                x *= (DspState.M_PI / 2.);
                x = Math.sin(x);
                ret[i + rightbegin] = x;
                i++;
            };
        } else {
            return null;
        };

        return ret;
    }

    // modifiers: 
    function init(vi : Info, encp : Bool) : Int {
        this.vi = vi;
        modebits = DspState.ilog2(vi.modes);
        //transform[0] = new Object[DspState.VI_TRANSFORMB];
        //transform[0] = new Vector(DspState.VI_TRANSFORMB, true);
        transform[0] = ArrayTools.alloc(DspState.VI_TRANSFORMB);
        //transform[1] = new Object[DspState.VI_TRANSFORMB];
        //transform[1] = new Vector(DspState.VI_TRANSFORMB, true);
        transform[1] = ArrayTools.alloc(DspState.VI_TRANSFORMB);
        transform[0][0] = new Mdct();
        transform[1][0] = new Mdct();
        transform[0][0].init(vi.blocksizes[0]);
        transform[1][0].init(vi.blocksizes[1]);
        //DspState.window[0][0][0] = new float[DspState.VI_WINDOWB];
        window[0][0][0] = new Array();
        window[0][0][1] = window[0][0][0];
        window[0][1][0] = window[0][0][0];
        window[0][1][1] = window[0][0][0];
        //DspState.window[1][0][0] = new float[DspState.VI_WINDOWB];
        window[1][0][0] = new Array();
        //DspState.window[1][0][1] = new float[DspState.VI_WINDOWB];
        window[1][0][1] = new Array();
        //DspState.window[1][1][0] = new float[DspState.VI_WINDOWB];
        window[1][1][0] = new Array();
        //DspState.window[1][1][1] = new float[DspState.VI_WINDOWB];
        window[1][1][1] = new Array();

        // for-while;
        var i : Int = 0;
        while (i < DspState.VI_WINDOWB) {
            window[0][0][0][i] = DspState.window_(i, vi.blocksizes[0], Std.int(vi.blocksizes[0] / 2), Std.int(vi.blocksizes[0] / 2));
            window[1][0][0][i] = DspState.window_(i, vi.blocksizes[1], Std.int(vi.blocksizes[0] / 2), Std.int(vi.blocksizes[0] / 2));
            window[1][0][1][i] = DspState.window_(i, vi.blocksizes[1], Std.int(vi.blocksizes[0] / 2), Std.int(vi.blocksizes[1] / 2));
            window[1][1][0][i] = DspState.window_(i, vi.blocksizes[1], Std.int(vi.blocksizes[1] / 2), Std.int(vi.blocksizes[0] / 2));
            window[1][1][1][i] = DspState.window_(i, vi.blocksizes[1], Std.int(vi.blocksizes[1] / 2), Std.int(vi.blocksizes[1] / 2));
            i++;
        };

        //fullbooks = new CodeBook[vi.books];
        //fullbooks = new Vector(vi.books, true);
        fullbooks = ArrayTools.alloc(vi.books);

        // for-while;
        var i : Int = 0;
        while (i < vi.books) {
            fullbooks[i] = new CodeBook();
            fullbooks[i].init_decode(vi.book_param[i]);
            i++;
        };
        pcm_storage = 8192;
        //pcm = new float[vi.channels];
        //pcm = new Array();
        pcm = ArrayTools.alloc(vi.channels);

        // for-while;
        var i : Int = 0;
        while (i < vi.channels) {
            //pcm[i] = new Vector(pcm_storage, true);
            pcm[i] = new Vector(pcm_storage, false);
            i++;
        };
        lW = 0;
        W = 0;
        centerW = Std.int(vi.blocksizes[1] / 2);
        pcm_current = centerW;
        //mode = new Object[vi.modes];
        //mode = new Vector(vi.modes, true);
        mode = ArrayTools.alloc(vi.modes);

        // for-while;
        var i : Int = 0;
        while (i < vi.modes) {
            var mapnum : Int = vi.mode_param[i].mapping;
            var maptype : Int = vi.map_type[mapnum];
            mode[i] = FuncMapping.mapping_P[maptype].look(this, vi.mode_param[i], vi.map_param[mapnum]);
            i++;
        };
        return 0;
    }

    // modifiers: public
    public function synthesis_init(vi : Info) : Int {
        init(vi, false);
        pcm_returned = centerW;
        centerW -= Std.int(vi.blocksizes[W] / 4) + Std.int(vi.blocksizes[lW] / 4);
        granulepos = -1;
        sequence = -1;
        return 0;
    }

    // modifiers: 
    function __new_1(vi : Info) {
        __new_0();
        init(vi, false);
        pcm_returned = centerW;
        centerW -= Std.int(vi.blocksizes[W] / 4) + Std.int(vi.blocksizes[lW] / 4);
        granulepos = -1;
        sequence = -1;
    }

    // modifiers: public
    public function synthesis_blockin(vb : Block) : Int {
        if ((centerW > (vi.blocksizes[1] / 2)) && (pcm_returned > 8192)) {
            var shiftPCM : Int = centerW - Std.int(vi.blocksizes[1] / 2);
            shiftPCM = ((pcm_returned < shiftPCM ? pcm_returned : shiftPCM));
            pcm_current -= shiftPCM;
            centerW -= shiftPCM;
            pcm_returned -= shiftPCM;
            if (shiftPCM != 0) {
                // for-while;
                var i : Int = 0;
                while (i < vi.channels) {
                    //System.arraycopyVF(pcm[i], shiftPCM, pcm[i], 0, pcm_current);
                    pcm[i] = VectorTools.copyF(pcm[i], shiftPCM, pcm[i], 0,
                                               pcm_current);
                    i++;
                };
            };
        };
        lW = W;
        W = vb.W;
        nW = -1;
        glue_bits += vb.glue_bits;
        time_bits += vb.time_bits;
        floor_bits += vb.floor_bits;
        res_bits += vb.res_bits;
        if ((sequence + 1) != vb.sequence) {
            granulepos = -1;
        };
        sequence = vb.sequence;
        var sizeW : Int = vi.blocksizes[W];
        var _centerW : Int = centerW + Std.int(vi.blocksizes[lW] / 4) + Std.int(sizeW / 4);
        var beginW : Int = _centerW - Std.int(sizeW / 2);
        var endW : Int = beginW + sizeW;
        var beginSl : Int = 0;
        var endSl : Int = 0;
        if (endW > pcm_storage) {
            pcm_storage = endW + vi.blocksizes[1];
            // for-while;
            var i : Int = 0;
            while (i < vi.channels) {
                //var foo : Array<Float> = new float[pcm_storage];
                // var foo : Vector<Float> = new Vector(pcm_storage, true);
                // System.arraycopyVF(pcm[i], 0, foo, 0, pcm[i].length);
                // pcm[i] = foo;
                pcm[i].length = pcm_storage;
                i++;
            };
        };
        if (W == 0) {
            beginSl = 0;
            endSl = Std.int(vi.blocksizes[0] / 2);
        } else if (W == 1) {
            beginSl = Std.int(vi.blocksizes[1] / 4) - Std.int(vi.blocksizes[lW] / 4);
            endSl = beginSl + Std.int(vi.blocksizes[lW] / 2);
        };

        // for-while;
        var j : Int = 0;
        while (j < vi.channels) {
            var _pcm : Int = beginW;
            var i : Int = 0;
            // for-while;
            i = beginSl;
            while (i < endSl) {
                pcm[j][_pcm + i] += vb.pcm[j][i];
                i++;
            };
            // for-while;
            while (i < sizeW) {
                pcm[j][_pcm + i] = vb.pcm[j][i];
                i++;
            };
            j++;
        };
        if (granulepos == -1) {
            granulepos = vb.granulepos;
        }
        else {
            granulepos += (_centerW - centerW);
            if ((vb.granulepos != -1) && (granulepos != vb.granulepos)) {
                if ((granulepos > vb.granulepos) && (vb.eofflag != 0)) {
                    _centerW -= (granulepos - vb.granulepos);
                };
                granulepos = vb.granulepos;
            };
        };
        centerW = _centerW;
        pcm_current = endW;
        if (vb.eofflag != 0) {
            eofflag = 1;
        };
        return 0;
    }

    // modifiers: public
    public function synthesis_pcmout(_pcm : Array<Array<Vector<Float>>>, index : Vector<Int>) : Int {
        if (pcm_returned < centerW) {
            if (_pcm != null) {
                // for-while;
                var i : Int = 0;
                while (i < vi.channels) {
                    index[i] = pcm_returned;
                    i++;
                };
                _pcm[0] = pcm;
            };
            return centerW - pcm_returned;
        };
        return 0;
    }

    // modifiers: public
    public function synthesis_read(bytes : Int) : Int {
        if ((bytes != 0) && ((pcm_returned + bytes) > centerW)) {
            return -1;
        };
        pcm_returned += bytes;
        return 0;
    }

    // modifiers: public
    public function clear() : Void {
    }

    // modifiers: inline, public
    inline public function new(?vi : Info) {
        // FIXME: implement disambiguation handler;
        //   __new_0() : float;
        //   __new_1(vi : Info);
        if (vi == null) {
            __new_0();
        } else {
            __new_1(vi);
        }
    }

}

