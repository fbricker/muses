package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class Mdct {
    /*
     * generated source for Mdct
     */
    inline static private var cPI3_8 : Float = 0.38268343236508977175;
    inline static private var cPI2_8 : Float = 0.70710678118654752441;
    inline static private var cPI1_8 : Float = 0.92387953251128675613;
    var n : Int;
    var log2n : Int;
    var trig : Vector<Float>;
    var bitrev : Vector<Int>;
    var scale : Float;

    // modifiers: 
    function init(n : Int) : Void {
        // bitrev = new int[n / 4];
        // trig = new float[n + (n / 4)];
        bitrev = new Vector(Std.int(n / 4), true);
        trig = new Vector(n + Std.int(n / 4), true);
        var n2 : Int = n >>> 1;
        log2n = Math.round(Math.log(n) / Math.log(2));
        this.n = n;
        var AE : Int = 0;
        var AO : Int = 1;
        var BE : Int = AE + Std.int(n / 2);
        var BO : Int = BE + 1;
        var CE : Int = BE + Std.int(n / 2);
        var CO : Int = CE + 1;
        // for-while;
        var i : Int = 0;
        while (i < (n / 4)) {
            trig[AE + (i * 2)] = Math.cos((Math.PI / n) * (4 * i));
            trig[AO + (i * 2)] = -Math.sin((Math.PI / n) * (4 * i));
            trig[BE + (i * 2)] = Math.cos((Math.PI / (2 * n)) * ((2 * i) + 1));
            trig[BO + (i * 2)] = Math.sin((Math.PI / (2 * n)) * ((2 * i) + 1));
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < (n / 8)) {
            trig[CE + (i * 2)] = Math.cos((Math.PI / n) * ((4 * i) + 2));
            trig[CO + (i * 2)] = -Math.sin((Math.PI / n) * ((4 * i) + 2));
            i++;
        };
        var mask : Int = (1 << (log2n - 1)) - 1;
        var msb : Int = 1 << (log2n - 2);
        // for-while;
        var i : Int = 0;
        while (i < (n / 8)) {
            var acc : Int = 0;
            // for-while;
            var j : Int = 0;
            while ((msb >>> j) != 0) {
                if (((msb >>> j) & i) != 0) {
                    acc |= (1 << j);
                };
                j++;
            };
            bitrev[i * 2] = (~acc & mask);
            bitrev[(i * 2) + 1] = acc;
            i++;
        };
        scale = (4. / n);
    }

    // modifiers: 
    function clear() : Void {
    }

    // modifiers: 
    function forward(in_ : Vector<Float>, out : Vector<Float>) : Void {
    }

    // discarded initializer: 'new float[1024]';
    var _x : Vector<Float>;
    // discarded initializer: 'new float[1024]';
    var _w : Vector<Float>;

    // modifiers: synchronized
    function backward(in_ : Vector<Float>, out : Vector<Float>) : Void {
        if (_x.length < (n / 2)) {
            // _x = new float[n / 2];
            _x = new Vector(Std.int(n / 2), true);
        };
        if (_w.length < (n / 2)) {
            // _w = new float[n / 2];
            _w = new Vector(Std.int(n / 2), true);
        };
        var x : Vector<Float> = _x;
        var w : Vector<Float> = _w;
        var n2 : Int = n >>> 1;
        var n4 : Int = n >>> 2;
        var n8 : Int = n >>> 3;

        {
            var inO : Int = 1;
            var xO : Int = 0;
            var A : Int = n2;
            var i : Int;
            // for-while;
            i = 0;
            while (i < n8) {
                A -= 2;
                x[xO++] = ((-in_[inO + 2] * trig[A + 1]) -
                           (in_[inO] * trig[A]));
                x[xO++] = ((in_[inO] * trig[A + 1]) -
                           (in_[inO + 2] * trig[A]));
                inO += 4;
                i++;
            };
            inO = (n2 - 4);
            // for-while;
            i = 0;
            while (i < n8) {
                A -= 2;
                x[xO++] = ((in_[inO] * trig[A + 1]) +
                           (in_[inO + 2] * trig[A]));
                x[xO++] = ((in_[inO] * trig[A]) -
                           (in_[inO + 2] * trig[A + 1]));
                inO -= 4;
                i++;
            };
        }

        var xxx : Vector<Float> = mdct_kernel(x, w, n, n2, n4, n8);
        var xx : Int = 0;

        {
            var B : Int = n2;
            var o1 : Int = n4;
            var o2 : Int = o1 - 1;
            var o3 : Int = n4 + n2;
            var o4 : Int = o3 - 1;
            // for-while;
            var i : Int = 0;
            while (i < n4) {
                var temp1 : Float = ((xxx[xx] * trig[B + 1]) -
                                     (xxx[xx + 1] * trig[B]));
                var temp2 : Float = -((xxx[xx] * trig[B]) +
                                      (xxx[xx + 1] * trig[B + 1]));
                out[o1] = -temp1;
                out[o2] = temp1;
                out[o3] = temp2;
                out[o4] = temp2;
                o1++;
                o2--;
                o3++;
                o4--;
                xx += 2;
                B += 2;
                i++;
            };
        }
    }

    // modifiers: private
    private function mdct_kernel(x : Vector<Float>, w : Vector<Float>, n : Int, n2 : Int, n4 : Int, n8 : Int) : Vector<Float> {
        var xA : Int = n4;
        var xB : Int = 0;
        var w2 : Int = n4;
        var A : Int = n2;
        // for-while;
        var i : Int = 0;
        while (i < n4) {
            var x0 : Float = x[xA] - x[xB];
            var x1 : Float;
            w[w2 + i] = (x[xA++] + x[xB++]);
            x1 = (x[xA] - x[xB]);
            A -= 4;
            w[i++] = ((x0 * trig[A]) + (x1 * trig[A + 1]));
            w[i] = ((x1 * trig[A]) - (x0 * trig[A + 1]));
            w[w2 + i] = (x[xA++] + x[xB++]);
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < (log2n - 3)) {
            var k0 : Int = n >>> (i + 2);
            var k1 : Int = 1 << (i + 3);
            var wbase : Int = n2 - 2;
            A = 0;
            var temp : Vector<Float>;
            // for-while;
            var r : Int = 0;
            while (r < (k0 >>> 2)) {
                var w1 : Int = wbase;
                w2 = (w1 - (k0 >> 1));
                var AEv : Float = trig[A];
                var wA : Float;
                var AOv : Float = trig[A + 1];
                var wB : Float;
                wbase -= 2;
                k0++;
                // for-while;
                var s : Int = 0;
                while (s < (2 << i)) {
                    wB = (w[w1] - w[w2]);
                    x[w1] = (w[w1] + w[w2]);
                    wA = (w[++w1] - w[++w2]);
                    x[w1] = (w[w1] + w[w2]);
                    x[w2] = ((wA * AEv) - (wB * AOv));
                    x[w2 - 1] = ((wB * AEv) + (wA * AOv));
                    w1 -= k0;
                    w2 -= k0;
                    s++;
                };
                k0--;
                A += k1;
                r++;
            };
            temp = w;
            w = x;
            x = temp;
            i++;
        };

        {
            var C : Int = n;
            var bit : Int = 0;
            var x1 : Int = 0;
            var x2 : Int = n2 - 1;
            // for-while;
            var i : Int = 0;
            while (i < n8) {
                var t1 : Int = bitrev[bit++];
                var t2 : Int = bitrev[bit++];
                var wA : Float = w[t1] - w[t2 + 1];
                var wB : Float = w[t1 - 1] + w[t2];
                var wC : Float = w[t1] + w[t2 + 1];
                var wD : Float = w[t1 - 1] - w[t2];
                var wACE : Float = wA * trig[C];
                var wBCE : Float = wB * trig[C++];
                var wACO : Float = wA * trig[C];
                var wBCO : Float = wB * trig[C++];
                x[x1++] = (((wC + wACO) + wBCE) * 0.5);
                x[x2--] = (((-wD + wBCO) - wACE) * 0.5);
                x[x1++] = (((wD + wBCO) - wACE) * 0.5);
                x[x2--] = (((wC - wACO) - wBCE) * 0.5);
                i++;
            };
        }
        return x;
    }

    public function new() {
        _x = new Vector(1024, true);
        _w = new Vector(1024, true);
    }
}
