package org.xiph.fogg;

import org.xiph.system.Bytes;

import flash.Vector;

class Page {
    /*
     * generated source for Page
     */
    static private var crc_lookup : Vector<Int>;

    // modifiers: static
    static function __static_init__() {
        // for-while;
        var i : Int = 0;
        crc_lookup = new Vector(256, true);
        while (i < 256) {
            crc_lookup[i] = crc_entry(i);
            i++;
        };
    }

    // modifiers: static,private
    static private function crc_entry(index : Int) : Int {
        var r : Int = index << 24;
        // for-while;
        var i : Int = 0;
        while (i < 8) {
            if ((r & 0x80000000) != 0) {
                r = ((r << 1) ^ 0x04c11db7);
            }
            else {
                r <<= 1;
            };
            i++;
        };
        return r & 0xffffffff;
    }

    public var header_base : Bytes;
    public var header : Int;
    public var header_len : Int;
    public var body_base : Bytes;
    public var body : Int;
    public var body_len : Int;

    // modifiers: 
    public function version() : Int {
        return header_base[header + 4] & 0xff;
    }

    // modifiers: 
    public function continued() : Int {
        return header_base[header + 5] & 0x01;
    }

    // modifiers: public
    public function bos() : Int {
        return header_base[header + 5] & 0x02;
    }

    // modifiers: public
    public function eos() : Int {
        return header_base[header + 5] & 0x04;
    }

    // modifiers: public
    public function granulepos() : Int {
        var foo : Int = header_base[header + 13] & 0xff;
        foo = ((foo << 8) | (header_base[header + 12] & 0xff));
        foo = ((foo << 8) | (header_base[header + 11] & 0xff));
        foo = ((foo << 8) | (header_base[header + 10] & 0xff));
        foo = ((foo << 8) | (header_base[header + 9] & 0xff));
        foo = ((foo << 8) | (header_base[header + 8] & 0xff));
        foo = ((foo << 8) | (header_base[header + 7] & 0xff));
        foo = ((foo << 8) | (header_base[header + 6] & 0xff));
        return foo;
    }

    // modifiers: public
    public function serialno() : Int {
        return (((header_base[header + 14] & 0xff) | ((header_base[header + 15] & 0xff) << 8)) | ((header_base[header + 16] & 0xff) << 16)) | ((header_base[header + 17] & 0xff) << 24);
    }

    // modifiers: 
    public function pageno() : Int {
        return (((header_base[header + 18] & 0xff) | ((header_base[header + 19] & 0xff) << 8)) | ((header_base[header + 20] & 0xff) << 16)) | ((header_base[header + 21] & 0xff) << 24);
    }

    // modifiers: 
    public function checksum() : Void {
        var crc_reg : Int = 0;
        // for-while;
        var i : Int = 0;
        while (i < header_len) {
            crc_reg = ((crc_reg << 8) ^ Page.crc_lookup[((crc_reg >>> 24) & 0xff) ^ (header_base[header + i] & 0xff)]);
            i++;
        };
        // for-while;
        var i : Int = 0;
        while (i < body_len) {
            crc_reg = ((crc_reg << 8) ^ Page.crc_lookup[((crc_reg >>> 24) & 0xff) ^ (body_base[body + i] & 0xff)]);
            i++;
        };
        header_base[header + 22] = crc_reg;
        header_base[header + 23] = crc_reg >>> 8;
        header_base[header + 24] = crc_reg >>> 16;
        header_base[header + 25] = crc_reg >>> 24;
    }

    public function new() {
        header_base = null;
        header = 0;
        header_len = 0;
        body_base = null;
        body = 0;
        body_len = 0;
    }

    private static function __init__() : Void untyped {
        __static_init__();
    }
}


