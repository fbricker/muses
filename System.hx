////////////////////////////////////////////////////////////////////////////////
//
//  Muses Radio Player - Radio Streaming player written in Haxe.
//
//  Copyright (C) 2009-2012  Federico Bricker
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  This Project was initially based on FOggPlayer by Bill Farmer. So 
//  my special thanks to him! :)
//
//  Federico Bricker  f bricker [at] gmail [dot] com.
//
////////////////////////////////////////////////////////////////////////////////
import org.xiph.system.Bytes;

import flash.Vector;

class System {
    /*
     * Note: modifies .position of both src and dst!
     */
    public static inline function
    bytescopy(src : Bytes, src_pos : Int,
              dst : Bytes, dst_pos : Int, length : Int) : Void {
        src.position = src_pos;
        if (src == dst && dst_pos > src_pos) {
            var tmp : Bytes = new Bytes();
            tmp.length = length;
            src.readBytes(tmp, 0, length);
            tmp.position = 0;
            tmp.readBytes(dst, dst_pos, length);
        } else {
            src.readBytes(dst, dst_pos, length);
        }
    }

    /*
     * That one, though a tiny bit faster, doesn't handle overlapping if:
     * - src and dst are the same object, and
     * - dst_pos > src_pos
     */
    public static inline function
    unsafe_bytescopy(src : Bytes, src_pos : Int,
                     dst : Bytes, dst_pos : Int, length : Int) : Void {
        src.position = src_pos;
        src.readBytes(dst, dst_pos, length);
    }


    public static inline function
    fromString(str : String) : Bytes {
        var b = new Bytes();
        b.writeUTFBytes(str);
        b.position = 0;
        return b;
    }

    public static inline function
    fromBytes(b : Bytes, start : Int, length : Int) : String {
        b.position = start;
        return b.readUTFBytes(length);
    }

    public static function
    alloc(size : Int) : Bytes {
        var b = new Bytes();
        b.length = size;
        b[size - 1] = 0;
        b.position = 0;
        return b;
    }

    public static inline function
    resize(b : Bytes, new_size : Int) : Void {
        b.length = new_size;
        // do we need to do: "b[new_size - 1] = 0" (even if only when growing)?
    }

    public static inline function
    abs(n : Int) : Int {
        return n < 0 ? -n : n;
    }

    public static inline function
    max(a : Int, b : Int) : Int {
        return a > b ? a : b;
    }

    public static function
    floatToIntBits(value : Float) : Int {
        var b : Bytes = new Bytes();
        b.writeFloat(value);
        b.position = 0;
        var i : Int = b.readInt();
        return i;
    }

    public static function
    intBitsToFloat(value : Int) : Float {
        var b : Bytes = new Bytes();
        b.writeInt(value);
        b.position = 0;
        var f : Float = b.readFloat();
        return f;
    }
}
