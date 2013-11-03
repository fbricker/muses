package org.xiph.fogg;

import org.xiph.system.Bytes;

import flash.Vector;

class StreamState {
    /*
     * generated source for StreamState
     */
    var body_data : Bytes;
    var body_storage : Int;
    var body_fill : Int;
    private var body_returned : Int;
    var lacing_vals : Vector<Int>;
    var granule_vals : Vector<Int>;
    var lacing_storage : Int;
    var lacing_fill : Int;
    var lacing_packet : Int;
    var lacing_returned : Int;
    // discarded initializer: 'Bytes.alloc(282)';
    var header : Bytes;
    var header_fill : Int;
    public var e_o_s : Int;
    var b_o_s : Int;
    var serialno : Int;
    var pageno : Int;
    var packetno : Int;
    var granulepos : Int;

    // modifiers: public
    public function __new_0() {
        init();
    }

    // modifiers: 
    function __new_1(serialno : Int) {
        this.__new_0();
        __init_1(serialno);
    }

    // modifiers: 
    function __init_0() : Void {
        header = System.alloc(282);
        body_storage = (16 * 1024);
        body_data = System.alloc(body_storage);
        lacing_storage = 1024;
        lacing_vals = new Vector(lacing_storage); //int[lacing_storage];
        granule_vals = new Vector(lacing_storage); //long[lacing_storage];
    }

    // modifiers: public
    public function __init_1(serialno : Int) : Void {
        if (body_data == null) {
            __init_0();
        }
        else {
            // for-while;
            var i : UInt = 0;
            while (i < body_data.length) {
                body_data[i] = 0;
                i++;
            };
            // for-while;
            var i : Int = 0;
            while (i < lacing_vals.length) {
                lacing_vals[i] = 0;
                i++;
            };
            // for-while;
            var i : Int = 0;
            while (i < granule_vals.length) {
                granule_vals[i] = 0;
                i++;
            };
        };
        this.serialno = serialno;
    }

    // modifiers: public
    public function clear() : Void {
        body_data = null;
        lacing_vals = null;
        granule_vals = null;
    }

    // modifiers: 
    function destroy() : Void {
        clear();
    }

    // modifiers: 
    function body_expand(needed : Int) : Void {
        if (body_storage <= (body_fill + needed)) {
            body_storage += (needed + 1024);
            // var foo : Bytes = System.alloc(body_storage);
            // System.arraycopy(body_data, 0, foo, 0, body_data.length);
            // body_data = foo;
            System.resize(body_data, body_storage);
        };
    }

    // modifiers: 
    function lacing_expand(needed : Int) : Void {
        if (lacing_storage <= (lacing_fill + needed)) {
            lacing_storage += (needed + 32);
            //var foo : Array<Int> = new Array(); //int[lacing_storage];
            //System.arraycopy(lacing_vals, 0, foo, 0, lacing_vals.length);
            //lacing_vals[lacing_storage-1] = 0;
            lacing_vals.length = lacing_storage;
            //var bar : Array<Int> = new Array(); //long[lacing_storage];
            //System.arraycopy(granule_vals, 0, bar, 0, granule_vals.length);
            //granule_vals[lacing_storage-1] = 0;
            granule_vals.length = lacing_storage;
        };
    }

    // modifiers: public
    public function packetin(op : Packet) : Int {
        var lacing_val : Int = Std.int(op.bytes / 255) + 1;
        if (body_returned != 0) {
            body_fill -= body_returned;
            if (body_fill != 0) {
                System.bytescopy(body_data, body_returned, body_data, 0, body_fill);
            };
            body_returned = 0;
        };
        body_expand(op.bytes);
        lacing_expand(lacing_val);
        System.bytescopy(op.packet_base, op.packet, body_data, body_fill, op.bytes);
        body_fill += op.bytes;
        var j : Int;
        // for-while;
        j = 0;
        while (j < (lacing_val - 1)) {
            lacing_vals[lacing_fill + j] = 255;
            granule_vals[lacing_fill + j] = granulepos;
            j++;
        };
        lacing_vals[lacing_fill + j] = (op.bytes % 255);
        granulepos = (granule_vals[lacing_fill + j] = op.granulepos);
        lacing_vals[lacing_fill] |= 0x100;
        lacing_fill += lacing_val;
        packetno++;
        if (op.e_o_s != 0) {
            e_o_s = 1;
        };
        return 0;
    }

