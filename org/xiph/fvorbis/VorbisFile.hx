//#!/usr/bin/env python
//# -*- coding: utf-8 -*-


package org.xiph.fvorbis;
import org.xiph.system.Bytes;
import org.xiph.fogg.*;
import java.io.*;
class VorbisFile {
    /*
     * generated source for VorbisFile
     */
    inline static var CHUNKSIZE : Int = 8500;
    inline static var SEEK_SET : Int = 0;
    inline static var SEEK_CUR : Int = 1;
    inline static var SEEK_END : Int = 2;
    inline static var OV_FALSE : Int = -1;
    inline static var OV_EOF : Int = -2;
    inline static var OV_HOLE : Int = -3;
    inline static var OV_EREAD : Int = -128;
    inline static var OV_EFAULT : Int = -129;
    inline static var OV_EIMPL : Int = -130;
    inline static var OV_EINVAL : Int = -131;
    inline static var OV_ENOTVORBIS : Int = -132;
    inline static var OV_EBADHEADER : Int = -133;
    inline static var OV_EVERSION : Int = -134;
    inline static var OV_ENOTAUDIO : Int = -135;
    inline static var OV_EBADPACKET : Int = -136;
    inline static var OV_EBADLINK : Int = -137;
    inline static var OV_ENOSEEK : Int = -138;
    var datasource : InputStream;
    // discarded initializer: 'false';
    var seekable : Bool;
    var offset : Int;
    var end : Int;
    // discarded initializer: 'SyncState()';
    var oy : SyncState;
    var links : Int;
    var offsets : Array<long>;
    var dataoffsets : Array<long>;
    var serialnos : Array<Int>;
    var pcmlengths : Array<long>;
    var vi : Array<Info>;
    var vc : Array<Comment>;
    var pcm_offset : Int;
    // discarded initializer: 'false';
    var decode_ready : Bool;
    var current_serialno : Int;
    var current_link : Int;
    var bittrack : Float;
    var samptrack : Float;
    // discarded initializer: 'StreamState()';
    var os : StreamState;
    // discarded initializer: 'DspState()';
    var vd : DspState;
    // discarded initializer: 'Block(vd)';
    var vb : Block;

    // modifiers: public, throws JOrbisException
    public throws JOrbisException function __new_0(file : String) {
        super();
        if {
        };
        var is_ : InputStream = null;
        try {
            is_ = SeekableInputStream(file);
        }
        catch (e : Exception) {
            raise JOrbisException("VorbisFile: " + str(e));
        };
        var ret : Int = open(is_, null, 0);
        if (ret == -1) {
            raise JOrbisException("VorbisFile: open return -1");
        };
    }

    // modifiers: public, throws JOrbisException
    public throws JOrbisException function __new_1(is_ : InputStream, initial : Bytes, ibytes : Int) {
        super();
        if {
        };
        var ret : Int = open(is_, initial, ibytes);
        if (ret == -1) {
        };
    }

    // modifiers: private
    private function get_data() : Int {
        var index : Int = oy.buffer(VorbisFile.CHUNKSIZE);
        var buffer : Bytes = oy.data;
        var bytes : Int = 0;
        try {
            bytes = datasource.read(buffer, index, VorbisFile.CHUNKSIZE);
        }
        catch (e : Exception) {
            trace(e);
            return VorbisFile.OV_EREAD;
        };
        oy.wrote(bytes);
        if (bytes == -1) {
            bytes = 0;
        };
        return bytes;
    }

    // modifiers: private
    private function seek_helper(offst : Int) : Void {
        VorbisFile.fseek(datasource, offst, VorbisFile.SEEK_SET);
        this.offset = offst;
        oy.reset();
    }

    // modifiers: private
    private function get_next_page(page : Page, boundary : Int) : Int {
        if (boundary > 0) {
            boundary += offset;
        };
        while (true) {
            var more : Int;
            if ((boundary > 0) && (offset >= boundary)) {
                return VorbisFile.OV_FALSE;
            };
            more = oy.pageseek(page);
            if (more < 0) {
                offset -= more;
            }
            else {
                if (more == 0) {
                    if (boundary == 0) {
                        return VorbisFile.OV_FALSE;
                    };
                    var ret : Int = get_data();
                    if (ret == 0) {
                        return VorbisFile.OV_EOF;
                    };
                    if (ret < 0) {
                        return VorbisFile.OV_EREAD;
                    };
                }
                else {
                    var ret : Int = offset;
                    offset += more;
                    return ret;
                };
            };
        };
    }

