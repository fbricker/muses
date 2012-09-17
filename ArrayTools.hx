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

class ArrayTools {
    public static function
    alloc<T>(size : Int, ?fill = true, ?value = null) : Array<T> {
        return _alloc(size, fill, value);
    }

    public static inline function
    _alloc<T>(size : Int, fill : Bool, value : T) : Array<T> {
        var b : Array<T> = new Array<T>();
        if (fill) {
            var i : Int = 0;
            while (i < size) {
                b[i] = value;
                i++;
            }
        } else {
            b[size - 1] = value;
        }
        return b;
    }

    public static inline function
    arraycopy<T>(src : Array<T>, src_pos : Int,
                 dst : Array<T>, dst_pos : Int, length : Int) : Void
    {
        var srci : Int;
        var n : Int;
        var dsti : Int;

        if (src == dst && dst_pos > src_pos) {
            srci = src_pos + length;
            n = src_pos;
            dsti = dst_pos + length;

            while (srci > n) {
                dst[--dsti] = src[--srci];
            }
        } else {
            srci = src_pos;
            n = src_pos + length;
            dsti = dst_pos;

            while (srci < n) {
                dst[dsti++] = src[srci++];
            }
        }
    }


    public static inline function
    copy<T>(src : Array<T>, src_pos : Int,
            dst : Array<T>, dst_pos : Int, length : Int) : Array<T>
    {
        var b : Array<T>;
        var src_end : Int = src_pos + length;

        if (dst_pos > 0) {
            b = dst.slice(0, dst_pos).concat(src.slice(src_pos, src_end));
        } else {
            b = src.slice(src_pos, src_end);
        }

        if (dst_pos + length < dst.length) {
            b = b.concat(dst.slice(dst_pos + length));
        }

        return b;
    }


    /* I'm not sure why would anybody need the methods below... */

    public static function
    allocI(size : Int, ?fill = true, ?value = 0) : Array<Int> {
        return _allocI(size, fill, value);
    }

    public static inline function
    _allocI(size : Int, fill : Bool, value : Int) : Array<Int> {
        var b : Array<Int> = new Array();
        if (fill) {
            var i : Int = 0;
            while (i < size) {
                b[i] = value;
                i++;
            }
        } else {
            b[size - 1] = value;
        }
        return b;
    }

    public static function
    allocF(size : Int, ?fill = true, ?value = 0.0) : Array<Float> {
        return _allocF(size, fill, value);
    }

    public static inline function
    _allocF(size : Int, fill : Bool, value : Float) : Array<Float> {
        var b : Array<Float> = new Array();
        if (fill) {
            var i : Int = 0;
            while (i < size) {
                b[i] = value;
                i++;
            }
        } else {
            b[size - 1] = value;
        }
        return b;
    }

}
