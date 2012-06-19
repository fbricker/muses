package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class Lpc {
    /*
     * generated source for Lpc
     */
    // discarded initializer: 'Drft()';
    var fft : Drft;
    var ln : Int;
    var m : Int;

    // modifiers: static
    static function lpc_from_data(data : Vector<Float>, lpc : Vector<Float>, n : Int, m : Int) : Float {
        //var aut : Vector<Float> = new float[m + 1];
        var aut : Vector<Float> = new Vector(m + 1, true);
        var error : Float;
        var i : Int;
        var j : Int;
        j = (m + 1);
        while (j-- != 0) {
            var d : Float = 0;
            // for-while;
            i = j;
            while (i < n) {
                d += (data[i] * data[i - j]);
                i++;
            };
            aut[j] = d;
        };
        error = aut[0];
        // for-while;
        i = 0;
        while (i < m) {
            var r : Float = -aut[i + 1];
            if (error == 0) {
                // for-while;
                var k : Int = 0;
                while (k < m) {
                    lpc[k] = 0.0;
                    k++;
                };
                return 0;
            };
            // for-while;
            j = 0;
            while (j < i) {
                r -= (lpc[j] * aut[i - j]);
                j++;
            };
            r /= error;
            lpc[i] = r;
            // for-while;
            j = 0;
            while (j < (i / 2)) {
                var tmp : Float = lpc[j];
                lpc[j] += (r * lpc[(i - 1) - j]);
                lpc[(i - 1) - j] += (r * tmp);
                j++;
            };
            if ((i % 2) != 0) {
                lpc[j] += (lpc[j] * r);
            };
            error *= (1.0 - (r * r));
            i++;
        };
        return error;
    }

    // modifiers: 
    function lpc_from_curve(curve : Vector<Float>, lpc : Vector<Float>) : Float {
        var n : Int = ln;
        //var work : Vector<Float> = new float[n + n];
        var work : Vector<Float> = new Vector(n + n, true);
        var fscale : Float = 0.5 / n;
        var i : Int;
        var j : Int;
        // for-while;
        i = 0;
        while (i < n) {
            work[i * 2] = (curve[i] * fscale);
            work[(i * 2) + 1] = 0;
            i++;
        };
        work[(n * 2) - 1] = (curve[n - 1] * fscale);
        n *= 2;
        fft.backward(work);
        // for-while;
        i = 0;
        j = Std.int(n / 2);
        while (i < (n / 2)) {
            var temp : Float = work[i];
            work[i++] = work[j];
            work[j++] = temp;
        };
        return Lpc.lpc_from_data(work, lpc, n, m);
    }

    // modifiers: 
    public function init(mapped : Int, m : Int) : Void {
        ln = mapped;
        this.m = m;
        fft.init(mapped * 2);
    }

    // modifiers: 
    function clear() : Void {
        fft.clear();
    }

    // modifiers: static
    static function FAST_HYPOT(a : Float, b : Float) : Float {
        return Math.sqrt((a * a) + (b * b));
    }

    // modifiers: 
    public function lpc_to_curve(curve : Vector<Float>, lpc : Vector<Float>, amp : Float) : Void {
        // for-while;
        var i : Int = 0;
        while (i < (ln * 2)) {
            curve[i] = 0.0;
            i++;
        };
        if (amp == 0) {
            return;
        };
        // for-while;
        var i : Int = 0;
        while (i < m) {
            curve[(i * 2) + 1] = (lpc[i] / (4 * amp));
            curve[(i * 2) + 2] = (-lpc[i] / (4 * amp));
            i++;
        };
        fft.backward(curve);
        var l2 : Int = ln * 2;
        var unit : Float = 1. / amp;
        curve[0] = 1. / ((curve[0] * 2) + unit);
        // for-while;
        var i : Int = 1;
        while (i < ln) {
            var real : Float = curve[i] + curve[l2 - i];
            var imag : Float = curve[i] - curve[l2 - i];
            var a : Float = real + unit;
            curve[i] = 1.0 / Lpc.FAST_HYPOT(a, imag);
            i++;
        };
    }

    public function new() {
        fft = new Drft();
    }
}

