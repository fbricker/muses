package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class Drft {
    /*
     * generated source for Drft
     */
    var n : Int;
    var trigcache : Vector<Float>;
    var splitcache : Vector<Int>;

    // modifiers: 
    public function backward(data : Vector<Float>) : Void {
        if (n == 1) {
            return;
        };
        Drft.drftb1(n, data, trigcache, trigcache, n, splitcache);
    }

    // modifiers: 
    public function init(n : Int) : Void {
        this.n = n;
        //trigcache = new float[3 * n];
        trigcache = new Vector(3 * n, true);
        //splitcache = new int[32];
        splitcache = new Vector(32, true);
        Drft.fdrffti(n, trigcache, splitcache);
    }

    // modifiers: 
    public function clear() : Void {
        if (trigcache != null) {
            trigcache = null;
        };
        if (splitcache != null) {
            splitcache = null;
        };
    }

    static var ntryh : Array<Int> = [4, 2, 3, 5];
    static var tpi : Float = 6.28318530717958647692528676655900577;
    static var hsqt2 : Float = 0.70710678118654752440084436210485;
    static var taui : Float = 0.86602540378443864676372317075293618;
    static var taur : Float = -0.5;
    static var sqrt2 : Float = 1.4142135623730950488016887242097;

    // modifiers: static
    static function drfti1(n : Int, wa : Vector<Float>, index : Int, ifac : Vector<Int>) : Void {
        var arg : Float;
        var argh : Float;
        var argld : Float;
        var fi : Float;
        var ntry : Int = 0;
        var i : Int;
        var j : Int = -1;
        var k1 : Int;
        var l1 : Int;
        var l2 : Int;
        var ib : Int;
        var ld : Int;
        var ii : Int;
        var ip : Int;
        var is_ : Int;
        var nq : Int;
        var nr : Int;
        var ido : Int;
        var ipm : Int;
        var nfm1 : Int;
        var nl : Int = n;
        var nf : Int = 0;
        var state : Int = 101;

        var _break_loop : Int = 0;
        while (true) {
            trace("");

            while (true) {
                var fall = false;
                if (state == 101) {
                    j++;
                    if (j < 4) {
                        ntry = Drft.ntryh[j];
                    }
                    else {
                        ntry += 2;
                    };
                    fall = true;
                };

                if (fall || state == 104) {
                    nq = Std.int(nl / ntry);
                    nr = (nl - (ntry * nq));
                    if (nr != 0) {
                        state = 101;
                        break;
                    };
                    nf++;
                    ifac[nf + 1] = ntry;
                    nl = nq;
                    if (ntry != 2) {
                        state = 107;
                        break;
                    };
                    if (nf == 1) {
                        state = 107;
                        break;
                    };
                    // for-while;
                    i = 1;
                    while (i < nf) {
                        ib = ((nf - i) + 1);
                        ifac[ib + 1] = ifac[ib];
                        i++;
                    };
                    ifac[2] = 2;
                    fall = true;
                };

                if (fall || state == 107) {
                    if (nl != 1) {
                        state = 104;
                        break;
                    };
                    ifac[0] = n;
                    ifac[1] = nf;
                    argh = (Drft.tpi / n);
                    is_ = 0;
                    nfm1 = (nf - 1);
                    l1 = 1;
                    if (nfm1 == 0) {
                        return;
                    };
                    // for-while;
                    k1 = 0;
                    while (k1 < nfm1) {
                        ip = ifac[k1 + 2];
                        ld = 0;
                        l2 = (l1 * ip);
                        ido = Std.int(n / l2);
                        ipm = (ip - 1);
                        // for-while;
                        j = 0;
                        while (j < ipm) {
                            ld += l1;
                            i = is_;
                            argld = (ld * argh);
                            fi = 0.;
                            // for-while;
                            ii = 2;
                            while (ii < ido) {
                                fi += 1.;
                                arg = (fi * argld);
                                wa[index + i++] = Math.cos(arg);
                                wa[index + i++] = Math.sin(arg);
                                ii += 2;
                            };
                            is_ += ido;
                            j++;
                        };
                        l1 = l2;
                        k1++;
                    };
                    _break_loop = 1;
                    break;
                };
                break;
            };
            if (_break_loop == 1) {
                break;
            }
            else {
                _break_loop = 0;
            };
        };
    }

    // modifiers: static
    static function fdrffti(n : Int, wsave : Vector<Float>, ifac : Vector<Int>) : Void {
        if (n == 1) {
            return;
        };
        Drft.drfti1(n, wsave, n, ifac);
    }

    // modifiers: static
    static function dradf2(ido : Int, l1 : Int, cc : Vector<Float>, ch : Vector<Float>, wa1 : Vector<Float>, index : Int) : Void {
        var i : Int;
        var k : Int;
        var ti2 : Float;
        var tr2 : Float;
        var t0 : Int;
        var t1 : Int;
        var t2 : Int;
        var t3 : Int;
        var t4 : Int;
        var t5 : Int;
        var t6 : Int;
        t1 = 0;
        t0 = (t2 = (l1 * ido));
        t3 = (ido << 1);
        // for-while;
        k = 0;
        while (k < l1) {
            ch[t1 << 1] = (cc[t1] + cc[t2]);
            ch[((t1 << 1) + t3) - 1] = (cc[t1] - cc[t2]);
            t1 += ido;
            t2 += ido;
            k++;
        };
        if (ido < 2) {
            return;
        };
        if (ido != 2) {
            t1 = 0;
            t2 = t0;
            // for-while;
            k = 0;
            while (k < l1) {
                t3 = t2;
                t4 = ((t1 << 1) + (ido << 1));
                t5 = t1;
                t6 = (t1 + t1);
                // for-while;
                i = 2;
                while (i < ido) {
                    t3 += 2;
                    t4 -= 2;
                    t5 += 2;
                    t6 += 2;
                    tr2 = ((wa1[(index + i) - 2] * cc[t3 - 1]) + (wa1[(index + i) - 1] * cc[t3]));
                    ti2 = ((wa1[(index + i) - 2] * cc[t3]) - (wa1[(index + i) - 1] * cc[t3 - 1]));
                    ch[t6] = (cc[t5] + ti2);
                    ch[t4] = (ti2 - cc[t5]);
                    ch[t6 - 1] = (cc[t5 - 1] + tr2);
                    ch[t4 - 1] = (cc[t5 - 1] - tr2);
                    i += 2;
                };
                t1 += ido;
                t2 += ido;
                k++;
            };
            if ((ido % 2) == 1) {
                return;
            };
        };
        t3 = (t2 = ((t1 = ido) - 1));
        t2 += t0;
        // for-while;
        k = 0;
        while (k < l1) {
            ch[t1] = -cc[t2];
            ch[t1 - 1] = cc[t3];
            t1 += (ido << 1);
            t2 += ido;
            t3 += ido;
            k++;
        };
    }

    // modifiers: static
    static function dradf4(ido : Int, l1 : Int, cc : Vector<Float>, ch : Vector<Float>, wa1 : Vector<Float>, index1 : Int, wa2 : Vector<Float>, index2 : Int, wa3 : Vector<Float>, index3 : Int) : Void {
        var i : Int;
        var k : Int;
        var t0 : Int;
        var t1 : Int;
        var t2 : Int;
        var t3 : Int;
        var t4 : Int;
        var t5 : Int;
        var t6 : Int;
        var ci2 : Float;
        var ci3 : Float;
        var ci4 : Float;
        var cr2 : Float;
        var cr3 : Float;
        var cr4 : Float;
        var ti1 : Float;
        var ti2 : Float;
        var ti3 : Float;
        var ti4 : Float;
        var tr1 : Float;
        var tr2 : Float;
        var tr3 : Float;
        var tr4 : Float;
        t0 = (l1 * ido);
        t1 = t0;
        t4 = (t1 << 1);
        t2 = (t1 + (t1 << 1));
        t3 = 0;
        // for-while;
        k = 0;
        while (k < l1) {
            tr1 = (cc[t1] + cc[t2]);
            tr2 = (cc[t3] + cc[t4]);
            // ch[t5 = (t3 << 2)] = (tr1 + tr2);
            t5 = (t3 << 2);
            ch[t5] = (tr1 + tr2);
            ch[((ido << 2) + t5) - 1] = (tr2 - tr1);
            // ch[(t5 += (ido << 1)) - 1] = (cc[t3] - cc[t4]);
            t5 += (ido << 1);
            ch[t5  - 1] = (cc[t3] - cc[t4]);
            ch[t5] = (cc[t2] - cc[t1]);
            t1 += ido;
            t2 += ido;
            t3 += ido;
            t4 += ido;
            k++;
        };
        if (ido < 2) {
            return;
        };
        if (ido != 2) {
            t1 = 0;
            // for-while;
            k = 0;
            while (k < l1) {
                t2 = t1;
                t4 = (t1 << 2);
                t5 = ((t6 = (ido << 1)) + t4);
                // for-while;
                i = 2;
                while (i < ido) {
                    t3 = (t2 += 2);
                    t4 += 2;
                    t5 -= 2;
                    t3 += t0;
                    cr2 = ((wa1[(index1 + i) - 2] * cc[t3 - 1]) + (wa1[(index1 + i) - 1] * cc[t3]));
                    ci2 = ((wa1[(index1 + i) - 2] * cc[t3]) - (wa1[(index1 + i) - 1] * cc[t3 - 1]));
                    t3 += t0;
                    cr3 = ((wa2[(index2 + i) - 2] * cc[t3 - 1]) + (wa2[(index2 + i) - 1] * cc[t3]));
                    ci3 = ((wa2[(index2 + i) - 2] * cc[t3]) - (wa2[(index2 + i) - 1] * cc[t3 - 1]));
                    t3 += t0;
                    cr4 = ((wa3[(index3 + i) - 2] * cc[t3 - 1]) + (wa3[(index3 + i) - 1] * cc[t3]));
                    ci4 = ((wa3[(index3 + i) - 2] * cc[t3]) - (wa3[(index3 + i) - 1] * cc[t3 - 1]));
                    tr1 = (cr2 + cr4);
                    tr4 = (cr4 - cr2);
                    ti1 = (ci2 + ci4);
                    ti4 = (ci2 - ci4);
                    ti2 = (cc[t2] + ci3);
                    ti3 = (cc[t2] - ci3);
                    tr2 = (cc[t2 - 1] + cr3);
                    tr3 = (cc[t2 - 1] - cr3);
                    ch[t4 - 1] = (tr1 + tr2);
                    ch[t4] = (ti1 + ti2);
                    ch[t5 - 1] = (tr3 - ti4);
                    ch[t5] = (tr4 - ti3);
                    ch[(t4 + t6) - 1] = (ti4 + tr3);
                    ch[t4 + t6] = (tr4 + ti3);
                    ch[(t5 + t6) - 1] = (tr2 - tr1);
                    ch[t5 + t6] = (ti1 - ti2);
                    i += 2;
                };
                t1 += ido;
                k++;
            };
            if ((ido & 1) != 0) {
                return;
            };
        };
        t2 = ((t1 = ((t0 + ido) - 1)) + (t0 << 1));
        t3 = (ido << 2);
        t4 = ido;
        t5 = (ido << 1);
        t6 = ido;
        // for-while;
        k = 0;
        while (k < l1) {
            ti1 = (-Drft.hsqt2 * (cc[t1] + cc[t2]));
            tr1 = (Drft.hsqt2 * (cc[t1] - cc[t2]));
            ch[t4 - 1] = (tr1 + cc[t6 - 1]);
            ch[(t4 + t5) - 1] = (cc[t6 - 1] - tr1);
            ch[t4] = (ti1 - cc[t1 + t0]);
            ch[t4 + t5] = (ti1 + cc[t1 + t0]);
            t1 += ido;
            t2 += ido;
            t4 += t3;
            t6 += ido;
            k++;
        };
    }

    // modifiers: static
    static function dradfg(ido : Int, ip : Int, l1 : Int, idl1 : Int, cc : Vector<Float>, c1 : Vector<Float>, c2 : Vector<Float>, ch : Vector<Float>, ch2 : Vector<Float>, wa : Vector<Float>, index : Int) : Void {
        var idij : Int;
        var ipph : Int;
        var i : Int;
        var j : Int;
        var k : Int;
        var l : Int;
        var ic : Int;
        var ik : Int;
        var is_ : Int;
        var t0 : Int;
        var t1 : Int;
        var t2 : Int = 0;
        var t3 : Int;
        var t4 : Int;
        var t5 : Int;
        var t6 : Int;
        var t7 : Int;
        var t8 : Int;
        var t9 : Int;
        var t10 : Int;
        var dc2 : Float;
        var ai1 : Float;
        var ai2 : Float;
        var ar1 : Float;
        var ar2 : Float;
        var ds2 : Float;
        var nbd : Int;
        var dcp : Float = 0;
        var arg : Float;
        var dsp : Float = 0;
        var ar1h : Float;
        var ar2h : Float;
        var idp2 : Int;
        var ipp2 : Int;
        arg = (Drft.tpi / ip);
        dcp = Math.cos(arg);
        dsp = Math.sin(arg);
        ipph = ((ip + 1) >> 1);
        ipp2 = ip;
        idp2 = ido;
        nbd = ((ido - 1) >> 1);
        t0 = (l1 * ido);
        t10 = (ip * ido);
        var state : Int = 100;

        var _break_loop : Int = 0;
        while (true) {
            // switch (state) ...
            while (true) {
                var fall = false;

                if (state == 101) {
                    if (ido == 1) {
                        state = 119;
                        break;
                    };
                    // for-while;
                    ik = 0;
                    while (ik < idl1) {
                        ch2[ik] = c2[ik];
                        ik++;
                    };
                    t1 = 0;
                    // for-while;
                    j = 1;
                    while (j < ip) {
                        t1 += t0;
                        t2 = t1;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            ch[t2] = c1[t2];
                            t2 += ido;
                            k++;
                        };
                        j++;
                    };
                    is_ = -ido;
                    t1 = 0;
                    if (nbd > l1) {
                        // for-while;
                        j = 1;
                        while (j < ip) {
                            t1 += t0;
                            is_ += ido;
                            t2 = (-ido + t1);
                            // for-while;
                            k = 0;
                            while (k < l1) {
                                idij = (is_ - 1);
                                t2 += ido;
                                t3 = t2;
                                // for-while;
                                i = 2;
                                while (i < ido) {
                                    idij += 2;
                                    t3 += 2;
                                    ch[t3 - 1] = ((wa[(index + idij) - 1] * c1[t3 - 1]) + (wa[index + idij] * c1[t3]));
                                    ch[t3] = ((wa[(index + idij) - 1] * c1[t3]) - (wa[index + idij] * c1[t3 - 1]));
                                    i += 2;
                                };
                                k++;
                            };
                            j++;
                        };
                    }
                    else {
                        // for-while;
                        j = 1;
                        while (j < ip) {
                            is_ += ido;
                            idij = (is_ - 1);
                            t1 += t0;
                            t2 = t1;
                            // for-while;
                            i = 2;
                            while (i < ido) {
                                idij += 2;
                                t2 += 2;
                                t3 = t2;
                                // for-while;
                                k = 0;
                                while (k < l1) {
                                    ch[t3 - 1] = ((wa[(index + idij) - 1] * c1[t3 - 1]) + (wa[index + idij] * c1[t3]));
                                    ch[t3] = ((wa[(index + idij) - 1] * c1[t3]) - (wa[index + idij] * c1[t3 - 1]));
                                    t3 += ido;
                                    k++;
                                };
                                i += 2;
                            };
                            j++;
                        };
                    };
                    t1 = 0;
                    t2 = (ipp2 * t0);
                    if (nbd < l1) {
                        // for-while;
                        j = 1;
                        while (j < ipph) {
                            t1 += t0;
                            t2 -= t0;
                            t3 = t1;
                            t4 = t2;
                            // for-while;
                            i = 2;
                            while (i < ido) {
                                t3 += 2;
                                t4 += 2;
                                t5 = (t3 - ido);
                                t6 = (t4 - ido);
                                // for-while;
                                k = 0;
                                while (k < l1) {
                                    t5 += ido;
                                    t6 += ido;
                                    c1[t5 - 1] = (ch[t5 - 1] + ch[t6 - 1]);
                                    c1[t6 - 1] = (ch[t5] - ch[t6]);
                                    c1[t5] = (ch[t5] + ch[t6]);
                                    c1[t6] = (ch[t6 - 1] - ch[t5 - 1]);
                                    k++;
                                };
                                i += 2;
                            };
                            j++;
                        };
                    }
                    else {
                        // for-while;
                        j = 1;
                        while (j < ipph) {
                            t1 += t0;
                            t2 -= t0;
                            t3 = t1;
                            t4 = t2;
                            // for-while;
                            k = 0;
                            while (k < l1) {
                                t5 = t3;
                                t6 = t4;
                                // for-while;
                                i = 2;
                                while (i < ido) {
                                    t5 += 2;
                                    t6 += 2;
                                    c1[t5 - 1] = (ch[t5 - 1] + ch[t6 - 1]);
                                    c1[t6 - 1] = (ch[t5] - ch[t6]);
                                    c1[t5] = (ch[t5] + ch[t6]);
                                    c1[t6] = (ch[t6 - 1] - ch[t5 - 1]);
                                    i += 2;
                                };
                                t3 += ido;
                                t4 += ido;
                                k++;
                            };
                            j++;
                        };
                    };
                    fall = true;
                };

                if (fall || state == 119) {
                    // for-while;
                    ik = 0;
                    while (ik < idl1) {
                        c2[ik] = ch2[ik];
                        ik++;
                    };
                    t1 = 0;
                    t2 = (ipp2 * idl1);
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t0;
                        t2 -= t0;
                        t3 = (t1 - ido);
                        t4 = (t2 - ido);
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            t3 += ido;
                            t4 += ido;
                            c1[t3] = (ch[t3] + ch[t4]);
                            c1[t4] = (ch[t4] - ch[t3]);
                            k++;
                        };
                        j++;
                    };
                    ar1 = 1.;
                    ai1 = 0.;
                    t1 = 0;
                    t2 = (ipp2 * idl1);
                    t3 = ((ip - 1) * idl1);
                    // for-while;
                    l = 1;
                    while (l < ipph) {
                        t1 += idl1;
                        t2 -= idl1;
                        ar1h = ((dcp * ar1) - (dsp * ai1));
                        ai1 = ((dcp * ai1) + (dsp * ar1));
                        ar1 = ar1h;
                        t4 = t1;
                        t5 = t2;
                        t6 = t3;
                        t7 = idl1;
                        // for-while;
                        ik = 0;
                        while (ik < idl1) {
                            ch2[t4++] = (c2[ik] + (ar1 * c2[t7++]));
                            ch2[t5++] = (ai1 * c2[t6++]);
                            ik++;
                        };
                        dc2 = ar1;
                        ds2 = ai1;
                        ar2 = ar1;
                        ai2 = ai1;
                        t4 = idl1;
                        t5 = ((ipp2 - 1) * idl1);
                        // for-while;
                        j = 2;
                        while (j < ipph) {
                            t4 += idl1;
                            t5 -= idl1;
                            ar2h = ((dc2 * ar2) - (ds2 * ai2));
                            ai2 = ((dc2 * ai2) + (ds2 * ar2));
                            ar2 = ar2h;
                            t6 = t1;
                            t7 = t2;
                            t8 = t4;
                            t9 = t5;
                            // for-while;
                            ik = 0;
                            while (ik < idl1) {
                                // HAXE200BUG
                                // ch2[t6++] += (ar2 * c2[t8++]);
                                // ch2[t7++] += (ai2 * c2[t9++]);
                                ch2[t6] += (ar2 * c2[t8]);
                                t6++; t8++;
                                ch2[t7] += (ai2 * c2[t9]);
                                t7++; t9++;
                                ik++;
                            };
                            j++;
                        };
                        l++;
                    };
                    t1 = 0;
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += idl1;
                        t2 = t1;
                        // for-while;
                        ik = 0;
                        while (ik < idl1) {
                            ch2[ik] += c2[t2++];
                            ik++;
                        };
                        j++;
                    };
                    if (ido < l1) {
                        state = 132;
                        break;
                    };
                    t1 = 0;
                    t2 = 0;
                    // for-while;
                    k = 0;
                    while (k < l1) {
                        t3 = t1;
                        t4 = t2;
                        // for-while;
                        i = 0;
                        while (i < ido) {
                            cc[t4++] = ch[t3++];
                            i++;
                        };
                        t1 += ido;
                        t2 += t10;
                        k++;
                    };
                    state = 135;
                    break;
                    fall = false;
                };

                if (state == 132) {
                    // for-while;
                    i = 0;
                    while (i < ido) {
                        t1 = i;
                        t2 = i;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            cc[t2] = ch[t1];
                            t1 += ido;
                            t2 += t10;
                            k++;
                        };
                        i++;
                    };
                    fall = true;
                };

                if (fall || state == 135) {
                    t1 = 0;
                    t2 = (ido << 1);
                    t3 = 0;
                    t4 = (ipp2 * t0);
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t2;
                        t3 += t0;
                        t4 -= t0;
                        t5 = t1;
                        t6 = t3;
                        t7 = t4;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            cc[t5 - 1] = ch[t6];
                            cc[t5] = ch[t7];
                            t5 += t10;
                            t6 += ido;
                            t7 += ido;
                            k++;
                        };
                        j++;
                    };
                    if (ido == 1) {
                        return;
                    };
                    if (nbd < l1) {
                        state = 141;
                        break;
                    };
                    t1 = -ido;
                    t3 = 0;
                    t4 = 0;
                    t5 = (ipp2 * t0);
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t2;
                        t3 += t2;
                        t4 += t0;
                        t5 -= t0;
                        t6 = t1;
                        t7 = t3;
                        t8 = t4;
                        t9 = t5;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            // for-while;
                            i = 2;
                            while (i < ido) {
                                ic = (idp2 - i);
                                cc[(i + t7) - 1] = (ch[(i + t8) - 1] + ch[(i + t9) - 1]);
                                cc[(ic + t6) - 1] = (ch[(i + t8) - 1] - ch[(i + t9) - 1]);
                                cc[i + t7] = (ch[i + t8] + ch[i + t9]);
                                cc[ic + t6] = (ch[i + t9] - ch[i + t8]);
                                i += 2;
                            };
                            t6 += t10;
                            t7 += t10;
                            t8 += ido;
                            t9 += ido;
                            k++;
                        };
                        j++;
                    };
                    return;
                };

                if (state == 141) {
                    t1 = -ido;
                    t3 = 0;
                    t4 = 0;
                    t5 = (ipp2 * t0);
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t2;
                        t3 += t2;
                        t4 += t0;
                        t5 -= t0;
                        // for-while;
                        i = 2;
                        while (i < ido) {
                            t6 = ((idp2 + t1) - i);
                            t7 = (i + t3);
                            t8 = (i + t4);
                            t9 = (i + t5);
                            // for-while;
                            k = 0;
                            while (k < l1) {
                                cc[t7 - 1] = (ch[t8 - 1] + ch[t9 - 1]);
                                cc[t6 - 1] = (ch[t8 - 1] - ch[t9 - 1]);
                                cc[t7] = (ch[t8] + ch[t9]);
                                cc[t6] = (ch[t9] - ch[t8]);
                                t6 += t10;
                                t7 += t10;
                                t8 += ido;
                                t9 += ido;
                                k++;
                            };
                            i += 2;
                        };
                        j++;
                    };
                    _break_loop = 1;
                    break;
                };
                break;
            };
            if (_break_loop == 1) {
                break;
            }
            else {
                _break_loop = 0;
            };
        };
    }

    // modifiers: static
    static function drftf1(n : Int, c : Vector<Float>, ch : Vector<Float>, wa : Vector<Float>, ifac : Vector<Int>) : Void {
        var i : Int;
        var k1 : Int;
        var l1 : Int;
        var l2 : Int;
        var na : Int;
        var kh : Int;
        var nf : Int;
        var ip : Int;
        var iw : Int;
        var ido : Int;
        var idl1 : Int;
        var ix2 : Int;
        var ix3 : Int;
        nf = ifac[1];
        na = 1;
        l2 = n;
        iw = n;
        // for-while;
        k1 = 0;
        while (k1 < nf) {
            kh = (nf - k1);
            ip = ifac[kh + 1];
            l1 = Std.int(l2 / ip);
            ido = Std.int(n / l2);
            idl1 = (ido * l1);
            iw -= ((ip - 1) * ido);
            na = (1 - na);
            var state : Int = 100;

            var _break_loop : Int = 0;
            while (true) {
                // switch (state) ...
                while (true) {
                    var fall = false;
                    if (state == 100) {
                        if (ip != 4) {
                            state = 102;
                            break;
                        };
                        ix2 = (iw + ido);
                        ix3 = (ix2 + ido);
                        if (na != 0) {
                            Drft.dradf4(ido, l1, ch, c, wa, iw - 1, wa, ix2 - 1, wa, ix3 - 1);
                        }
                        else {
                            Drft.dradf4(ido, l1, c, ch, wa, iw - 1, wa, ix2 - 1, wa, ix3 - 1);
                        };
                        state = 110;
                        break;
                    };

                    if (state == 102) {
                        if (ip != 2) {
                            state = 104;
                            break;
                        };
                        if (na != 0) {
                            state = 103;
                            break;
                        };
                        Drft.dradf2(ido, l1, c, ch, wa, iw - 1);
                        state = 110;
                        break;
                    };

                    if (state == 103) {
                        Drft.dradf2(ido, l1, ch, c, wa, iw - 1);
                        fall = true;
                    };

                    if (fall || state == 104) {
                        if (ido == 1) {
                            na = (1 - na);
                        };
                        if (na != 0) {
                            state = 109;
                            break;
                        };
                        Drft.dradfg(ido, ip, l1, idl1, c, c, c, ch, ch, wa, iw - 1);
                        na = 1;
                        state = 110;
                        fall = false;
                        break;
                    };

                    if (state == 109) {
                        Drft.dradfg(ido, ip, l1, idl1, ch, ch, ch, c, c, wa, iw - 1);
                        na = 0;
                        fall = true;
                    };
                    if (fall || state == 110) {
                        l2 = l1;
                        _break_loop = 1;
                        break;
                    };
                    break;
                };
                if (_break_loop == 1) {
                    break;
                }
                else {
                    _break_loop = 0;
                };
            };
            k1++;
        };
        if (na == 1) {
            return;
        };
        // for-while;
        i = 0;
        while (i < n) {
            c[i] = ch[i];
            i++;
        };
    }

    // modifiers: static
    static function dradb2(ido : Int, l1 : Int, cc : Vector<Float>, ch : Vector<Float>, wa1 : Vector<Float>, index : Int) : Void {
        var i : Int;
        var k : Int;
        var t0 : Int;
        var t1 : Int;
        var t2 : Int;
        var t3 : Int;
        var t4 : Int;
        var t5 : Int;
        var t6 : Int;
        var ti2 : Float;
        var tr2 : Float;
        t0 = (l1 * ido);
        t1 = 0;
        t2 = 0;
        t3 = ((ido << 1) - 1);
        // for-while;
        k = 0;
        while (k < l1) {
            ch[t1] = (cc[t2] + cc[t3 + t2]);
            ch[t1 + t0] = (cc[t2] - cc[t3 + t2]);
            t2 = ((t1 += ido) << 1);
            k++;
        };
        if (ido < 2) {
            return;
        };
        if (ido != 2) {
            t1 = 0;
            t2 = 0;
            // for-while;
            k = 0;
            while (k < l1) {
                t3 = t1;
                t5 = ((t4 = t2) + (ido << 1));
                t6 = (t0 + t1);
                // for-while;
                i = 2;
                while (i < ido) {
                    t3 += 2;
                    t4 += 2;
                    t5 -= 2;
                    t6 += 2;
                    ch[t3 - 1] = (cc[t4 - 1] + cc[t5 - 1]);
                    tr2 = (cc[t4 - 1] - cc[t5 - 1]);
                    ch[t3] = (cc[t4] - cc[t5]);
                    ti2 = (cc[t4] + cc[t5]);
                    ch[t6 - 1] = ((wa1[(index + i) - 2] * tr2) - (wa1[(index + i) - 1] * ti2));
                    ch[t6] = ((wa1[(index + i) - 2] * ti2) + (wa1[(index + i) - 1] * tr2));
                    i += 2;
                };
                t2 = ((t1 += ido) << 1);
                k++;
            };
            if ((ido % 2) == 1) {
                return;
            };
        };
        t1 = (ido - 1);
        t2 = (ido - 1);
        // for-while;
        k = 0;
        while (k < l1) {
            ch[t1] = (cc[t2] + cc[t2]);
            ch[t1 + t0] = -(cc[t2 + 1] + cc[t2 + 1]);
            t1 += ido;
            t2 += (ido << 1);
            k++;
        };
    }

    // modifiers: static
    static function dradb3(ido : Int, l1 : Int, cc : Vector<Float>, ch : Vector<Float>, wa1 : Vector<Float>, index1 : Int, wa2 : Vector<Float>, index2 : Int) : Void {
        var i : Int;
        var k : Int;
        var t0 : Int;
        var t1 : Int;
        var t2 : Int;
        var t3 : Int;
        var t4 : Int;
        var t5 : Int;
        var t6 : Int;
        var t7 : Int;
        var t8 : Int;
        var t9 : Int;
        var t10 : Int;
        var ci2 : Float;
        var ci3 : Float;
        var di2 : Float;
        var di3 : Float;
        var cr2 : Float;
        var cr3 : Float;
        var dr2 : Float;
        var dr3 : Float;
        var ti2 : Float;
        var tr2 : Float;
        t0 = (l1 * ido);
        t1 = 0;
        t2 = (t0 << 1);
        t3 = (ido << 1);
        t4 = (ido + (ido << 1));
        t5 = 0;
        // for-while;
        k = 0;
        while (k < l1) {
            tr2 = (cc[t3 - 1] + cc[t3 - 1]);
            cr2 = (cc[t5] + (Drft.taur * tr2));
            ch[t1] = (cc[t5] + tr2);
            ci3 = (Drft.taui * (cc[t3] + cc[t3]));
            ch[t1 + t0] = (cr2 - ci3);
            ch[t1 + t2] = (cr2 + ci3);
            t1 += ido;
            t3 += t4;
            t5 += t4;
            k++;
        };
        if (ido == 1) {
            return;
        };
        t1 = 0;
        t3 = (ido << 1);
        // for-while;
        k = 0;
        while (k < l1) {
            t7 = (t1 + (t1 << 1));
            t6 = (t5 = (t7 + t3));
            t8 = t1;
            t10 = ((t9 = (t1 + t0)) + t0);
            // for-while;
            i = 2;
            while (i < ido) {
                t5 += 2;
                t6 -= 2;
                t7 += 2;
                t8 += 2;
                t9 += 2;
                t10 += 2;
                tr2 = (cc[t5 - 1] + cc[t6 - 1]);
                cr2 = (cc[t7 - 1] + (Drft.taur * tr2));
                ch[t8 - 1] = (cc[t7 - 1] + tr2);
                ti2 = (cc[t5] - cc[t6]);
                ci2 = (cc[t7] + (Drft.taur * ti2));
                ch[t8] = (cc[t7] + ti2);
                cr3 = (Drft.taui * (cc[t5 - 1] - cc[t6 - 1]));
                ci3 = (Drft.taui * (cc[t5] + cc[t6]));
                dr2 = (cr2 - ci3);
                dr3 = (cr2 + ci3);
                di2 = (ci2 + cr3);
                di3 = (ci2 - cr3);
                ch[t9 - 1] = ((wa1[(index1 + i) - 2] * dr2) - (wa1[(index1 + i) - 1] * di2));
                ch[t9] = ((wa1[(index1 + i) - 2] * di2) + (wa1[(index1 + i) - 1] * dr2));
                ch[t10 - 1] = ((wa2[(index2 + i) - 2] * dr3) - (wa2[(index2 + i) - 1] * di3));
                ch[t10] = ((wa2[(index2 + i) - 2] * di3) + (wa2[(index2 + i) - 1] * dr3));
                i += 2;
            };
            t1 += ido;
            k++;
        };
    }

    // modifiers: static
    static function dradb4(ido : Int, l1 : Int, cc : Vector<Float>, ch : Vector<Float>, wa1 : Vector<Float>, index1 : Int, wa2 : Vector<Float>, index2 : Int, wa3 : Vector<Float>, index3 : Int) : Void {
        var i : Int;
        var k : Int;
        var t0 : Int;
        var t1 : Int;
        var t2 : Int;
        var t3 : Int;
        var t4 : Int;
        var t5 : Int;
        var t6 : Int;
        var t7 : Int;
        var t8 : Int;
        var ci2 : Float;
        var ci3 : Float;
        var ci4 : Float;
        var cr2 : Float;
        var cr3 : Float;
        var cr4 : Float;
        var ti1 : Float;
        var ti2 : Float;
        var ti3 : Float;
        var ti4 : Float;
        var tr1 : Float;
        var tr2 : Float;
        var tr3 : Float;
        var tr4 : Float;
        t0 = (l1 * ido);
        t1 = 0;
        t2 = (ido << 2);
        t3 = 0;
        t6 = (ido << 1);
        // for-while;
        k = 0;
        while (k < l1) {
            t4 = (t3 + t6);
            t5 = t1;
            tr3 = (cc[t4 - 1] + cc[t4 - 1]);
            tr4 = (cc[t4] + cc[t4]);
            tr1 = (cc[t3] - cc[(t4 += t6) - 1]);
            tr2 = (cc[t3] + cc[t4 - 1]);
            ch[t5] = (tr2 + tr3);
            ch[t5 += t0] = (tr1 - tr4);
            ch[t5 += t0] = (tr2 - tr3);
            ch[t5 += t0] = (tr1 + tr4);
            t1 += ido;
            t3 += t2;
            k++;
        };
        if (ido < 2) {
            return;
        };
        if (ido != 2) {
            t1 = 0;
            // for-while;
            k = 0;
            while (k < l1) {
                t5 = ((t4 = (t3 = ((t2 = (t1 << 2)) + t6))) + t6);
                t7 = t1;
                // for-while;
                i = 2;
                while (i < ido) {
                    t2 += 2;
                    t3 += 2;
                    t4 -= 2;
                    t5 -= 2;
                    t7 += 2;
                    ti1 = (cc[t2] + cc[t5]);
                    ti2 = (cc[t2] - cc[t5]);
                    ti3 = (cc[t3] - cc[t4]);
                    tr4 = (cc[t3] + cc[t4]);
                    tr1 = (cc[t2 - 1] - cc[t5 - 1]);
                    tr2 = (cc[t2 - 1] + cc[t5 - 1]);
                    ti4 = (cc[t3 - 1] - cc[t4 - 1]);
                    tr3 = (cc[t3 - 1] + cc[t4 - 1]);
                    ch[t7 - 1] = (tr2 + tr3);
                    cr3 = (tr2 - tr3);
                    ch[t7] = (ti2 + ti3);
                    ci3 = (ti2 - ti3);
                    cr2 = (tr1 - tr4);
                    cr4 = (tr1 + tr4);
                    ci2 = (ti1 + ti4);
                    ci4 = (ti1 - ti4);
                    ch[(t8 = (t7 + t0)) - 1] = ((wa1[(index1 + i) - 2] * cr2) - (wa1[(index1 + i) - 1] * ci2));
                    ch[t8] = ((wa1[(index1 + i) - 2] * ci2) + (wa1[(index1 + i) - 1] * cr2));
                    ch[(t8 += t0) - 1] = ((wa2[(index2 + i) - 2] * cr3) - (wa2[(index2 + i) - 1] * ci3));
                    ch[t8] = ((wa2[(index2 + i) - 2] * ci3) + (wa2[(index2 + i) - 1] * cr3));
                    ch[(t8 += t0) - 1] = ((wa3[(index3 + i) - 2] * cr4) - (wa3[(index3 + i) - 1] * ci4));
                    ch[t8] = ((wa3[(index3 + i) - 2] * ci4) + (wa3[(index3 + i) - 1] * cr4));
                    i += 2;
                };
                t1 += ido;
                k++;
            };
            if ((ido % 2) == 1) {
                return;
            };
        };
        t1 = ido;
        t2 = (ido << 2);
        t3 = (ido - 1);
        t4 = (ido + (ido << 1));
        // for-while;
        k = 0;
        while (k < l1) {
            t5 = t3;
            ti1 = (cc[t1] + cc[t4]);
            ti2 = (cc[t4] - cc[t1]);
            tr1 = (cc[t1 - 1] - cc[t4 - 1]);
            tr2 = (cc[t1 - 1] + cc[t4 - 1]);
            ch[t5] = (tr2 + tr2);
            ch[t5 += t0] = (Drft.sqrt2 * (tr1 - ti1));
            ch[t5 += t0] = (ti2 + ti2);
            ch[t5 += t0] = (-Drft.sqrt2 * (tr1 + ti1));
            t3 += ido;
            t1 += t2;
            t4 += t2;
            k++;
        };
    }

    // modifiers: static
    static function dradbg(ido : Int, ip : Int, l1 : Int, idl1 : Int, cc : Vector<Float>, c1 : Vector<Float>, c2 : Vector<Float>, ch : Vector<Float>, ch2 : Vector<Float>, wa : Vector<Float>, index : Int) : Void {
        var idij : Int;
        var ipph : Int = 0;
        var i : Int;
        var j : Int;
        var k : Int;
        var l : Int;
        var ik : Int;
        var is_ : Int;
        var t0 : Int = 0;
        var t1 : Int;
        var t2 : Int;
        var t3 : Int;
        var t4 : Int;
        var t5 : Int;
        var t6 : Int;
        var t7 : Int;
        var t8 : Int;
        var t9 : Int;
        var t10 : Int = 0;
        var t11 : Int;
        var t12 : Int;
        var dc2 : Float;
        var ai1 : Float;
        var ai2 : Float;
        var ar1 : Float;
        var ar2 : Float;
        var ds2 : Float;
        var nbd : Int = 0;
        var dcp : Float = 0;
        var arg : Float;
        var dsp : Float = 0;
        var ar1h : Float;
        var ar2h : Float;
        var ipp2 : Int = 0;
        var state : Int = 100;

        var _break_loop : Int = 0;
        while (true) {
            while (true) {
                var fall = false;

                if (state == 100) {
                    t10 = (ip * ido);
                    t0 = (l1 * ido);
                    arg = (Drft.tpi / ip);
                    dcp = Math.cos(arg);
                    dsp = Math.sin(arg);
                    nbd = ((ido - 1) >>> 1);
                    ipp2 = ip;
                    ipph = ((ip + 1) >>> 1);
                    if (ido < l1) {
                        state = 103;
                        break;
                    };
                    t1 = 0;
                    t2 = 0;
                    // for-while;
                    k = 0;
                    while (k < l1) {
                        t3 = t1;
                        t4 = t2;
                        // for-while;
                        i = 0;
                        while (i < ido) {
                            ch[t3] = cc[t4];
                            t3++;
                            t4++;
                            i++;
                        };
                        t1 += ido;
                        t2 += t10;
                        k++;
                    };
                    state = 106;
                    break;
                };

                if (state == 103) {
                    t1 = 0;
                    // for-while;
                    i = 0;
                    while (i < ido) {
                        t2 = t1;
                        t3 = t1;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            ch[t2] = cc[t3];
                            t2 += ido;
                            t3 += t10;
                            k++;
                        };
                        t1++;
                        i++;
                    };
                    fall = true;
                };

                if (fall || state == 106) {
                    t1 = 0;
                    t2 = (ipp2 * t0);
                    t7 = (t5 = (ido << 1));
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t0;
                        t2 -= t0;
                        t3 = t1;
                        t4 = t2;
                        t6 = t5;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            ch[t3] = (cc[t6 - 1] + cc[t6 - 1]);
                            ch[t4] = (cc[t6] + cc[t6]);
                            t3 += ido;
                            t4 += ido;
                            t6 += t10;
                            k++;
                        };
                        t5 += t7;
                        j++;
                    };
                    if (ido == 1) {
                        state = 116;
                        break;
                    };
                    if (nbd < l1) {
                        state = 112;
                        break;
                    };
                    t1 = 0;
                    t2 = (ipp2 * t0);
                    t7 = 0;
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t0;
                        t2 -= t0;
                        t3 = t1;
                        t4 = t2;
                        t7 += (ido << 1);
                        t8 = t7;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            t5 = t3;
                            t6 = t4;
                            t9 = t8;
                            t11 = t8;
                            // for-while;
                            i = 2;
                            while (i < ido) {
                                t5 += 2;
                                t6 += 2;
                                t9 += 2;
                                t11 -= 2;
                                ch[t5 - 1] = (cc[t9 - 1] + cc[t11 - 1]);
                                ch[t6 - 1] = (cc[t9 - 1] - cc[t11 - 1]);
                                ch[t5] = (cc[t9] - cc[t11]);
                                ch[t6] = (cc[t9] + cc[t11]);
                                i += 2;
                            };
                            t3 += ido;
                            t4 += ido;
                            t8 += t10;
                            k++;
                        };
                        j++;
                    };
                    state = 116;
                    break;
                };

                if (state == 112) {
                    t1 = 0;
                    t2 = (ipp2 * t0);
                    t7 = 0;
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t0;
                        t2 -= t0;
                        t3 = t1;
                        t4 = t2;
                        t7 += (ido << 1);
                        t8 = t7;
                        t9 = t7;
                        // for-while;
                        i = 2;
                        while (i < ido) {
                            t3 += 2;
                            t4 += 2;
                            t8 += 2;
                            t9 -= 2;
                            t5 = t3;
                            t6 = t4;
                            t11 = t8;
                            t12 = t9;
                            // for-while;
                            k = 0;
                            while (k < l1) {
                                ch[t5 - 1] = (cc[t11 - 1] + cc[t12 - 1]);
                                ch[t6 - 1] = (cc[t11 - 1] - cc[t12 - 1]);
                                ch[t5] = (cc[t11] - cc[t12]);
                                ch[t6] = (cc[t11] + cc[t12]);
                                t5 += ido;
                                t6 += ido;
                                t11 += t10;
                                t12 += t10;
                                k++;
                            };
                            i += 2;
                        };
                        j++;
                    };
                    fall = true;
                };

                if (fall || state == 116) {
                    ar1 = 1.;
                    ai1 = 0.;
                    t1 = 0;
                    t9 = (t2 = (ipp2 * idl1));
                    t3 = ((ip - 1) * idl1);
                    // for-while;
                    l = 1;
                    while (l < ipph) {
                        t1 += idl1;
                        t2 -= idl1;
                        ar1h = ((dcp * ar1) - (dsp * ai1));
                        ai1 = ((dcp * ai1) + (dsp * ar1));
                        ar1 = ar1h;
                        t4 = t1;
                        t5 = t2;
                        t6 = 0;
                        t7 = idl1;
                        t8 = t3;
                        // for-while;
                        ik = 0;
                        while (ik < idl1) {
                            c2[t4++] = (ch2[t6++] + (ar1 * ch2[t7++]));
                            c2[t5++] = (ai1 * ch2[t8++]);
                            ik++;
                        };
                        dc2 = ar1;
                        ds2 = ai1;
                        ar2 = ar1;
                        ai2 = ai1;
                        t6 = idl1;
                        t7 = (t9 - idl1);
                        // for-while;
                        j = 2;
                        while (j < ipph) {
                            t6 += idl1;
                            t7 -= idl1;
                            ar2h = ((dc2 * ar2) - (ds2 * ai2));
                            ai2 = ((dc2 * ai2) + (ds2 * ar2));
                            ar2 = ar2h;
                            t4 = t1;
                            t5 = t2;
                            t11 = t6;
                            t12 = t7;
                            // for-while;
                            ik = 0;
                            while (ik < idl1) {
                                // HAXE200BUG
                                // c2[t4++] += (ar2 * ch2[t11++]);
                                // c2[t5++] += (ai2 * ch2[t12++]);
                                c2[t4] += (ar2 * ch2[t11]);
                                t4++; t11++;
                                c2[t5] += (ai2 * ch2[t12]);
                                t5++; t12++;
                                ik++;
                            };
                            j++;
                        };
                        l++;
                    };
                    t1 = 0;
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += idl1;
                        t2 = t1;
                        // for-while;
                        ik = 0;
                        while (ik < idl1) {
                            ch2[ik] += ch2[t2++];
                            ik++;
                        };
                        j++;
                    };
                    t1 = 0;
                    t2 = (ipp2 * t0);
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t0;
                        t2 -= t0;
                        t3 = t1;
                        t4 = t2;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            ch[t3] = (c1[t3] - c1[t4]);
                            ch[t4] = (c1[t3] + c1[t4]);
                            t3 += ido;
                            t4 += ido;
                            k++;
                        };
                        j++;
                    };
                    if (ido == 1) {
                        state = 132;
                        break;
                    };
                    if (nbd < l1) {
                        state = 128;
                        break;
                    };
                    t1 = 0;
                    t2 = (ipp2 * t0);
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t0;
                        t2 -= t0;
                        t3 = t1;
                        t4 = t2;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            t5 = t3;
                            t6 = t4;
                            // for-while;
                            i = 2;
                            while (i < ido) {
                                t5 += 2;
                                t6 += 2;
                                ch[t5 - 1] = (c1[t5 - 1] - c1[t6]);
                                ch[t6 - 1] = (c1[t5 - 1] + c1[t6]);
                                ch[t5] = (c1[t5] + c1[t6 - 1]);
                                ch[t6] = (c1[t5] - c1[t6 - 1]);
                                i += 2;
                            };
                            t3 += ido;
                            t4 += ido;
                            k++;
                        };
                        j++;
                    };
                    state = 132;
                    break;
                };

                if (state == 128) {
                    t1 = 0;
                    t2 = (ipp2 * t0);
                    // for-while;
                    j = 1;
                    while (j < ipph) {
                        t1 += t0;
                        t2 -= t0;
                        t3 = t1;
                        t4 = t2;
                        // for-while;
                        i = 2;
                        while (i < ido) {
                            t3 += 2;
                            t4 += 2;
                            t5 = t3;
                            t6 = t4;
                            // for-while;
                            k = 0;
                            while (k < l1) {
                                ch[t5 - 1] = (c1[t5 - 1] - c1[t6]);
                                ch[t6 - 1] = (c1[t5 - 1] + c1[t6]);
                                ch[t5] = (c1[t5] + c1[t6 - 1]);
                                ch[t6] = (c1[t5] - c1[t6 - 1]);
                                t5 += ido;
                                t6 += ido;
                                k++;
                            };
                            i += 2;
                        };
                        j++;
                    };
                    fall = true;
                };

                if (fall || state == 132) {
                    if (ido == 1) {
                        return;
                    };
                    // for-while;
                    ik = 0;
                    while (ik < idl1) {
                        c2[ik] = ch2[ik];
                        ik++;
                    };
                    t1 = 0;
                    // for-while;
                    j = 1;
                    while (j < ip) {
                        t2 = (t1 += t0);
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            c1[t2] = ch[t2];
                            t2 += ido;
                            k++;
                        };
                        j++;
                    };
                    if (nbd > l1) {
                        state = 139;
                        break;
                    };
                    is_ = (-ido - 1);
                    t1 = 0;
                    // for-while;
                    j = 1;
                    while (j < ip) {
                        is_ += ido;
                        t1 += t0;
                        idij = is_;
                        t2 = t1;
                        // for-while;
                        i = 2;
                        while (i < ido) {
                            t2 += 2;
                            idij += 2;
                            t3 = t2;
                            // for-while;
                            k = 0;
                            while (k < l1) {
                                c1[t3 - 1] = ((wa[(index + idij) - 1] * ch[t3 - 1]) - (wa[index + idij] * ch[t3]));
                                c1[t3] = ((wa[(index + idij) - 1] * ch[t3]) + (wa[index + idij] * ch[t3 - 1]));
                                t3 += ido;
                                k++;
                            };
                            i += 2;
                        };
                        j++;
                    };
                    return;
                };

                if (state == 139) {
                    is_ = (-ido - 1);
                    t1 = 0;
                    // for-while;
                    j = 1;
                    while (j < ip) {
                        is_ += ido;
                        t1 += t0;
                        t2 = t1;
                        // for-while;
                        k = 0;
                        while (k < l1) {
                            idij = is_;
                            t3 = t2;
                            // for-while;
                            i = 2;
                            while (i < ido) {
                                idij += 2;
                                t3 += 2;
                                c1[t3 - 1] = ((wa[(index + idij) - 1] * ch[t3 - 1]) - (wa[index + idij] * ch[t3]));
                                c1[t3] = ((wa[(index + idij) - 1] * ch[t3]) + (wa[index + idij] * ch[t3 - 1]));
                                i += 2;
                            };
                            t2 += ido;
                            k++;
                        };
                        j++;
                    };
                    _break_loop = 1;
                    break;
                };
                break;
            };
            if (_break_loop == 1) {
                break;
            }
            else {
                _break_loop = 0;
            };
        };
    }

    // modifiers: static
    static function drftb1(n : Int, c : Vector<Float>, ch : Vector<Float>, wa : Vector<Float>, index : Int, ifac : Vector<Int>) : Void {
        var i : Int;
        var k1 : Int;
        var l1 : Int;
        var l2 : Int = 0;
        var na : Int;
        var nf : Int;
        var ip : Int = 0;
        var iw : Int;
        var ix2 : Int;
        var ix3 : Int;
        var ido : Int = 0;
        var idl1 : Int = 0;
        nf = ifac[1];
        na = 0;
        l1 = 1;
        iw = 1;
        // for-while;
        k1 = 0;
        while (k1 < nf) {
            var state : Int = 100;

            var _break_loop : Int = 1;
            while (true) {
                while (true) {
                    var fall = true;

                    if (state == 100) {
                        ip = ifac[k1 + 2];
                        l2 = (ip * l1);
                        ido = Std.int(n / l2);
                        idl1 = (ido * l1);
                        if (ip != 4) {
                            state = 103;
                            break;
                        };
                        ix2 = (iw + ido);
                        ix3 = (ix2 + ido);
                        if (na != 0) {
                            Drft.dradb4(ido, l1, ch, c, wa, (index + iw) - 1, wa, (index + ix2) - 1, wa, (index + ix3) - 1);
                        }
                        else {
                            Drft.dradb4(ido, l1, c, ch, wa, (index + iw) - 1, wa, (index + ix2) - 1, wa, (index + ix3) - 1);
                        };
                        na = (1 - na);
                        state = 115;
                        break;
                    };

                    if (state == 103) {
                        if (ip != 2) {
                            state = 106;
                            break;
                        };
                        if (na != 0) {
                            Drft.dradb2(ido, l1, ch, c, wa, (index + iw) - 1);
                        }
                        else {
                            Drft.dradb2(ido, l1, c, ch, wa, (index + iw) - 1);
                        };
                        na = (1 - na);
                        state = 115;
                        break;
                    };

                    if (state == 106) {
                        if (ip != 3) {
                            state = 109;
                            break;
                        };
                        ix2 = (iw + ido);
                        if (na != 0) {
                            Drft.dradb3(ido, l1, ch, c, wa, (index + iw) - 1, wa, (index + ix2) - 1);
                        }
                        else {
                            Drft.dradb3(ido, l1, c, ch, wa, (index + iw) - 1, wa, (index + ix2) - 1);
                        };
                        na = (1 - na);
                        state = 115;
                        break;
                    };

                    if (state == 109) {
                        if (na != 0) {
                            Drft.dradbg(ido, ip, l1, idl1, ch, ch, ch, c, c, wa, (index + iw) - 1);
                        }
                        else {
                            Drft.dradbg(ido, ip, l1, idl1, c, c, c, ch, ch, wa, (index + iw) - 1);
                        };
                        if (ido == 1) {
                            na = (1 - na);
                        };
                        fall = true;
                    };

                    if (fall || state == 115) {
                        l1 = l2;
                        iw += ((ip - 1) * ido);
                        _break_loop = 1;
                        break;
                    };
                    break;
                };
                if (_break_loop == 1) {
                    break;
                }
                else {
                    _break_loop = 0;
                };
            };
            k1++;
        };
        if (na == 0) {
            return;
        };
        // for-while;
        i = 0;
        while (i < n) {
            c[i] = ch[i];
            i++;
        };
    }

    public function new() {
    }
}