    // modifiers: private
    private function get_prev_page(page : Page) : Int {
        var begin : Int = offset;
        var ret : Int;
        var offst : Int = -1;
        while (offst == -1) {
            begin -= VorbisFile.CHUNKSIZE;
            if (begin < 0) {
                begin = 0;
            };
            seek_helper(begin);
            while (offset < (begin + VorbisFile.CHUNKSIZE)) {
                ret = get_next_page(page, (begin + VorbisFile.CHUNKSIZE) - offset);
                if (ret == VorbisFile.OV_EREAD) {
                    return VorbisFile.OV_EREAD;
                };
                if (ret < 0) {
                    break;
                }
                else {
                    offst = ret;
                };
            };
        };
        seek_helper(offst);
        ret = get_next_page(page, VorbisFile.CHUNKSIZE);
        if (ret < 0) {
            return VorbisFile.OV_EFAULT;
        };
        return offst;
    }

    // modifiers: 
    function bisect_forward_serialno(begin : Int, searched : Int, end : Int, currentno : Int, m : Int) : Int {
        var endsearched : Int = end;
        var next : Int = end;
        var page : Page = Page();
        var ret : Int;
        while (searched < endsearched) {
            var bisect : Int;
            if ((endsearched - searched) < VorbisFile.CHUNKSIZE) {
                bisect = searched;
            }
            else {
                bisect = ((searched + endsearched) / 2);
            };
            seek_helper(bisect);
            ret = get_next_page(page, -1);
            if (ret == VorbisFile.OV_EREAD) {
                return VorbisFile.OV_EREAD;
            };
            if ((ret < 0) || (page.serialno() != currentno)) {
                endsearched = bisect;
                if (ret >= 0) {
                    next = ret;
                };
            }
            else {
                searched = ((ret + page.header_len) + page.body_len);
            };
        };
        seek_helper(next);
        ret = get_next_page(page, -1);
        if (ret == VorbisFile.OV_EREAD) {
            return VorbisFile.OV_EREAD;
        };
        if ((searched >= end) || (ret == -1)) {
            links = (m + 1);
            offsets = new long[m + 2];
            offsets[m + 1] = searched;
        }
        else {
            ret = bisect_forward_serialno(next, offset, end, page.serialno(), m + 1);
            if (ret == VorbisFile.OV_EREAD) {
                return VorbisFile.OV_EREAD;
            };
        };
        offsets[m] = begin;
        return 0;
    }

    // modifiers: 
    function fetch_headers(vi : Info, vc : Comment, serialno : Array<Int>, og_ptr : Page) : Int {
        var og : Page = Page();
        var op : Packet = Packet();
        var ret : Int;
        if (og_ptr == null) {
            ret = get_next_page(og, VorbisFile.CHUNKSIZE);
            if (ret == VorbisFile.OV_EREAD) {
                return VorbisFile.OV_EREAD;
            };
            if (ret < 0) {
                return VorbisFile.OV_ENOTVORBIS;
            };
            og_ptr = og;
        };
        if (serialno != null) {
            serialno[0] = og_ptr.serialno();
        };
        os.init(og_ptr.serialno());
        vi.init();
        vc.init();
        var i : Int = 0;
        while (i < 3) {
            os.pagein(og_ptr);
            while (i < 3) {
                var result : Int = os.packetout(op);
                if (result == 0) {
                    break;
                };
                if (result == -1) {
                    trace("Corrupt header in logical bitstream.");
                    vi.clear();
                    vc.clear();
                    os.clear();
                    return -1;
                };
                if (vi.synthesis_headerin(vc, op) != 0) {
                    trace("Illegal header in logical bitstream.");
                    vi.clear();
                    vc.clear();
                    os.clear();
                    return -1;
                };
                i++;
            };
            if (i < 3) {
                if (get_next_page(og_ptr, 1) < 0) {
                    trace("Missing header in logical bitstream.");
                    vi.clear();
                    vc.clear();
                    os.clear();
                    return -1;
                };
            };
        };
        return 0;
    }

