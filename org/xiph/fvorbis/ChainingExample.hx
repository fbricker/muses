//#!/usr/bin/env python
//# -*- coding: utf-8 -*-


package org.xiph.fvorbis;
import org.xiph.system.Bytes;
class ChainingExample {
    /*
     * generated source for ChainingExample
     */

    // modifiers: static, public
    static public function main(arg : Array<String>) : Void {
        var ov : VorbisFile = null;
        try {
            ov = VorbisFile(System.in_, null, -1);
        }
        catch (e : Exception) {
            trace(e);
            return;
        };
        if (ov.seekable()) {
            print ("Input bitstream contained " + ov.streams() + " logical bitstream section(s).");
            print ("Total bitstream playing time: " + ov.time_total(-1) + " seconds\n");
        }
        else {
            print "Standard input was not seekable.";
            print "First logical bitstream information:\n";
        };
        // for-while;
        var i : Int = 0;
        while (i < ov.streams()) {
            var vi : Info = ov.getInfo(i);
            print ("\tlogical bitstream section " + (i + 1) + " information:");
            print (((((("\t\t" + vi.rate + "Hz ") + vi.channels) + " channels bitrate ") + (ov.bitrate(i) / 1000)) + "kbps serial number=") + ov.serialnumber(i));
            System.out.print_(("\t\tcompressed length: " + ov.raw_total(i)) + " bytes ");
            print (" play time: " + ov.time_total(i) + "s");
            var vc : Comment = ov.getComment(i);
            print vc;
            i++;
        };
    }

}

