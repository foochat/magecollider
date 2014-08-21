////////////////////////////////////////////////////////////////////
//
// Short example on how to use the Mage plug-in for SuperCollider.
//
//                             ------
//
// Play it one line at a time by pressing Ctrl+Return.
//
////////////////////////////////////////////////////////////////////
//
// Author :      (c) Antonin Puleo   -   10-August-2014
//
////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////
//------------- Initialisation Step ---------------

s.boot; // boot local server

(
// Create a SynthDef that uses Mage UGen.
SynthDef(\mage, {arg outbus = 0, pitch = 1.0, speed = 1.0, alpha = 1.0, mul = 1.0;
	Out.ar(outbus, Mage.ar(pitch, speed, alpha, mul));
}).add;

// Create a SynthDef that add a delay effect to a bus.
SynthDef(\delay, { arg inbus = 0, outbus = 1, delay = 0.15;
    Out.ar(outbus, DelayN.ar(In.ar(inbus), delay, delay));
}).add;
)


////////////////////////////////////////////////////////////////////
//------------- Instantiation Step ---------------

// Instanciate Mage engine.
x = Synth.new(\mage);
// Add it the delay effect if you want.
y = Synth.after(x, \delay);

// Add a predefined voice for your speaker.
Mage.addVoice(s, x, "slt", "/usr/data/cmuarctic/voices/slt");
// If you want, add other predefined voices ...
Mage.addVoice(s, x, "awb", "/usr/data/cmuarctic/voices/awb"); // possible choice :
Mage.addVoice(s, x, "rms", "/usr/data/cmuarctic/voices/rms"); // slt, awb, bdl, clb, jmk, rms
// ... and interpolate between them to create a unique custom voice :
Mage.setWeight(s, x, "rms", 0.3); // Each voice has a weight between 0 and 1.
Mage.setWeight(s, x, "slt", 0.3); // Manage to get sum of the weights equal to 1.
Mage.setWeight(s, x, "awb", 0.4); // Otherwise, it could sound horrible.

////////////////////////////////////////////////////////////////////
//------------- Playing Step ---------------
/*
Now, tell him what to say.
This is done by pushing new labels (roughly corresponding to phoneme + context) at the
end of the currently synthesizing speech. There are multiple possibilities to achieve this :
*/

// 1. push new labels into Mage synthesizer from a file in which labels were stored.
Mage.loadLabFile(s, x, "/usr/data/cmuarctic/labels/alice01.lab");

// 2. push new labels directly by writing them as string.
// Here, 4 labels are sent in a row (beginning of the word "Alice").
(
Mage.pushLab(s, x, "x^x-pau+ae=l@x_x/A:0_0_0/B:x-x-x@x-x&x-x#x-x$x-x!x-x;x-x|x/C:1+1+2/D:0_0/E:x+x@x+x&x+x#x+x/F:content_2/G:0_0/H:x=x^1=10|0/I:19=12/J:79+57-10");
Mage.pushLab(s, x, "x^pau-ae+l=ax@1_2/A:0_0_0/B:1-1-2@1-2&1-19#1-10$1-5!0-2;0-8|ae/C:0+0+2/D:0_0/E:content+2@1+12&1+6#0+2/F:aux_1/G:0_0/H:19=12^1=10|L-H%/I:3=3/J:79+57-10");
Mage.pushLab(s, x, "pau^ae-l+ax=s@2_1/A:0_0_0/B:1-1-2@1-2&1-19#1-10$1-5!0-2;0-8|ae/C:0+0+2/D:0_0/E:content+2@1+12&1+6#0+2/F:aux_1/G:0_0/H:19=12^1=10|L-H%/I:3=3/J:79+57-10");
Mage.pushLab(s, x, "ae^l-ax+s=w@1_2/A:1_1_2/B:0-0-2@2-1&2-18#1-10$1-5!1-1;1-7|ax/C:1+0+3/D:0_0/E:content+2@1+12&1+6#0+2/F:aux_1/G:0_0/H:19=12^1=10|L-H%/I:3=3/J:79+57-10");
)

// 3. push all previously inserted labels at the end of the queue.
Mage.reloadLabs(s, x, 2);

// 4. listen to OSC packets to receive labels generated somewhere else on your computer (example : R. Dall's text-to-label on-the-fly generator).
Mage.listenOSC(s, x, 9700);

// 5. A lite implementation of the R. Dall's text-to-label generator is also available. Currently, only final dot punctuation is supported.
// This generator needs a dictionary to recognize words. So let's load one ...
Mage.dictionary(s, x, "/usr/data/cmuarctic/dictionary/cmudict.txt");
// ... and say what you want !
Mage.speak(s, x, "Alice was beginning to get very tired.");



// Change Mage parameters on live :
x.set(\pitch, 1.2); // 1.2 x natural pitch
x.set(\speed, 0.5); // 0.5 x normal speed
x.set(\alpha, 1.3); // big mouth !
x.set(\mul, 0.5);   // volume decreased

// Have Fun !!
x.run(false); // pause mage
x.run(true);  // resume mage
y.run(false); // pause delay
y.run(true);  // resume delay

x.free; y.free; // free memory.