package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

import org.xiph.fogg.Buffer;
import org.xiph.fogg.Packet;

class Info {
    /*
     * generated source for Info
     */
    inline static private var OV_EBADPACKET : Int = -136;
    inline static private var OV_ENOTAUDIO : Int = -135;
    static private var _vorbis : Bytes = System.fromString("vorbis");
    inline static private var VI_TIMEB : Int = 1;
    inline static private var VI_FLOORB : Int = 2;
    inline static private var VI_RESB : Int = 3;
    inline static private var VI_MAPB : Int = 1;
    inline static private var VI_WINDOWB : Int = 1;
    public var version : Int;
    public var channels : Int;
    public var rate : Int;
    var bitrate_upper : Int;
    var bitrate_nominal : Int;
    var bitrate_lower : Int;
    // discarded initializer: 'new int[2]';
    public var blocksizes : Vector<Int>;
    public var modes : Int;
    var maps : Int;
    public var times : Int;
    public var floors : Int;
    public var residues : Int;
    public var books : Int;
    public var psys : Int;
    // discarded initializer: 'null';
    public var mode_param : Array<InfoMode>;
    // discarded initializer: 'null';
    public var map_type : Vector<Int>;
    // discarded initializer: 'null';
    public var map_param : Array<Dynamic>;
    // discarded initializer: 'null';
    public var time_type : Vector<Int>;
    // discarded initializer: 'null';
    public var time_param : Array<Dynamic>;
    // discarded initializer: 'null';
    public var floor_type : Vector<Int>;
    // discarded initializer: 'null';
    public var floor_param : Array<Dynamic>;
    // discarded initializer: 'null';
    public var residue_type : Vector<Int>;
    // discarded initializer: 'null';
    public var residue_param : Array<Dynamic>;
    // discarded initializer: 'null';
    public var book_param : Array<StaticCodeBook>;
    // discarded initializer: 'new PsyInfo[64]';
    // psy_param : Vector<PsyInfo>;
    var envelopesa : Int;
    var preecho_thresh : Float;
    var preecho_clamp : Float;

    // modifiers: public
    public function init() : Void {
        rate = 0;
    }

    // modifiers: public
    public function clear() : Void {
        // for-while;
        var i : Int = 0;
        while (i < modes) {
            mode_param[i] = null;
            i++;
        };
        mode_param = null;
        // for-while;
        var i : Int = 0;
        while (i < maps) {
            FuncMapping.mapping_P[map_type[i]].free_info(map_param[i]);
            i++;
        };
        map_param = null;
        // for-while;
        var i : Int = 0;
        while (i < times) {
            FuncTime.time_P[time_type[i]].free_info(time_param[i]);
            i++;
        };
        time_param = null;
        // for-while;
        var i : Int = 0;
        while (i < floors) {
            FuncFloor.floor_P[floor_type[i]].free_info(floor_param[i]);
            i++;
        };
        floor_param = null;
        // for-while;
        var i : Int = 0;
        while (i < residues) {
            FuncResidue.residue_P[residue_type[i]].free_info(residue_param[i]);
            i++;
        };
        residue_param = null;
        // for-while;
        var i : Int = 0;
        while (i < books) {
            if (book_param[i] != null) {
                book_param[i].clear();
                book_param[i] = null;
            };
            i++;
        };
        book_param = null;
        /*
        // for-while;
        var i : Int = 0;
        while (i < psys) {
            psy_param[i].free();
            i++;
        };
        */
    }

    // modifiers: 
    function unpack_info(opb : Buffer) : Int {
        version = opb.read(32);
        if (version != 0) {
            return -1;
        };
        channels = opb.read(8);
        rate = opb.read(32);
        bitrate_upper = opb.read(32);
        bitrate_nominal = opb.read(32);
        bitrate_lower = opb.read(32);
        blocksizes[0] = (1 << opb.read(4));
        blocksizes[1] = (1 << opb.read(4));
        if (((((rate < 1) || (channels < 1)) || (blocksizes[0] < 8)) || (blocksizes[1] < blocksizes[0])) || (opb.read(1) != 1)) {
            clear();
            return -1;
        };
        return 0;
    }

