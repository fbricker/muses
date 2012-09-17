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
import flash.Vector;

// copy & paste sucks

class VectorTools {
    public static inline function
    vectorcopy(src : Vector<Dynamic>, src_pos : Int,
               dst : Vector<Dynamic>, dst_pos : Int, length : Int) : Void
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
    vectorcopyI(src : Vector<Int>, src_pos : Int,
                dst : Vector<Int>, dst_pos : Int, length : Int) : Void
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
    vectorcopyF(src : Vector<Float>, src_pos : Int,
                dst : Vector<Float>, dst_pos : Int, length : Int) : Void
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
    copyI(src : Vector<Int>, src_pos : Int,
          dst : Vector<Int>, dst_pos : Int, length : Int) : Vector<Int>
    {
        var b : Vector<Int>;
        var src_end : Int = src_pos + length;

        if (dst_pos > 0) {
            b = dst.slice(0, dst_pos).concat(src.slice(src_pos, src_end));
        } else {
            b = src.slice(src_pos, src_end);
        }

        if (dst_pos + length < cast(dst.length,Int)) {
            b = b.concat(dst.slice(dst_pos + length));
        }

        b.fixed = dst.fixed;
        return b;
    }

    public static inline function
    copyF(src : Vector<Float>, src_pos : Int,
          dst : Vector<Float>, dst_pos : Int, length : Int) : Vector<Float>
    {
        var b : Vector<Float>;
        var src_end : Int = src_pos + length;

        if (dst_pos > 0) {
            b = dst.slice(0, dst_pos).concat(src.slice(src_pos, src_end));
        } else {
            b = src.slice(src_pos, src_end);
        }

        if (dst_pos + length < cast(dst.length,Int)) {
            b = b.concat(dst.slice(dst_pos + length));
        }

        b.fixed = dst.fixed;
        return b;
    }
}
