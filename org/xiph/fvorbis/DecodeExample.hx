//#!/usr/bin/env python
//# -*- coding: utf-8 -*-


package org.xiph.fvorbis;
import org.xiph.system.Bytes;
import org.xiph.fogg.*;
class DecodeExample {
    /*
     * generated source for DecodeExample
     */
    static var convsize : Int = 4096 * 2;
    static var convbuffer : Bytes = System.alloc(convsize);

    // modifiers: static, public
    static public function main(arg : Array<String>) : Void {
        var input : ..InputStream = System.in_;
        if (arg.length > 0) {
            try {
                input = java.io.FileInputStream(arg[0]);
            }
            catch (e : Exception) {
                trace(e);
            };
        };
        var oy : SyncState = SyncState();
        var os : StreamState = StreamState();
        var og : Page = Page();
        var op : Packet = Packet();
        var vi : Info = Info();
        var vc : Comment = Comment();
        var vd : DspState = DspState();
        var vb : Block = Block(vd);
        var buffer : Bytes;
        var bytes : Int = 0;
        oy.init();
        while (true) {
            var eos : Int = 0;
            var index : Int = oy.buffer(4096);
            buffer = oy.data;
            try {
                bytes = input.read(buffer, index, 4096);
            }
            catch (e : Exception) {
                trace(e);
                System.exit(-1);
            };
            oy.wrote(bytes);
            if (oy.pageout(og) != 1) {
                if (bytes < 4096) {
                    break;
                };
                trace("Input does not appear to be an Ogg bitstream.");
                System.exit(1);
            };
            os.init(og.serialno());
            vi.init();
            vc.init();
            if (os.pagein(og) < 0) {
                trace("Error reading first page of Ogg bitstream data.");
                System.exit(1);
            };
            if (os.packetout(op) != 1) {
                trace("Error reading initial header packet.");
                System.exit(1);
            };
            if (vi.synthesis_headerin(vc, op) < 0) {
                trace("This Ogg bitstream does not contain Vorbis audio data.");
                System.exit(1);
            };
            var i : Int = 0;
            while (i < 2) {
                while (i < 2) {
                    var result : Int = oy.pageout(og);
                    if (result == 0) {
                        break;
                    };
                    if (result == 1) {
                        os.pagein(og);
                        while (i < 2) {
                            result = os.packetout(op);
                            if (result == 0) {
                                break;
                            };
                            if (result == -1) {
                                trace("Corrupt secondary header.  Exiting.");
                                System.exit(1);
                            };
                            vi.synthesis_headerin(vc, op);
                            i++;
                        };
                    };
                };
                index = oy.buffer(4096);
                buffer = oy.data;
                try {
                    bytes = input.read(buffer, index, 4096);
                }
                catch (e : Exception) {
                    trace(e);
                    System.exit(1);
                };
                if ((bytes == 0) && (i < 2)) {
                    trace("End of file before finding all Vorbis headers!");
                    System.exit(1);
                };
                oy.wrote(bytes);
            };
            var ptr : Array<Bytes> = vc.user_comments;
            // for-while;
            var j : Int = 0;
            while (j < ptr.length) {
                if (ptr[j] == null) {
                    break;
                };
                trace(String(ptr[j], 0, ptr[j].length - 1));
                j++;
            };
            trace(((("\nBitstream is " + vi.channels) + " channel, ") + vi.rate) + "Hz");
            trace(("Encoded by: " + String(vc.vendor, 0, vc.vendor.length - 1)) + "\n");
            DecodeExample.convsize = (4096 / vi.channels);
            vd.synthesis_init(vi);
            vb.init(vd);
            var _pcm : Array<Array<Array<Float>>> = new float[1];
            var _index : Array<Int> = new int[vi.channels];
            while (eos == 0) {
                while (eos == 0) {
                    var result : Int = oy.pageout(og);
                    if (result == 0) {
                        break;
                    };
                    if (result == -1) {
                        trace("Corrupt or missing data in bitstream; continuing...");
                    }
                    else {
                        os.pagein(og);
                        while (true) {
                            result = os.packetout(op);
                            if (result == 0) {
                                break;
                            };
                            if (result == -1) {
                            }
                            else {
                                var samples : Int;
                                if (vb.synthesis(op) == 0) {
                                    vd.synthesis_blockin(vb);
                                };
                                while ((samples = vd.synthesis_pcmout(_pcm, _index)) > 0) {
                                    var pcm : Array<Array<Float>> = _pcm[0];
                                    var clipflag : Bool = false;
                                    var bout : Int = (samples < DecodeExample.convsize ? samples : DecodeExample.convsize);
                                    // for-while;
                                    i = 0;
                                    while (i < vi.channels) {
                                        var ptr : Int = i * 2;
                                        var mono : Int = _index[i];
                                        // for-while;
                                        var j : Int = 0;
                                        while (j < bout) {
                                            var val : Int = pcm[i][mono + j] * 32767.;
                                            if (val > 32767) {
                                                val = 32767;
                                                clipflag = true;
                                            };
                                            if (val < -32768) {
                                                val = -32768;
                                                clipflag = true;
                                            };
                                            if (val < 0) {
                                                val = (val | 0x8000);
                                            };
                                            DecodeExample.convbuffer[ptr] = val;
                                            DecodeExample.convbuffer[ptr + 1] = val >>> 8;
                                            ptr += (2 * vi.channels);
                                            j++;
                                        };
                                        i++;
                                    };
                                    System.out.write(DecodeExample.convbuffer, 0, (2 * vi.channels) * bout);
                                    vd.synthesis_read(bout);
                                };
                            };
                        };
                        if (og.eos() != 0) {
                            eos = 1;
                        };
                    };
                };
                if (eos == 0) {
                    index = oy.buffer(4096);
                    buffer = oy.data;
                    try {
                        bytes = input.read(buffer, index, 4096);
                    }
                    catch (e : Exception) {
                        trace(e);
                        System.exit(1);
                    };
                    oy.wrote(bytes);
                    if (bytes == 0) {
                        eos = 1;
                    };
                };
            };
            os.clear();
            vb.clear();
            vd.clear();
            vi.clear();
        };
        oy.clear();
        trace("Done.");
    }

}

