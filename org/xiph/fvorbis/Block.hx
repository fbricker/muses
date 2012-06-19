package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;
import org.xiph.fogg.Packet;

class Block {
    /*
     * generated source for Block
     */
    // discarded initializer: 'new float[0]';
    public var pcm : Array<Vector<Float>>;
    // discarded initializer: 'Buffer()';
    public var opb : Buffer;
    public var lW : Int;
    public var W : Int;
    public var nW : Int;
    public var pcmend : Int;
    public var mode : Int;
    public var eofflag : Int;
    public var granulepos : Int;
    public var sequence : Int;
    public var vd : DspState;
    public var glue_bits : Int;
    public var time_bits : Int;
    public var floor_bits : Int;
    public var res_bits : Int;

    // modifiers: public
    public function new(vd : DspState) {
        pcm = new Array();
        opb = new Buffer();

        this.vd = vd;
        if (vd.analysisp != 0) {
            opb.writeinit();
        };
    }

    // modifiers: public
    public function init(vd : DspState) : Void {
        this.vd = vd;
    }

    // modifiers: public
    public function clear() : Int {
        if (vd != null) {
            if (vd.analysisp != 0) {
                opb.writeclear();
            };
        };
        return 0;
    }

    // modifiers: public
    public function synthesis(op : Packet) : Int {
        var vi : Info = vd.vi;
        opb.readinit(op.packet_base, op.packet, op.bytes);
        if (opb.read(1) != 0) {
            return -1;
        };
        var _mode : Int = opb.read(vd.modebits);
        if (_mode == -1) {
            return -1;
        };

        mode = _mode;
        W = vi.mode_param[mode].blockflag;
        if (W != 0) {
            lW = opb.read(1);
            nW = opb.read(1);
            if (nW == -1) {
                return -1;
            };
        }
        else {
            lW = 0;
            nW = 0;
        };
        granulepos = op.granulepos;
        sequence = (op.packetno - 3);
        eofflag = op.e_o_s;
        pcmend = vi.blocksizes[W];
        if (pcm.length < vi.channels) {
            //pcm = new float[vi.channels];
            pcm = ArrayTools.alloc(vi.channels);
        };

        // for-while;
        var i : Int = 0;
        while (i < vi.channels) {
            if ((pcm[i] == null) || (cast(pcm[i].length,UInt) < cast(pcmend,UInt))) {
                //pcm[i] = new float[pcmend];
                pcm[i] = new Vector(pcmend, true);
            }
            else {
                // for-while;
                var j : Int = 0;
                while (j < pcmend) {
                    pcm[i][j] = 0;
                    j++;
                };
            };
            i++;
        };
        var type : Int = vi.map_type[vi.mode_param[mode].mapping];
        return FuncMapping.mapping_P[type].inverse(this, vd.mode[mode]);
    }

}