    // modifiers: 
    function prefetch_all_headers(first_i : Info, first_c : Comment, dataoffset : Int) : Void {
        var og : Page = Page();
        var ret : Int;
        vi = new Info[links];
        vc = new Comment[links];
        dataoffsets = new long[links];
        pcmlengths = new long[links];
        serialnos = new int[links];
        // for-while;
        var i : Int = 0;
        while (i < links) {
            if (((first_i != null) && (first_c != null)) && (i == 0)) {
                vi[i] = first_i;
                vc[i] = first_c;
                dataoffsets[i] = dataoffset;
            }
            else {
                seek_helper(offsets[i]);
                if (fetch_headers(vi[i], vc[i], null, null) == -1) {
                    trace(("Error opening logical bitstream #" + (i + 1)) + "\n");
                    dataoffsets[i] = -1;
                }
                else {
                    dataoffsets[i] = offset;
                    os.clear();
                };
            };
            var end : Int = offsets[i + 1];
            seek_helper(end);
            while (true) {
                ret = get_prev_page(og);
                if (ret == -1) {
                    trace((("Could not find last page of logical " + "bitstream #") + i) + "\n");
                    vi[i].clear();
                    vc[i].clear();
                    break;
                };
                if (og.granulepos() != -1) {
                    serialnos[i] = og.serialno();
                    pcmlengths[i] = og.granulepos();
                    break;
                };
            };
            i++;
        };
    }

    // modifiers: 
    function make_decode_ready() : Int {
        if (decode_ready) {
            System.exit(1);
        };
        vd.synthesis_init(vi[0]);
        vb.init(vd);
        decode_ready = true;
        return 0;
    }

    // modifiers: 
    function open_seekable() : Int {
        var initial_i : Info = Info();
        var initial_c : Comment = Comment();
        var serialno : Int;
        var end : Int;
        var ret : Int;
        var dataoffset : Int;
        var og : Page = Page();
        var foo : Array<Int> = new int[1];
        ret = fetch_headers(initial_i, initial_c, foo, null);
        serialno = foo[0];
        dataoffset = offset;
        os.clear();
        if (ret == -1) {
            return -1;
        };
        seekable = true;
        VorbisFile.fseek(datasource, 0, VorbisFile.SEEK_END);
        offset = VorbisFile.ftell(datasource);
        end = offset;
        end = get_prev_page(og);
        if (og.serialno() != serialno) {
            if (bisect_forward_serialno(0, 0, end + 1, serialno, 0) < 0) {
                clear();
                return VorbisFile.OV_EREAD;
            };
        }
        else {
            if (bisect_forward_serialno(0, end, end + 1, serialno, 0) < 0) {
                clear();
                return VorbisFile.OV_EREAD;
            };
        };
        prefetch_all_headers(initial_i, initial_c, dataoffset);
        return raw_seek(0);
    }

    // modifiers: 
    function open_nonseekable() : Int {
        links = 1;
        vi = new Info[links];
        vi[0] = Info();
        vc = new Comment[links];
        vc[0] = Comment();
        var foo : Array<Int> = new int[1];
        if (fetch_headers(vi[0], vc[0], foo, null) == -1) {
            return -1;
        };
        current_serialno = foo[0];
        make_decode_ready();
        return 0;
    }

    // modifiers: 
    function decode_clear() : Void {
        os.clear();
        vd.clear();
        vb.clear();
        decode_ready = false;
        bittrack = 0.;
        samptrack = 0.;
    }

