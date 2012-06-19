package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;
import org.xiph.fogg.Packet;

class Comment {
    /*
     * generated source for Comment
     */
    static private var _vorbis : Bytes = System.fromString("vorbis");
    inline static private var OV_EFAULT : Int = -129;
    inline static private var OV_EIMPL : Int = -130;
    public var user_comments : Array<Bytes>;
    public var comment_lengths : Vector<Int>;
    public var comments : Int;
    public var vendor : Bytes;

    // modifiers: public
    public function init() : Void {
        user_comments = null;
        comments = 0;
        vendor = null;
    }

    // modifiers: public
    public function addString(comment : String) : Void {
        add(System.fromString(comment));
    }

    // modifiers: private
    private function add(comment : Bytes) : Void {
        // var foo : Vector<Bytes> = new Vector(comments + 2, true);
        // if (user_comments != null) {
        //     System.arraycopyV(user_comments, 0, foo, 0, comments);
        // };
        // user_comments = foo;
        if (user_comments == null)
            user_comments = ArrayTools.alloc(comments + 2);
        //else
        //    user_comments.length = comments + 2;

        //var goo : Vector<Int> = new int[comments + 2];
        // var goo : Vector<Int> = new Vector(comments + 2, true);
        // if (comment_lengths != null) {
        //     System.arraycopyV(comment_lengths, 0, goo, 0, comments);
        // };
        // comment_lengths = goo;
        if (comment_lengths == null)
            comment_lengths = new Vector(comments + 2, false);
        else
            comment_lengths.length = comments + 2;

        var bar : Bytes = System.alloc(comment.length + 1);
        System.bytescopy(comment, 0, bar, 0, comment.length);
        user_comments[comments] = bar;
        comment_lengths[comments] = comment.length;
        comments++;
        user_comments[comments] = null;
    }

    // modifiers: public
    public function add_tag(tag : String, contents : String) : Void {
        if (contents == null) {
            contents = "";
        };
        addString((tag + "=") + contents);
    }

    // modifiers: static
    static function tagcompare(s1 : Bytes, s2 : Bytes, n : Int) : Bool {
        // FIXME: don't compare char by cahr, use the language tools!
        var c : Int = 0;
        var u1 : Int;
        var u2 : Int;
        while (c < n) {
            u1 = s1[c];
            u2 = s2[c];
            if (u1 >= 'A'.charCodeAt(0)) {
                u1 = (u1 - 'A'.charCodeAt(0)) + 'a'.charCodeAt(0);
            };
            if (u2 >= 'A'.charCodeAt(0)) {
                u2 = (u2 - 'A'.charCodeAt(0)) + 'a'.charCodeAt(0);
            };
            if (u1 != u2) {
                return false;
            };
            c++;
        };
        return true;
    }

    /*
    // modifiers: public
    public function __query_0(tag : String) : String {
        return query(tag, 0);
    }
    */

    // modifiers: public
    public function query(tag : String, count : Int = 0) : String {
        var foo : Int = queryBytes(System.fromString(tag), count);
        if (foo == -1) {
            return null;
        };
        var comment : Bytes = user_comments[foo];
        // for-while;
        var i : Int = 0;
        while (i < comment_lengths[foo]) {
            if (comment[i] == '='.charCodeAt(0)) {
                //return new String(comment, i + 1, comment_lengths[foo] - (i + 1));
                comment.position = i + 1;
                return comment.readUTFBytes(comment_lengths[foo] - (i + 1));
            };
            i++;
        };
        return null;
    }

    // modifiers: private
    private function queryBytes(tag : Bytes, count : Int) : Int {
        var i : Int = 0;
        var found : Int = 0;
        var taglen : Int = tag.length;
        var fulltag : Bytes = System.alloc(taglen + 2);
        System.bytescopy(tag, 0, fulltag, 0, tag.length);
        fulltag[tag.length] = '='.charCodeAt(0);
        // for-while;
        i = 0;
        while (i < comments) {
            if (Comment.tagcompare(user_comments[i], fulltag, taglen)) {
                if (count == found) {
                    return i;
                }
                else {
                    found++;
                };
            };
            i++;
        };
        return -1;
    }

