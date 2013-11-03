package org.xiph.foggy;

import org.xiph.system.Bytes;

import org.xiph.fogg.SyncState;
import org.xiph.fogg.StreamState;
import org.xiph.fogg.Page;
import org.xiph.fogg.Packet;

import flash.utils.IDataInput;

enum DemuxerStatus {
    dmx_ok;
    dmx_stop;
}

class Demuxer {
    public static inline var ENOTOGG = -1;

    var oy : SyncState;
    //var os : StreamState;
    var og : Page;
    var op : Packet;

    var streams : Map<Int,StreamState>;
    var bos_done : Bool;

    var page_cbs : Map<Int,Page -> Int -> DemuxerStatus>;
    var packet_cbs : Map<Int,Packet -> Int -> DemuxerStatus>;

    public function new() {
        page_cbs = new Map<Int,Page -> Int -> DemuxerStatus>();
        packet_cbs = new Map<Int,Packet -> Int -> DemuxerStatus>();
        streams = new Map<Int,StreamState>();

        bos_done = false;

        oy = new SyncState();
        //os = new StreamState();

        og = new Page();
        op = new Packet();

        oy.init();
    }

    public function set_page_cb(serialno : Int,
                                cb : Page -> Int -> DemuxerStatus) : Void {
        if (serialno != -1 && !streams.exists(serialno)) {
            // TODO: throw and exception?
        } else {
            page_cbs.set(serialno, cb);
        }
    }

    public function remove_page_cb(serialno : Int) : Void {
        page_cbs.remove(serialno);
    }

    public function set_packet_cb(serialno : Int,
                                  cb : Packet -> Int -> DemuxerStatus) : Void {
        if (serialno != -1 && !streams.exists(serialno)) {
            // TODO: throw and exception?
                trace("*** HERE ***");
                trace("streams: " + streams.toString());
        } else {
            packet_cbs.set(serialno, cb);
        }
    }

    public function remove_packet_cb(serialno : Int) : Void {
        packet_cbs.remove(serialno);
    }

    //public function read(data : Bytes, len : Int, pos : Int = -1) : Int {
    public function read(data : IDataInput, len : Int, pos : Int = -1) : Int {
        // TODO: handle len as end_of_data?
        var buffer : Bytes;
        var ret : Int;
        var index : Int = oy.buffer(len);
        buffer = oy.data;

        if (pos != -1) {
            //data.position = pos;
        }
        data.readBytes(buffer, index, len);
        oy.wrote(len);

        while (true) {
            if ((ret = oy.pageout(og)) != 1) {
                if (buffer.length < 16384 || ret == 0)
                    return len;
                else {
                    return ENOTOGG;
                }
            }

            _process_page(og);
            // TODO: check for returns from _process_page()
        }

        return len;
    }

    private function _process_page(p : Page) : Int {
        var sn = p.serialno();
        var cbret : DemuxerStatus;
        var ret : Int;
        var cb : Page -> Int -> DemuxerStatus;

        cb = page_cbs.get(sn);
        if (cb == null) {
            //trace("cb==0");
            cb = page_cbs.get(-1);
        }

        if (cb != null) {
            cbret = cb(p, sn);
            trace("cb!=null; "+cbret);
            // TODO handle stop request
        }

        var os : StreamState = streams.get(sn);
        if (os == null) {
            /*if (bos_done) {
                // unexpected new stream
                trace("unexpected end of stream");
                return -1;
            }*/
			bos_done = false;
            os = new StreamState();
            os.init(sn);
            streams.set(sn, os);
        } else {
            // end of bos pages? handle!...
           // trace("end of bos");
            if (!bos_done) {
                bos_done = true;
            }
        }

        if (os.pagein(p) < 0) {
            // can happen on an unsupported version
            trace("unsupported ver");
            return -1;
        }

        while (true) {
            if ((ret = os.packetout(op)) != 1) {
                if (ret == 0)
                    break;
            } else {
                _process_packet(op, sn);
            }
        }

        if (p.eos() != 0) {
            //trace("eos detected");
            os.clear();
            streams.remove(sn);
            if (!streams.iterator().hasNext()) {
                bos_done = false;
                // we're ready for new chained streams
            }
        }

        return 0;
    }

    private function _process_packet(p : Packet, sn : Int) : Int {
        var ret : Int;
        var cbret : DemuxerStatus;
        var cb : Packet -> Int -> DemuxerStatus;

        cb = packet_cbs.get(sn);
        if (cb == null) {
            cb = packet_cbs.get(-1);
        }

        if (cb != null) {
            cbret = cb(p, sn);
            // TODO handle stop request
        }

        return 0;
    }

}