    // modifiers: 
    function unpack_books(opb : Buffer) : Int {
        books = (opb.read(8) + 1);
        if ((book_param == null) || (book_param.length != books)) {
            //book_param = new StaticCodeBook[books];
            //book_param = new Vector(books, true);
            book_param = ArrayTools.alloc(books);
        };
        // for-while;
        var i : Int = 0;
        while (i < books) {
            book_param[i] = new StaticCodeBook();
            if (book_param[i].unpack(opb) != 0) {
                clear();
                return -1;
            };
            i++;
        };

        times = (opb.read(6) + 1);
        if ((time_type == null) || (time_type.length != times)) {
            //time_type = new int[times];
            time_type = new Vector(times, true);
        };
        if ((time_param == null) || (time_param.length != times)) {
            //time_param = new Object[times];
            //time_param = new Vector(times, true);
            time_param = ArrayTools.alloc(times);
        };
        // for-while;
        var i : Int = 0;
        while (i < times) {
            time_type[i] = opb.read(16);
            if ((time_type[i] < 0) || (time_type[i] >= Info.VI_TIMEB)) {
                clear();
                return -1;
            };
            time_param[i] = FuncTime.time_P[time_type[i]].unpack(this, opb);
            if (time_param[i] == null) {
                clear();
                return -1;
            };
            i++;
        };
        floors = (opb.read(6) + 1);
        if ((floor_type == null) || (floor_type.length != floors)) {
            //floor_type = new int[floors];
            floor_type = new Vector(floors, true);
        };
        if ((floor_param == null) || (floor_param.length != floors)) {
            //floor_param = new Object[floors];
            //floor_param = new Vector(floors, true);
            floor_param = ArrayTools.alloc(floors, true);
        };
        // for-while;
        var i : Int = 0;
        while (i < floors) {
            floor_type[i] = opb.read(16);
            if ((floor_type[i] < 0) || (floor_type[i] >= Info.VI_FLOORB)) {
                clear();
                return -1;
            };
            floor_param[i] = FuncFloor.floor_P[floor_type[i]].unpack(this, opb);
            if (floor_param[i] == null) {
                clear();
                return -1;
            };
            i++;
        };
        residues = (opb.read(6) + 1);
        if ((residue_type == null) || (residue_type.length != residues)) {
            //residue_type = new int[residues];
            residue_type = new Vector(residues, true);
        };
        if ((residue_param == null) || (residue_param.length != residues)) {
            //residue_param = new Object[residues];
            //residue_param = new Vector(residues, true);
            residue_param = ArrayTools.alloc(residues);
        };
        // for-while;
        var i : Int = 0;
        while (i < residues) {
            residue_type[i] = opb.read(16);
            if ((residue_type[i] < 0) || (residue_type[i] >= Info.VI_RESB)) {
                clear();
                return -1;
            };
            residue_param[i] = FuncResidue.residue_P[residue_type[i]].unpack(this, opb);
            if (residue_param[i] == null) {
                clear();
                return -1;
            };
            i++;
        };
        maps = (opb.read(6) + 1);
        if ((map_type == null) || (map_type.length != maps)) {
            //map_type = new int[maps];
            map_type = new Vector(maps, true);
        };
        if ((map_param == null) || (map_param.length != maps)) {
            //map_param = new Object[maps];
            //map_param = new Vector(maps, true);
            map_param = ArrayTools.alloc(maps);
        };
        // for-while;
        var i : Int = 0;
        while (i < maps) {
            map_type[i] = opb.read(16);
            if ((map_type[i] < 0) || (map_type[i] >= Info.VI_MAPB)) {
                clear();
                return -1;
            };
            map_param[i] = FuncMapping.mapping_P[map_type[i]].unpack(this, opb);
            if (map_param[i] == null) {
                clear();
                return -1;
            };
            i++;
        };
        modes = (opb.read(6) + 1);
        if ((mode_param == null) || (mode_param.length != modes)) {
            //mode_param = new InfoMode[modes];
            //mode_param = new Vector(modes, true);
            mode_param = ArrayTools.alloc(modes);
        };


        // for-while;
        var i : Int = 0;
        while (i < modes) {
            mode_param[i] = new InfoMode();
            mode_param[i].blockflag = opb.read(1);
            mode_param[i].windowtype = opb.read(16);
            mode_param[i].transformtype = opb.read(16);
            mode_param[i].mapping = opb.read(8);
            if (((mode_param[i].windowtype >= Info.VI_WINDOWB) || (mode_param[i].transformtype >= Info.VI_WINDOWB)) || (mode_param[i].mapping >= maps)) {
                clear();
                return -1;
            };
            i++;
        };
        if (opb.read(1) != 1) {
            clear();
            return -1;
        };
        return 0;
    }