    // modifiers: 
    function process_packet(readp : Int) : Int {
        var og : Page = Page();
        while (true) {
            if (decode_ready) {
                var op : Packet = Packet();
                var result : Int = os.packetout(op);
                var granulepos : Int;
                if (result > 0) {
                    granulepos = op.granulepos;
                    if (vb.synthesis(op) == 0) {
                        var oldsamples : Int = vd.synthesis_pcmout(null, null);
                        vd.synthesis_blockin(vb);
                        samptrack += (vd.synthesis_pcmout(null, null) - oldsamples);
                        bittrack += (op.bytes * 8);
                        if ((granulepos != -1) && (op.e_o_s == 0)) {
                            var link : Int = (seekable ? current_link : 0);
                            var samples : Int;
                            samples = vd.synthesis_pcmout(null, null);
                            granulepos -= samples;
                            // for-while;
                            var i : Int = 0;
                            while (i < link) {
                                granulepos += pcmlengths[i];
                                i++;
                            };
                            pcm_offset = granulepos;
                        };
                        return 1;
                    };
                };
            };
            if (readp == 0) {
                return 0;
            };
            if (get_next_page(og, -1) < 0) {
                return 0;
            };
            bittrack += (og.header_len * 8);
            if (decode_ready) {
                if (current_serialno != og.serialno()) {
                    decode_clear();
                };
            };
            if (!decode_ready) {
                var i : Int;
                if (seekable) {
                    current_serialno = og.serialno();
                    // for-while;
                    i = 0;
                    while (i < links) {
                        if (serialnos[i] == current_serialno) {
                            break;
                        };
                        i++;
                    };
                    if (i == links) {
                        return -1;
                    };
                    current_link = i;
                    os.init(current_serialno);
                    os.reset();
                }
                else {
                    var foo : Array<Int> = new int[1];
                    var ret : Int = fetch_headers(vi[0], vc[0], foo, og);
                    current_serialno = foo[0];
                    if (ret != 0) {
                        return ret;
                    };
                    current_link++;
                    i = 0;
                };
                make_decode_ready();
            };
            os.pagein(og);
        };
    }

    // modifiers: 
    function clear() : Int {
        vb.clear();
        vd.clear();
        os.clear();
        if ((vi != null) && (links != 0)) {
            // for-while;
            var i : Int = 0;
            while (i < links) {
                vi[i].clear();
                vc[i].clear();
                i++;
            };
            vi = null;
            vc = null;
        };
        if (dataoffsets != null) {
            dataoffsets = null;
        };
        if (pcmlengths != null) {
            pcmlengths = null;
        };
        if (serialnos != null) {
            serialnos = null;
        };
        if (offsets != null) {
            offsets = null;
        };
        oy.clear();
        return 0;
    }

    // modifiers: static
    static function fseek(fis : InputStream, off : Int, whence : Int) : Int {
        if (isinstance(fis, (SeekableInputStream))) {
            var sis : SeekableInputStream = fis;
            try {
                if (whence == VorbisFile.SEEK_SET) {
                    sis.seek(off);
                }
                else {
                    if (whence == VorbisFile.SEEK_END) {
                        sis.seek(sis.getLength() - off);
                    }
                    else {
                        print ("seek: " + whence + " is not supported");
                    };
                };
            }
            catch (e : Exception) {
            };
            return 0;
        };
        try {
            if (whence == 0) {
                fis.reset();
            };
            fis.skip(off);
        }
        catch (e : Exception) {
            return -1;
        };
        return 0;
    }

    // modifiers: static
    static function ftell(fis : InputStream) : Int {
        try {
            if (isinstance(fis, (SeekableInputStream))) {
                var sis : SeekableInputStream = fis;
                return sis.tell();
            };
        }
        catch (e : Exception) {
        };
        return 0;
    }

    // modifiers: 
    function open(is_ : InputStream, initial : Bytes, ibytes : Int) : Int {
        return open_callbacks(is_, initial, ibytes);
    }

    // modifiers: 
    function open_callbacks(is_ : InputStream, initial : Bytes, ibytes : Int) : Int {
        var ret : Int;
        datasource = is_;
        oy.init();
        if (initial != null) {
            var index : Int = oy.buffer(ibytes);
            System.arraycopy(initial, 0, oy.data, index, ibytes);
            oy.wrote(ibytes);
        };
        if (isinstance(is_, (SeekableInputStream))) {
            ret = open_seekable();
        }
        else {
            ret = open_nonseekable();
        };
        if (ret != 0) {
            datasource = null;
            clear();
        };
        return ret;
    }

    // modifiers: public
    public function streams() : Int {
        return links;
    }

    // modifiers: public
    public function seekable() : Bool {
        // FIXME: shadows variable 'seekable';
        return seekable;
    }

