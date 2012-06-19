import org.xiph.system.AudioSink;
import flash.Vector;


class PAudioSink extends AudioSink {
    /**
       A very quick&dirty wrapper around the AudioSink to somewhat
       make up for the lack of a proper demand-driven ogg demuxer a.t.m.
     */

    var cb_threshold : Int;
    var cb_pending : Bool;
    var cb : PAudioSink -> Void;

    public function new(chunk_size : Int, fill = true, trigger = 0) {
        super(chunk_size, fill, trigger);
        cb_threshold = 0;
        cb = null;
        cb_pending = false;

    }

    public function set_cb(threshold : Int, cb : PAudioSink -> Void) : Void {
        cb_threshold = threshold;
        this.cb = cb;
    }

    override function _data_cb(event : flash.events.SampleDataEvent) :Void {
        super._data_cb(event);

        if (cb_threshold > 0) {
            if (available < cb_threshold && !cb_pending) {
                cb_pending = true;
                haxe.Timer.delay(_delayed_cb, 1);
            }
        }
    }

    function _delayed_cb() : Void {
        this.cb_pending = false;
        this.cb(this);
    }

    override public function write(pcm : Array<Vector<Float>>,
                                   index : Vector<Int>, samples : Int) : Void {
        super.write(pcm, index, samples);

        if (cb_threshold > 0) {
            if (available < cb_threshold && !cb_pending) {
                cb_pending = true;
                haxe.Timer.delay(_delayed_cb, 1);
            }
        }
    }
}