    // modifiers: public
    public function synthesis_headerin(vc : Comment, op : Packet) : Int {
        var opb : Buffer = new Buffer();
        if (op != null) {
            opb.readinit(op.packet_base, op.packet, op.bytes);
            var buffer : Bytes = System.alloc(6);
            var packtype : Int = opb.read(8);
            opb.readBytes(buffer, 6);
            /*
            if (buffer[0] != 'v' || buffer[1] != 'o' || buffer[2] != 'r' ||
                buffer[3] != 'b' || buffer[4] != 'i' || buffer[5] != 's') {
                return -1;
            };
            */
            if (buffer.toString() != "vorbis") {
                return -1;
            };

            switch (packtype) {
            case 0x01:
                if (op.b_o_s == 0) {
                    return -1;
                };
                if (rate != 0) {
                    return -1;
                };
                return unpack_info(opb);
            case 0x03:
                if (rate == 0) {
                    return -1;
                };
                return vc.unpack(opb);
            case 0x05:
                if ((rate == 0) || (vc.vendor == null)) {
                    return -1;
                };

                return unpack_books(opb);
            default:
            };
        };
        return -1;
    }

    // modifiers: 
    function pack_info(opb : Buffer) : Int {
        opb.write(0x01, 8);
        opb.writeBytes(Info._vorbis);
        opb.write(0x00, 32);
        opb.write(channels, 8);
        opb.write(rate, 32);
        opb.write(bitrate_upper, 32);
        opb.write(bitrate_nominal, 32);
        opb.write(bitrate_lower, 32);
        opb.write(Info.ilog2(blocksizes[0]), 4);
        opb.write(Info.ilog2(blocksizes[1]), 4);
        opb.write(1, 1);
        return 0;
    }

    // modifiers: 
    function pack_books(opb : Buffer) : Int {
        opb.write(0x05, 8);
        opb.writeBytes(Info._vorbis);
        opb.write(books - 1, 8);
        // for-while;
        var i : Int = 0;
        while (i < books) {
            if (book_param[i].pack(opb) != 0) {
                return -1;
            };
            i++;
        };
        opb.write(times - 1, 6);
        // for-while;
        var i : Int = 0;
        while (i < times) {
            opb.write(time_type[i], 16);
            FuncTime.time_P[time_type[i]].pack(this.time_param[i], opb);
            i++;
        };
        opb.write(floors - 1, 6);
        // for-while;
        var i : Int = 0;
        while (i < floors) {
            opb.write(floor_type[i], 16);
            FuncFloor.floor_P[floor_type[i]].pack(floor_param[i], opb);
            i++;
        };
        opb.write(residues - 1, 6);
        // for-while;
        var i : Int = 0;
        while (i < residues) {
            opb.write(residue_type[i], 16);
            FuncResidue.residue_P[residue_type[i]].pack(residue_param[i], opb);
            i++;
        };
        opb.write(maps - 1, 6);
        // for-while;
        var i : Int = 0;
        while (i < maps) {
            opb.write(map_type[i], 16);
            FuncMapping.mapping_P[map_type[i]].pack(this, map_param[i], opb);
            i++;
        };
        opb.write(modes - 1, 6);
        // for-while;
        var i : Int = 0;
        while (i < modes) {
            opb.write(mode_param[i].blockflag, 1);
            opb.write(mode_param[i].windowtype, 16);
            opb.write(mode_param[i].transformtype, 16);
            opb.write(mode_param[i].mapping, 8);
            i++;
        };
        opb.write(1, 1);
        return 0;
    }

    // modifiers: public
    public function blocksize(op : Packet) : Int {
        var opb : Buffer = new Buffer();
        var mode : Int;
        opb.readinit(op.packet_base, op.packet, op.bytes);
        if (opb.read(1) != 0) {
            return Info.OV_ENOTAUDIO;
        };
        var modebits : Int = 0;
        var v : Int = modes;
        while (v > 1) {
            modebits++;
            v >>>= 1;
        };
        mode = opb.read(modebits);
        if (mode == -1) {
            return Info.OV_EBADPACKET;
        };
        return blocksizes[mode_param[mode].blockflag];
    }

    // modifiers: static, private
    static private function ilog2(v : Int) : Int {
        var ret : Int = 0;
        while (v > 1) {
            ret++;
            v >>>= 1;
        };
        return ret;
    }

    // modifiers: public
    public function toString() : String {
        return "version:" + version + ", channels:" + channels +
            ", rate:" + rate + ", bitrate:" + bitrate_upper + "," +
            bitrate_nominal + "," + bitrate_lower;
    }

    public function new() {
        // collected discarded initializers:
        blocksizes = new Vector(2, true);
        mode_param = null;
        map_type = null;
        map_param = null;
        time_type = null;
        time_param = null;
        floor_type = null;
        floor_param = null;
        residue_type = null;
        residue_param = null;
        book_param = null;
        //psy_param = new Vector(64, true);
    }
}

