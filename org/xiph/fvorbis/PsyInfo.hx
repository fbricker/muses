package org.xiph.fvorbis;

import org.xiph.system.Bytes;

import flash.Vector;

class PsyInfo {
    /*
     * generated source for PsyInfo
     */
    var athp : Int;
    var decayp : Int;
    var smoothp : Int;
    var noisefitp : Int;
    var noisefit_subblock : Int;
    var noisefit_threshdB : Float;
    var ath_att : Float;
    var tonemaskp : Int;
    // discarded initializer: 'new float[5]';
    var toneatt_125Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var toneatt_250Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var toneatt_500Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var toneatt_1000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var toneatt_2000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var toneatt_4000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var toneatt_8000Hz : Vector<Float>;
    var peakattp : Int;
    // discarded initializer: 'new float[5]';
    var peakatt_125Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var peakatt_250Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var peakatt_500Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var peakatt_1000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var peakatt_2000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var peakatt_4000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var peakatt_8000Hz : Vector<Float>;
    var noisemaskp : Int;
    // discarded initializer: 'new float[5]';
    var noiseatt_125Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var noiseatt_250Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var noiseatt_500Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var noiseatt_1000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var noiseatt_2000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var noiseatt_4000Hz : Vector<Float>;
    // discarded initializer: 'new float[5]';
    var noiseatt_8000Hz : Vector<Float>;
    var max_curve_dB : Float;
    var attack_coeff : Float;
    var decay_coeff : Float;

    // modifiers: 
    public function free() : Void {
    }

    public function new() {
        toneatt_125Hz = new Vector(5, true);
        toneatt_250Hz = new Vector(5, true);
        toneatt_500Hz = new Vector(5, true);
        toneatt_1000Hz = new Vector(5, true);
        toneatt_2000Hz = new Vector(5, true);
        toneatt_4000Hz = new Vector(5, true);
        toneatt_8000Hz = new Vector(5, true);
        peakatt_125Hz = new Vector(5, true);
        peakatt_250Hz = new Vector(5, true);
        peakatt_500Hz = new Vector(5, true);
        peakatt_1000Hz = new Vector(5, true);
        peakatt_2000Hz = new Vector(5, true);
        peakatt_4000Hz = new Vector(5, true);
        peakatt_8000Hz = new Vector(5, true);
        noiseatt_125Hz = new Vector(5, true);
        noiseatt_250Hz = new Vector(5, true);
        noiseatt_500Hz = new Vector(5, true);
        noiseatt_1000Hz = new Vector(5, true);
        noiseatt_2000Hz = new Vector(5, true);
        noiseatt_4000Hz = new Vector(5, true);
        noiseatt_8000Hz = new Vector(5, true);
    }
}