    // modifiers: public
    public function bitrate(i : Int) : Int {
        if (i >= links) {
            return -1;
        };
        if (!seekable && (i != 0)) {
            return bitrate(0);
        };
        if (i < 0) {
            var bits : Int = 0;
            // for-while;
            var j : Int = 0;
            while (j < links) {
                bits += ((offsets[j + 1] - dataoffsets[j]) * 8);
                j++;
            };
            return Math.rint(bits / time_total(-1));
        }
        else {
            if (seekable) {
                return Math.rint(((offsets[i + 1] - dataoffsets[i]) * 8) / time_total(i));
            }
            else {
                if (vi[i].bitrate_nominal > 0) {
                    return vi[i].bitrate_nominal;
                }
                else {
                    if (vi[i].bitrate_upper > 0) {
                        if (vi[i].bitrate_lower > 0) {
                            return (vi[i].bitrate_upper + vi[i].bitrate_lower) / 2;
                        }
                        else {
                            return vi[i].bitrate_upper;
                        };
                    };
                    return -1;
                };
            };
        };
    }

    // modifiers: public
    public function bitrate_instant() : Int {
        var _link : Int = (seekable ? current_link : 0);
        if (samptrack == 0) {
            return -1;
        };
        var ret : Int = ((bittrack / samptrack) * vi[_link].rate) + 0.5;
        bittrack = 0.;
        samptrack = 0.;
        return ret;
    }

    // modifiers: public
    public function serialnumber(i : Int) : Int {
        if (i >= links) {
            return -1;
        };
        if (!seekable && (i >= 0)) {
            return serialnumber(-1);
        };
        if (i < 0) {
            return current_serialno;
        }
        else {
            return serialnos[i];
        };
    }

    // modifiers: public
    public function raw_total(i : Int) : Int {
        if (!seekable || (i >= links)) {
            return -1;
        };
        if (i < 0) {
            var acc : Int = 0;
            // for-while;
            var j : Int = 0;
            while (j < links) {
                acc += raw_total(j);
                j++;
            };
            return acc;
        }
        else {
            return offsets[i + 1] - offsets[i];
        };
    }

    // modifiers: public
    public function pcm_total(i : Int) : Int {
        if (!seekable || (i >= links)) {
            return -1;
        };
        if (i < 0) {
            var acc : Int = 0;
            // for-while;
            var j : Int = 0;
            while (j < links) {
                acc += pcm_total(j);
                j++;
            };
            return acc;
        }
        else {
            return pcmlengths[i];
        };
    }

    // modifiers: public
    public function time_total(i : Int) : Float {
        if (!seekable || (i >= links)) {
            return -1;
        };
        if (i < 0) {
            var acc : Float = 0;
            // for-while;
            var j : Int = 0;
            while (j < links) {
                acc += time_total(j);
                j++;
            };
            return acc;
        }
        else {
            return pcmlengths[i] / vi[i].rate;
        };
    }

    // modifiers: public
    public function raw_seek(pos : Int) : Int {
        if (!seekable) {
            return -1;
        };
        if ((pos < 0) || (pos > offsets[links])) {
            pcm_offset = -1;
            decode_clear();
            return -1;
        };
        pcm_offset = -1;
        decode_clear();
        seek_helper(pos);
        while True {
            if process_packet(1) == 0 {
                pcm_offset = pcm_total(-1);
                return 0;
            };
            if process_packet(1) == -1 {
                pcm_offset = -1;
                decode_clear();
                return -1;
            };
            break;
            break;
        };
        while (true) {
            while True {
                if process_packet(0) == 0 {
                    return 0;
                };
                if process_packet(0) == -1 {
                    pcm_offset = -1;
                    decode_clear();
                    return -1;
                };
                break;
                break;
            };
        };
    }

