package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class Lsp {
    /*
     * generated source for Lsp
     */
    inline static var M_PI : Float = 3.1415926539;

    // modifiers: static
    static public function lsp_to_curve(curve : Vector<Float>, map : Vector<Int>, n : Int, ln : Int, lsp : Vector<Float>, m : Int, amp : Float, ampoffset : Float) : Void {
        var i : Int;
        var wdel : Float = Lsp.M_PI / ln;
        // for-while;
        i = 0;
        while (i < m) {
            lsp[i] = Lookup.coslook(lsp[i]);
            i++;
        };
        var m2 : Int = Std.int(m / 2) * 2;
        i = 0;
        while (i < n) {
            var k : Int = map[i];
            var p : Float = 0.7071067812;
            var q : Float = 0.7071067812;
            var w : Float = Lookup.coslook(wdel * k);
            var ftmp : Int = 0;
            var c : Int = m >>> 1;
            // for-while;
            var j : Int = 0;
            while (j < m2) {
                q *= (lsp[j] - w);
                p *= (lsp[j + 1] - w);
                j += 2;
            };
            if ((m & 1) != 0) {
                q *= (lsp[m - 1] - w);
                q *= q;
                p *= (p * (1. - (w * w)));
            }
            else {
                q *= (q * (1. + w));
                p *= (p * (1. - w));
            };
            q = (p + q);
            var hx : Int = System.floatToIntBits(q);
            var ix : Int = 0x7fffffff & hx;
            var qexp : Int = 0;
            if ((ix >= 0x7f800000) || (ix == 0)) {
            }
            else {
                if (ix < 0x00800000) {
                    q *= 3.3554432000e+07;
                    hx = System.floatToIntBits(q);
                    ix = (0x7fffffff & hx);
                    qexp = -25;
                };
                qexp += ((ix >>> 23) - 126);
                hx = ((hx & 0x807fffff) | 0x3f000000);
                q = System.intBitsToFloat(hx);
            };
            q = Lookup.fromdBlook(((amp * Lookup.invsqlook(q)) * Lookup.invsq2explook(qexp + m)) - ampoffset);
            while (true) {
                // HAXE200BUG
                // curve[i++] *= q;
                curve[i] *= q;
                i++;
                if (!((i < n) && (map[i] == k))) {
                    break;
                };
            };
        };
    }

}