    // modifiers: public
    public function packetout(op : Packet) : Int {
        var ptr : Int = lacing_returned;
        if (lacing_packet <= ptr) {
            return 0;
        };
        if ((lacing_vals[ptr] & 0x400) != 0) {
            lacing_returned++;
            packetno++;
            return -1;
        };
        var size : Int = lacing_vals[ptr] & 0xff;
        var bytes : Int = 0;
        op.packet_base = body_data;
        op.packet = body_returned;
        op.e_o_s = (lacing_vals[ptr] & 0x200);
        op.b_o_s = (lacing_vals[ptr] & 0x100);
        bytes += size;
        while (size == 255) {
            var val : Int = lacing_vals[++ptr];
            size = (val & 0xff);
            if ((val & 0x200) != 0) {
                op.e_o_s = 0x200;
            };
            bytes += size;
        };
        op.packetno = packetno;
        op.granulepos = granule_vals[ptr];
        op.bytes = bytes;
        body_returned += bytes;
        lacing_returned = (ptr + 1);
        packetno++;
        return 1;
    }

    // modifiers: public
    public function pagein(og : Page) : Int {
        var header_base : Bytes = og.header_base;
        var header : Int = og.header;
        var body_base : Bytes = og.body_base;
        var body : Int = og.body;
        var bodysize : Int = og.body_len;
        var segptr : Int = 0;
        var version : Int = og.version();
        var continued : Int = og.continued();
        var bos : Int = og.bos();
        var eos : Int = og.eos();
        var granulepos : Int = og.granulepos();
        var _serialno : Int = og.serialno();
        var _pageno : Int = og.pageno();
        var segments : Int = header_base[header + 26] & 0xff;
        var lr : Int = lacing_returned;
        var br : Int = body_returned;
        if (br != 0) {
            body_fill -= br;
            if (body_fill != 0) {
                System.bytescopy(body_data, br, body_data, 0, body_fill);
            };
            body_returned = 0;
        };
        if (lr != 0) {
            if ((lacing_fill - lr) != 0) {
                //System.arraycopyV(lacing_vals, lr, lacing_vals, 0,
                //                  lacing_fill - lr);
                lacing_vals = VectorTools.copyI(lacing_vals, lr,
                                                lacing_vals, 0,
                                                lacing_fill - lr);
                //System.arraycopyV(granule_vals, lr, granule_vals, 0,
                //                  lacing_fill - lr);
                granule_vals = VectorTools.copyI(granule_vals, lr,
                                                 granule_vals, 0,
                                                 lacing_fill - lr);
            };
            lacing_fill -= lr;
            lacing_packet -= lr;
            lacing_returned = 0;
        };
        if (_serialno != serialno) {
            return -1;
        };
        if (version > 0) {
            return -1;
        };
        lacing_expand(segments + 1);
        if (_pageno != pageno) {
            var i : Int;
            // for-while;
            i = lacing_packet;
            while (i < lacing_fill) {
                body_fill -= (lacing_vals[i] & 0xff);
                i++;
            };
            lacing_fill = lacing_packet;
            if (pageno != -1) {
                lacing_vals[lacing_fill++] = 0x400;
                lacing_packet++;
            };
            if (continued != 0) {
                bos = 0;
                // for-while;
                while (segptr < segments) {
                    var val : Int = header_base[(header + 27) + segptr] & 0xff;
                    body += val;
                    bodysize -= val;
                    if (val < 255) {
                        segptr++;
                        break;
                    };
                    segptr++;
                };
            };
        };
        if (bodysize != 0) {
            body_expand(bodysize);
            System.bytescopy(body_base, body, body_data, body_fill, bodysize);
            body_fill += bodysize;
        };
        var saved : Int = -1;
        while (segptr < segments) {
            var val : Int = header_base[(header + 27) + segptr] & 0xff;
            lacing_vals[lacing_fill] = val;
            granule_vals[lacing_fill] = -1;
            if (bos != 0) {
                lacing_vals[lacing_fill] |= 0x100;
                bos = 0;
            };
            if (val < 255) {
                saved = lacing_fill;
            };
            lacing_fill++;
            segptr++;
            if (val < 255) {
                lacing_packet = lacing_fill;
            };
        };
        if (saved != -1) {
            granule_vals[saved] = granulepos;
        };
        if (eos != 0) {
            e_o_s = 1;
            if (lacing_fill > 0) {
                lacing_vals[lacing_fill - 1] |= 0x200;
            };
        };
        pageno = (_pageno + 1);
        return 0;
    }