    // modifiers: public
    public function pcm_seek(pos : Int) : Int {
        var link : Int = -1;
        var total : Int = pcm_total(-1);
        if (!seekable) {
            return -1;
        };
        if ((pos < 0) || (pos > total)) {
            pcm_offset = -1;
            decode_clear();
            return -1;
        };
        // for-while;
        link = (links - 1);
        while (link >= 0) {
            total -= pcmlengths[link];
            if (pos >= total) {
                break;
            };
            link--;
        };
        var target : Int = pos - total;
        var end : Int = offsets[link + 1];
        var begin : Int = offsets[link];
        var best : Int = begin;
        var og : Page = Page();
        while (begin < end) {
            var bisect : Int;
            var ret : Int;
            if ((end - begin) < VorbisFile.CHUNKSIZE) {
                bisect = begin;
            }
            else {
                bisect = ((end + begin) / 2);
            };
            seek_helper(bisect);
            ret = get_next_page(og, end - bisect);
            if (ret == -1) {
                end = bisect;
            }
            else {
                var granulepos : Int = og.granulepos();
                if (granulepos < target) {
                    best = ret;
                    begin = offset;
                }
                else {
                    end = bisect;
                };
            };
        };
        if (raw_seek(best) != 0) {
            pcm_offset = -1;
            decode_clear();
            return -1;
        };
        if (pcm_offset >= pos) {
            pcm_offset = -1;
            decode_clear();
            return -1;
        };
        if (pos > pcm_total(-1)) {
            pcm_offset = -1;
            decode_clear();
            return -1;
        };
        while (pcm_offset < pos) {
            var pcm : Array<Array<Float>>;
            var target : Int = pos - pcm_offset;
            var _pcm : Array<Array<Array<Float>>> = new float[1];
            var _index : Array<Int> = new int[getInfo(-1).channels];
            var samples : Int = vd.synthesis_pcmout(_pcm, _index);
            pcm = _pcm[0];
            if (samples > target) {
                samples = target;
            };
            vd.synthesis_read(samples);
            pcm_offset += samples;
            if (samples < target) {
                if (process_packet(1) == 0) {
                    pcm_offset = pcm_total(-1);
                };
            };
        };
        return 0;
    }

    // modifiers: 
    function time_seek(seconds : Float) : Int {
        var link : Int = -1;
        var pcm_total : Int = pcm_total(-1);
        var time_total : Float = time_total(-1);
        if (!seekable) {
            return -1;
        };
        if ((seconds < 0) || (seconds > time_total)) {
            pcm_offset = -1;
            decode_clear();
            return -1;
        };
        // for-while;
        link = (links - 1);
        while (link >= 0) {
            pcm_total -= pcmlengths[link];
            time_total -= time_total(link);
            if (seconds >= time_total) {
                break;
            };
            link--;
        };
        var target : Int = pcm_total + ((seconds - time_total) * vi[link].rate);
        return pcm_seek(target);
    }

    // modifiers: public
    public function raw_tell() : Int {
        return offset;
    }

    // modifiers: public
    public function pcm_tell() : Int {
        return pcm_offset;
    }

    // modifiers: public
    public function time_tell() : Float {
        var link : Int = -1;
        var pcm_total : Int = 0;
        var time_total : Float = 0.;
        if (seekable) {
            pcm_total = pcm_total(-1);
            time_total = time_total(-1);
            // for-while;
            link = (links - 1);
            while (link >= 0) {
                pcm_total -= pcmlengths[link];
                time_total -= time_total(link);
                if (pcm_offset >= pcm_total) {
                    break;
                };
                link--;
            };
        };
        return time_total + (pcm_offset - pcm_total / vi[link].rate);
    }

    // modifiers: public
    public function __getInfo_0(link : Int) : Info {
        if (seekable) {
            if (link < 0) {
                if (decode_ready) {
                    return vi[current_link];
                }
                else {
                    return;
                };
            }
            else {
                if (link >= links) {
                    return;
                }
                else {
                    return vi[link];
                };
            };
        }
        else {
            if (decode_ready) {
                return vi[0];
            }
            else {
                return;
            };
        };
    }

    // modifiers: public
    public function __getComment_0(link : Int) : Comment {
        if (seekable) {
            if (link < 0) {
                if (decode_ready) {
                    return vc[current_link];
                }
                else {
                    return;
                };
            }
            else {
                if (link >= links) {
                    return;
                }
                else {
                    return vc[link];
                };
            };
        }
        else {
            if (decode_ready) {
                return vc[0];
            }
            else {
                return;
            };
        };
    }

