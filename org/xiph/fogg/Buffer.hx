package org.xiph.fogg;

import org.xiph.system.Bytes;

import flash.Vector;

class Buffer {
    /*
     * generated source for Buffer
     */
    inline static private var BUFFER_INCREMENT : Int = 256;
    inline static private function _mask(): Array<Int>{
    	return  [0x00000000, 0x00000001, 0x00000003, 0x00000007,
		         0x0000000f, 0x0000001f, 0x0000003f, 0x0000007f,
		         0x000000ff, 0x000001ff, 0x000003ff, 0x000007ff,
		         0x00000fff, 0x00001fff, 0x00003fff, 0x00007fff,
		         0x0000ffff, 0x0001ffff, 0x0003ffff, 0x0007ffff,
		         0x000fffff, 0x001fffff, 0x003fffff, 0x007fffff,
		         0x00ffffff, 0x01ffffff, 0x03ffffff, 0x07ffffff,
		         0x0fffffff, 0x1fffffff, 0x3fffffff, 0x7fffffff,
		         0xffffffff];
       	}

    static private var _vmask : Vector<Int> = null;
    private var mask : Vector<Int>;

    // discarded initializer: '0';
    var ptr : Int;
    // discarded initializer: 'null';
    public var buffer : Bytes;
    // discarded initializer: '0';
    var endbit : Int;
    // discarded initializer: '0';
    var endbyte : Int;
    // discarded initializer: '0';
    var storage : Int;

    // modifiers: public
    public function writeinit() : Void {
        buffer = System.alloc(Buffer.BUFFER_INCREMENT);
        ptr = 0;
        buffer[0] = 0;
        storage = Buffer.BUFFER_INCREMENT;
    }

    // modifiers: public
    public function writeBytes(s : Bytes) : Void {
        // for-while;
        var i : UInt = 0;
        while (i < s.length) {
            if (s[i] == 0) {
                break;
            };
            write(s[i], 8);
            i++;
        };
    }

    // modifiers: public
    public function readBytes(s : Bytes, bytes : Int) : Void {
        var i : Int = 0;
        while (bytes-- != 0) {
            s[i++] = read(8);
        };
    }

    // modifiers: 
    function reset() : Void {
        ptr = 0;
        buffer[0] = 0;
        endbit = endbyte = 0;
    }

    // modifiers: public
    public function writeclear() : Void {
        buffer = null;
    }

    /*
    // modifiers: public
    public function __readinit_0(buf : Bytes, bytes : Int) : Void {
        __readinit_1(buf, 0, bytes);
    }
    */

    // modifiers: public
    public function readinit(buf : Bytes, start : Int = 0, bytes : Int) : Void {
        ptr = start;
        buffer = buf;
        endbit = endbyte = 0;
        storage = bytes;
    }

    // modifiers: public
    public function write(value : Int, bits : Int) : Void {
        if ((endbyte + 4) >= storage) {
            // var foo : Bytes = System.alloc(storage + Buffer.BUFFER_INCREMENT);
            // System.arraycopy(buffer, 0, foo, 0, storage);
            // buffer = foo;
            storage += Buffer.BUFFER_INCREMENT;
            buffer.length = storage;
        };
        value &= mask[bits];
        bits += endbit;
        buffer[ptr] |= value << endbit;

        if (bits >= 8) {
            buffer[ptr + 1] = value >>> (8 - endbit);
            if (bits >= 16) {
                buffer[ptr + 2] = value >>> (16 - endbit);
                if (bits >= 24) {
                    buffer[ptr + 3] = value >>> (24 - endbit);
                    if (bits >= 32) {
                        if (endbit > 0) {
                            buffer[ptr + 4] = value >>> (32 - endbit);
                        }
                        else {
                            buffer[ptr + 4] = 0;
                        };
                    };
                };
            };
        };
        endbyte += Std.int(bits / 8);
        ptr += Std.int(bits / 8);
        endbit = bits & 7;
    }

    // modifiers: public
    public function look(bits : Int) : Int {
        var ret : Int;
        var m : Int = mask[bits];
        bits += endbit;
        if ((endbyte + 4) >= storage) {
            if ((endbyte + ((bits - 1) / 8)) >= storage) {
                return -1;
            };
        };
        ret = ((buffer[ptr] & 0xff) >>> endbit);
        if (bits > 8) {
            ret |= ((buffer[ptr + 1] & 0xff) << (8 - endbit));
            if (bits > 16) {
                ret |= ((buffer[ptr + 2] & 0xff) << (16 - endbit));
                if (bits > 24) {
                    ret |= ((buffer[ptr + 3] & 0xff) << (24 - endbit));
                    if ((bits > 32) && (endbit != 0)) {
                        ret |= ((buffer[ptr + 4] & 0xff) << (32 - endbit));
                    };
                };
            };
        };
        return m & ret;
    }

    // modifiers: public
    public function look1() : Int {
        if (endbyte >= storage) {
            return -1;
        };
        return (buffer[ptr] >> endbit) & 1;
    }

    // modifiers: public
    public function adv(bits : Int) : Void {
        bits += endbit;
        ptr += Std.int(bits / 8);
        endbyte += Std.int(bits / 8);
        endbit = bits & 7;
    }