    // modifiers: 
    public function unpack(opb : Buffer) : Int {
        var vendorlen : Int = opb.read(32);
        if (vendorlen < 0) {
            clear();
            return -1;
        };
        vendor = System.alloc(vendorlen + 1);
        opb.readBytes(vendor, vendorlen);
        comments = opb.read(32);
        if (comments < 0) {
            clear();
            return -1;
        };
        //user_comments = System.alloc(comments + 1);
        //user_comments = new Vector(comments + 1, false);
        user_comments = ArrayTools.alloc(comments + 1);
        //comment_lengths = new int[comments + 1];
        comment_lengths = new Vector(comments + 1, true);

        // for-while;
        var i : Int = 0;
        while (i < comments) {
            var len : Int = opb.read(32);
            if (len < 0) {
                clear();
                return -1;
            };
            comment_lengths[i] = len;
            user_comments[i] = System.alloc(len + 1);
            opb.readBytes(user_comments[i], len);
            i++;
        };
        if (opb.read(1) != 1) {
            clear();
            return -1;
        };
        return 0;
    }

    // modifiers: 
    function pack(opb : Buffer) : Int {
        var temp : Bytes =
            System.fromString("Xiphophorus libVorbis I 20000508");
        opb.write(0x03, 8);
        opb.writeBytes(Comment._vorbis);
        opb.write(temp.length, 32);
        opb.writeBytes(temp);
        opb.write(comments, 32);
        if (comments != 0) {
            // for-while;
            var i : Int = 0;
            while (i < comments) {
                if (user_comments[i] != null) {
                    opb.write(comment_lengths[i], 32);
                    opb.writeBytes(user_comments[i]);
                }
                else {
                    opb.write(0, 32);
                };
                i++;
            };
        };
        opb.write(1, 1);
        return 0;
    }

    // modifiers: public
    public function header_out(op : Packet) : Int {
        var opb : Buffer = new Buffer();
        opb.writeinit();
        if (pack(opb) != 0) {
            return Comment.OV_EIMPL;
        };
        op.packet_base = System.alloc(opb.bytes());
        op.packet = 0;
        op.bytes = opb.bytes();
        System.bytescopy(opb.buffer, 0, op.packet_base, 0, op.bytes);
        op.b_o_s = 0;
        op.e_o_s = 0;
        op.granulepos = 0;
        return 0;
    }

    // modifiers: 
    public function clear() : Void {
        // for-while;
        var i : Int = 0;
        while (i < comments) {
            user_comments[i] = null;
            i++;
        };
        user_comments = null;
        vendor = null;
    }

    // modifiers: public
    public function getVendor() : String {
        //return String(vendor, 0, vendor.length - 1);
        vendor.position = 0;
        return vendor.readUTFBytes(vendor.length - 1);
    }

    // modifiers: public
    public function getComment(i : Int) : String {
        if (comments <= i) {
            return null;
        };
        //return String(user_comments[i], 0, user_comments[i].length - 1);
        user_comments[i].position = 0;
        return user_comments[i].readUTFBytes(user_comments[i].length - 1);
    }

    // modifiers: public
    public function toString() : String {
        vendor.position = 0;
        var foo : String =
            "Vendor: " + vendor.readUTFBytes(vendor.length - 1);
        // for-while;
        var i : Int = 0;
        while (i < comments) {
            user_comments[i].position = 0;
            foo = (foo + "\nComment: ") +
                user_comments[i].readUTFBytes(user_comments[i].length - 1);
            i++;
        };
        foo = (foo + "\n");
        return foo;
    }

    /*
    // modifiers: inline, public
    inline public function add() : Void {
        // FIXME: implement disambiguation handler;
        //   __add_0(comment : String) : Void;
        //   __add_1(comment : Bytes) : Void;
        throw "NotImplementedError";
    }
    */

    /*
    // modifiers: inline, public
    inline public function query() : String {
        // FIXME: implement disambiguation handler;
        //   __query_0(tag : String) : String;
        //   __query_1(tag : String, count : Int) : String;
        //   __query_2(tag : Bytes, count : Int) : Int;
        throw "NotImplementedError";
    }
    */

    public function new() {
    }
}