    // modifiers: 
    function host_is_big_endian() : Int {
        return 1;
    }

    // modifiers: 
    function read(buffer : Bytes, length : Int, bigendianp : Int, word : Int, sgned : Int, bitstream : Array<Int>) : Int {
        var host_endian : Int = host_is_big_endian();
        var index : Int = 0;
        while (true) {
            if (decode_ready) {
                var pcm : Array<Array<Float>>;
                var _pcm : Array<Array<Array<Float>>> = new float[1];
                var _index : Array<Int> = new int[getInfo(-1).channels];
                var samples : Int = vd.synthesis_pcmout(_pcm, _index);
                pcm = _pcm[0];
                if (samples != 0) {
                    var channels : Int = getInfo(-1).channels;
                    var bytespersample : Int = word * channels;
                    if (samples > (length / bytespersample)) {
                        samples = (length / bytespersample);
                    };
                    var val : Int;
                    if (word == 1) {
                        var off : Int = (sgned != 0 ? 0 : 128);
                        // for-while;
                        var j : Int = 0;
                        while (j < samples) {
                            // for-while;
                            var i : Int = 0;
                            while (i < channels) {
                                val = (pcm[i][_index[i] + j] * 128.) + 0.5;
                                if (val > 127) {
                                    val = 127;
                                }
                                else {
                                    if (val < -128) {
                                        val = -128;
                                    };
                                };
                                buffer[index++] = val + off;
                                i++;
                            };
                            j++;
                        };
                    }
                    else {
                        var off : Int = (sgned != 0 ? 0 : 32768);
                        if (host_endian == bigendianp) {
                            if (sgned != 0) {
                                // for-while;
                                var i : Int = 0;
                                while (i < channels) {
                                    var src : Int = _index[i];
                                    var dest : Int = i;
                                    // for-while;
                                    var j : Int = 0;
                                    while (j < samples) {
                                        val = (pcm[i][src + j] * 32768.) + 0.5;
                                        if (val > 32767) {
                                            val = 32767;
                                        }
                                        else {
                                            if (val < -32768) {
                                                val = -32768;
                                            };
                                        };
                                        buffer[dest] = val >>> 8;
                                        buffer[dest + 1] = val;
                                        dest += (channels * 2);
                                        j++;
                                    };
                                    i++;
                                };
                            }
                            else {
                                // for-while;
                                var i : Int = 0;
                                while (i < channels) {
                                    var src : Array<Float> = pcm[i];
                                    var dest : Int = i;
                                    // for-while;
                                    var j : Int = 0;
                                    while (j < samples) {
                                        val = (src[j] * 32768.) + 0.5;
                                        if (val > 32767) {
                                            val = 32767;
                                        }
                                        else {
                                            if (val < -32768) {
                                                val = -32768;
                                            };
                                        };
                                        buffer[dest] = (val + off) >>> 8;
                                        buffer[dest + 1] = val + off;
                                        dest += (channels * 2);
                                        j++;
                                    };
                                    i++;
                                };
                            };
                        }
                        else {
                            if (bigendianp != 0) {
                                // for-while;
                                var j : Int = 0;
                                while (j < samples) {
                                    // for-while;
                                    var i : Int = 0;
                                    while (i < channels) {
                                        val = (pcm[i][j] * 32768.) + 0.5;
                                        if (val > 32767) {
                                            val = 32767;
                                        }
                                        else {
                                            if (val < -32768) {
                                                val = -32768;
                                            };
                                        };
                                        val += off;
                                        buffer[index++] = val >>> 8;
                                        buffer[index++] = val;
                                        i++;
                                    };
                                    j++;
                                };
                            }
                            else {
                                // for-while;
                                var j : Int = 0;
                                while (j < samples) {
                                    // for-while;
                                    var i : Int = 0;
                                    while (i < channels) {
                                        val = (pcm[i][j] * 32768.) + 0.5;
                                        if (val > 32767) {
                                            val = 32767;
                                        }
                                        else {
                                            if (val < -32768) {
                                                val = -32768;
                                            };
                                        };
                                        val += off;
                                        buffer[index++] = val;
                                        buffer[index++] = val >>> 8;
                                        i++;
                                    };
                                    j++;
                                };
                            };
                        };
                    };
                    vd.synthesis_read(samples);
                    pcm_offset += samples;
                    if (bitstream != null) {
                        bitstream[0] = current_link;
                    };
                    return samples * bytespersample;
                };
            };
            while True {
                if process_packet(1) == 0 {
                    return 0;
                };
                if process_packet(1) == -1 {
                    return -1;
                };
                break;
                break;
            };
        };
    }