    // modifiers: public
    public function adv1() : Void {
        ++endbit;
        if (endbit > 7) {
            endbit = 0;
            ptr++;
            endbyte++;
        };
    }

    // modifiers: public
    public function read(bits : Int) : Int {
        var ret : Int;
        var m : Int = mask[bits];
        bits += endbit;

        if ((endbyte + 4) >= storage) {
            ret = -1;
            if ((endbyte + ((bits - 1) / 8)) >= storage) {
                ptr += Std.int(bits / 8);
                endbyte += Std.int(bits / 8);
                endbit = (bits & 7);
                return ret;
            };
        };
        ret = ((buffer[ptr] & 0xff) >>> endbit);
        if (bits > 8) {
            ret |= ((buffer[ptr + 1] & 0xff) << (8 - endbit));
            if (bits > 16) {
                ret |= ((buffer[ptr + 2] & 0xff) << (16 - endbit));
                if (bits > 24) {
                    ret |= ((buffer[ptr + 3] & 0xff) << (24 - endbit));
                    if ((bits > 32) && (endbit != 0)) {
                        ret |= ((buffer[ptr + 4] & 0xff) << (32 - endbit));
                    };
                };
            };
        };

        ret &= m;
        ptr += Std.int(bits / 8);
        endbyte += Std.int(bits / 8);
        endbit = bits & 7;
        return ret;
    }

    // modifiers: public
    public function readB(bits : Int) : Int {
        var ret : Int;
        var m : Int = 32 - bits;
        bits += endbit;
        if ((endbyte + 4) >= storage) {
            ret = -1;
            if (((endbyte * 8) + bits) > (storage * 8)) {
                ptr += Std.int(bits / 8);
                endbyte += Std.int(bits / 8);
                endbit = (bits & 7);
                return ret;
            };
        };
        ret = ((buffer[ptr] & 0xff) << (24 + endbit));
        if (bits > 8) {
            ret |= ((buffer[ptr + 1] & 0xff) << (16 + endbit));
            if (bits > 16) {
                ret |= ((buffer[ptr + 2] & 0xff) << (8 + endbit));
                if (bits > 24) {
                    ret |= ((buffer[ptr + 3] & 0xff) << endbit);
                    if ((bits > 32) && (endbit != 0)) {
                        ret |= ((buffer[ptr + 4] & 0xff) >> (8 - endbit));
                    };
                };
            };
        };
        ret = ((ret >>> (m >> 1)) >>> ((m + 1) >> 1));
        ptr += Std.int(bits / 8);
        endbyte += Std.int(bits / 8);
        endbit = (bits & 7);
        return ret;
    }

    // modifiers: public
    public function read1() : Int {
        var ret : Int;
        if (endbyte >= storage) {
            ret = -1;
            endbit++;
            if (endbit > 7) {
                endbit = 0;
                ptr++;
                endbyte++;
            };
            return ret;
        };
        ret = ((buffer[ptr] >> endbit) & 1);
        endbit++;
        if (endbit > 7) {
            endbit = 0;
            ptr++;
            endbyte++;
        };
        return ret;
    }

    // modifiers: public
    public function bytes() : Int {
        return endbyte + Std.int((endbit + 7) / 8);
    }

    // modifiers: public
    public function bits() : Int {
        return (endbyte * 8) + endbit;
    }

    // modifiers: public
    public function buffer_() : Bytes {
        // FIXME: shadows variable 'buffer';
        return buffer;
    }

    // modifiers: static,public
    static public function ilog(v : Int) : Int {
        var ret : Int = 0;
        while (v > 0) {
            ret++;
            v >>>= 1;
        };
        return ret;
    }

    // modifiers: static,public
    static public function report(in_ : String) : Void {
        //System.err.println(in_);
        trace(in_);
        //System.exit(1);
    }

    /*
    // modifiers: inline,public
    inline public function read() : Void {
        // FIXME: implement disambiguation handler;
        //   __read_0(s : Bytes, bytes : Int) : Void;
        //   __read_1(bits : Int) : Int;
        throw "NotImplementedError";
    }
    */

    /*
    // modifiers: inline,public
    inline public function readinit() : Void {
        // FIXME: implement disambiguation handler;
        //   __readinit_0(buf : Bytes, bytes : Int) : Void;
        //   __readinit_1(buf : Bytes, start : Int, bytes : Int) : Void;
        throw "NotImplementedError";
    }
    */

    /*
    // modifiers: inline,public
    inline public function write() : Void {
        // FIXME: implement disambiguation handler;
        //   __write_0(s : Bytes) : Void;
        //   __write_1(value : Int, bits : Int) : Void;
        throw "NotImplementedError";
    }
    */

    public function new() {
        mask = Buffer._vmask;
        ptr = 0;
        buffer = null;
        endbit = 0;
        endbyte = 0;
        storage = 0;
    }

    private static function __static_init__() : Void {
        var i : Int = 0;
        var n : Int = Buffer._mask().length;
        Buffer._vmask = new Vector(n, true);
        while (i < n) {
            Buffer._vmask[i] = Buffer._mask()[i];
            i++;
        }
    }

    public static function _s_init() : Void {
        if (Buffer._vmask == null) {
            __static_init__();
        }
    }

    /*
    private static function __init__() : Void {
        //__static_init__();
    }
    */
}