    // modifiers: public
    public function flush(og : Page) : Int {
        var i : Int;
        var vals : Int = 0;
        var maxvals : Int = (lacing_fill > 255 ? 255 : lacing_fill);
        var bytes : Int = 0;
        var acc : Int = 0;
        var granule_pos : Int = granule_vals[0];
        if (maxvals == 0) {
            return 0;
        };
        if (b_o_s == 0) {
            granule_pos = 0;
            // for-while;
            vals = 0;
            while (vals < maxvals) {
                if ((lacing_vals[vals] & 0x0ff) < 255) {
                    vals++;
                    break;
                };
                vals++;
            };
        }
        else {
            // for-while;
            vals = 0;
            while (vals < maxvals) {
                if (acc > 4096) {
                    break;
                };
                acc += (lacing_vals[vals] & 0x0ff);
                granule_pos = granule_vals[vals];
                vals++;
            };
        };
        System.bytescopy(haxe.io.Bytes.ofString("OggS").getData(), 0, header, 0, 4);
        header[4] = 0x00;
        header[5] = 0x00;
        if ((lacing_vals[0] & 0x100) == 0) {
            header[5] |= 0x01;
        };
        if (b_o_s == 0) {
            header[5] |= 0x02;
        };
        if ((e_o_s != 0) && (lacing_fill == vals)) {
            header[5] |= 0x04;
        };
        b_o_s = 1;
        // for-while;
        i = 6;
        while (i < 14) {
            header[i] = granule_pos;
            granule_pos >>>= 8;
            i++;
        };
        var _serialno : Int = serialno;
        // for-while;
        i = 14;
        while (i < 18) {
            header[i] = _serialno;
            _serialno >>>= 8;
            i++;
        };
        if (pageno == -1) {
            pageno = 0;
        };
        var _pageno : Int = pageno++;
        // for-while;
        i = 18;
        while (i < 22) {
            header[i] = _pageno;
            _pageno >>>= 8;
            i++;
        };
        header[22] = 0;
        header[23] = 0;
        header[24] = 0;
        header[25] = 0;
        header[26] = vals;
        // for-while;
        i = 0;
        while (i < vals) {
            header[i + 27] = lacing_vals[i];
            bytes += (header[i + 27] & 0xff);
            i++;
        };
        og.header_base = header;
        og.header = 0;
        og.header_len = (header_fill = (vals + 27));
        og.body_base = body_data;
        og.body = body_returned;
        og.body_len = bytes;
        lacing_fill -= vals;
        //System.arraycopyV(lacing_vals, vals, lacing_vals, 0, lacing_fill * 4);
        lacing_vals = VectorTools.copyI(lacing_vals, vals, lacing_vals, 0,
                                        lacing_fill * 4);
        //System.arraycopyV(granule_vals, vals, granule_vals, 0, lacing_fill * 8);
        granule_vals = VectorTools.copyI(granule_vals, vals, granule_vals, 0,
                                         lacing_fill * 8);
        body_returned += bytes;
        og.checksum();
        return 1;
    }

    // modifiers: public
    public function pageout(og : Page) : Int {
        if (((((e_o_s != 0) && (lacing_fill != 0)) || ((body_fill - body_returned) > 4096)) || (lacing_fill >= 255)) || ((lacing_fill != 0) && (b_o_s == 0))) {
            return flush(og);
        };
        return 0;
    }

    // modifiers: public
    public function eof() : Int {
        return e_o_s;
    }

    // modifiers: public
    public function reset() : Int {
        body_fill = 0;
        body_returned = 0;
        lacing_fill = 0;
        lacing_packet = 0;
        lacing_returned = 0;
        header_fill = 0;
        e_o_s = 0;
        b_o_s = 0;
        pageno = -1;
        packetno = 0;
        granulepos = 0;
        return 0;
    }

    // modifiers: inline
    public function init(?serialno : Int) : Void {
        // FIXME: implement disambiguation handler;
        //   __init_0() : Void;
        //   __init_1(serialno : Int) : Void;
        //throw "NotImplementedError";
        if (serialno == null)
            __init_0();
        else
            __init_1(serialno);
    }

    // modifiers: inline,public
    public function new(?serialno : Int) {
        // FIXME: implement disambiguation handler;
        //   __new_0() : None;
        //   __new_1(serialno : Int) : None;
        //throw "NotImplementedError";
        if (serialno == null)
            __new_0();
        else
            __new_1(serialno);
    }

}