    // modifiers: public
    public function __getInfo_1() : Array<Info> {
        return vi;
    }

    // modifiers: public
    public function __getComment_1() : Array<Comment> {
        return vc;
    }

    // modifiers: static, public
    static public function main(arg : Array<String>) : Void {
        try {
            var foo : VorbisFile = VorbisFile(arg[0]);
            var links : Int = foo.streams();
            print "links=" + links;
            var comment : Array<Comment> = foo.getComment();
            var info : Array<Info> = foo.getInfo();
            // for-while;
            var i : Int = 0;
            while (i < links) {
                print info[i];
                print comment[i];
                i++;
            };
            print "raw_total: " + foo.raw_total(-1);
            print "pcm_total: " + foo.pcm_total(-1);
            print "time_total: " + foo.time_total(-1);
        }
        catch (e : Exception) {
            trace(e);
        };
    }

    class SeekableInputStream extends InputStream {
        /*
         * generated source for SeekableInputStream
         */
        // discarded initializer: 'null';
        var raf : ..RandomAccessFile;
        inline static var mode : String = "r";

        // modifiers: private
        private function __new_0() {
        }

        // modifiers: throws java.io.FileNotFoundException
        throws java.io.FileNotFoundException function __new_1(file : String) : java.io.RandomAccessFile {
            raf = java.io.RandomAccessFile(file, SeekableInputStream.mode);
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function __read_0() : Int {
            return raf.read();
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function __read_1(buf : Bytes) : Int {
            return raf.read(buf);
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function __read_2(buf : Bytes, s : Int, len : Int) : Int {
            return raf.read(buf, s, len);
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function skip(n : Int) : Int {
            return raf.skipBytes(n);
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function getLength() : Int {
            return len(raf);
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function tell() : Int {
            return raf.getFilePointer();
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function available() : Int {
            return len((raf) == raf.getFilePointer() ? 0 : 1);
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function close() : Void {
            raf.close();
        }

        // modifiers: public, synchronized
        public synchronized function mark(m : Int) : Void {
        }

        // modifiers: throws java.io.IOException, public, synchronized
        throws java.io.IOException public synchronized function reset() : Void {
        }

        // modifiers: public
        public function markSupported() : Bool {
            return false;
        }

        // modifiers: throws java.io.IOException, public
        throws java.io.IOException public function seek(pos : Int) : Void {
            raf.seek(pos);
        }

        // modifiers: throws java.io.IOException, public, inline
        throws java.io.IOException public inline function read() : Int {
            // FIXME: implement disambiguation handler;
            //   __read_0() : Int;
            //   __read_1(buf : Bytes) : Int;
            //   __read_2(buf : Bytes, s : Int, len : Int) : Int;
            throw "NotImplementedError";
        }

        // modifiers: inline, private
        inline private function new() {
            // FIXME: implement disambiguation handler;
            //   __new_0();
            //   __new_1(file : String) : java.io.RandomAccessFile;
            throw "NotImplementedError";
        }

    }

    // modifiers: inline, public
    inline public function getComment() : Comment {
        // FIXME: implement disambiguation handler;
        //   __getComment_0(link : Int) : Comment;
        //   __getComment_1() : Array<Comment>;
        throw "NotImplementedError";
    }

    // modifiers: inline, public, throws JOrbisException
    inline public throws JOrbisException function new() {
        // FIXME: implement disambiguation handler;
        //   __new_0(file : String);
        //   __new_1(is_ : InputStream, initial : Bytes, ibytes : Int);
        throw "NotImplementedError";
    }

    // modifiers: inline, public
    inline public function getInfo() : Info {
        // FIXME: implement disambiguation handler;
        //   __getInfo_0(link : Int) : Info;
        //   __getInfo_1() : Array<Info>;
        throw "NotImplementedError";
    }

}

