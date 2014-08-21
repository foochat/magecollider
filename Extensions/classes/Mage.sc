/* -----------------------------------------------------------------------------
 *
 * This file implements a MAGE plug-in for SuperCollider.
 *
 * Created by Antonin Puleo.
 *
 * Copyright (c) 2014 University of Mons :
 *
 *              Numediart Institute for New Media Art ( www.numediart.org )
 *
 *
 * Last Update :	13-May-2014
 *
 * -----------------------------------------------------------------------------
 */


MageSC : UGen {
	*ar { arg pitch = 1.0, speed = 1.0, alpha = 1.0, mul = 1.0;
		^this.multiNewList(['audio', pitch, speed, 0.55*alpha]).madd(mul, 0);
	}

	*new { arg pitch = 1.0, speed = 1.0, alpha = 1.0, mul = 1.0;
		^this.multiNewList(['audio', pitch, speed, 0.55*alpha]).madd(mul, 0);
	}

	*addVoice { arg server, synth, name, path;
		SynthDescLib.global[synth.defName.asSymbol].def.children.do{|val,i|
			if(val.class==MageSC,
				{server.sendMsg(\u_cmd, synth.nodeID, i, "addVoice", name, path)}
		)};
	}

	*dictionary { arg server, synth, path;
		SynthDescLib.global[synth.defName.asSymbol].def.children.do{|val,i|
			if(val.class==MageSC,
				{server.sendMsg(\u_cmd, synth.nodeID, i, "dictionary", path)}
		)};
	}

	*speak { arg server, synth, sentence;
		SynthDescLib.global[synth.defName.asSymbol].def.children.do{|val,i|
			if(val.class==MageSC,
				{server.sendMsg(\u_cmd, synth.nodeID, i, "text", sentence)}
		)};
	}

	*pushLab { arg server, synth, label;
		SynthDescLib.global[synth.defName.asSymbol].def.children.do{|val,i|
			if(val.class==MageSC,
				{server.sendMsg(\u_cmd, synth.nodeID, i, "pushLabel", label)}
		)};
	}

	*reloadLabs { arg server, synth, times;
		SynthDescLib.global[synth.defName.asSymbol].def.children.do{|val,i|
			if(val.class==MageSC,
				{server.sendMsg(\u_cmd, synth.nodeID, i, "reloadLabels", times)}
		)};
	}

	*loadLabFile { arg server, synth, path;
		SynthDescLib.global[synth.defName.asSymbol].def.children.do{|val,i|
			if(val.class==MageSC,
				{server.sendMsg(\u_cmd, synth.nodeID, i, "loadLabelsFromFile", path)}
		)};
	}

	*setWeight { arg server, synth, name, weight;
		SynthDescLib.global[synth.defName.asSymbol].def.children.do{|val,i|
			if(val.class==MageSC,
				{server.sendMsg(\u_cmd, synth.nodeID, i, "voiceWeight", name, weight)}
		)};
	}

	// TODO : avoid multiple instance of func f on the same port
	*listenOSC { arg server, synth, port = 9700;
		var f;
		thisProcess.openUDPPort(port); // attempt to open port
		f = { |msg, time, replyAddr, recvPort|
			if( recvPort == port ) {

				if( msg[0] == '/label' ) {
					for (2, msg[1]+1, { arg i;
						this.pushLab(server, synth, msg[i]);
					});
				};

				if( msg[0] == '/probe' ) {
					msg.postln;
					if( msg[1] == 'p' ) {
						synth.set(\pitch, msg[2].asFloat);
					};

					if( msg[1] == 's' ) {
						synth.set(\speed, msg[2].asFloat);
					};

					if( msg[1] == 'a' ) {
						synth.set(\alpha, msg[2].asFloat);
					};
				};

			}
		};
		thisProcess.addOSCRecvFunc(f);
	}

}

// Mage Warpper for MageSC UGen
Mage {
	*ar { arg pitch = 1.0, speed = 1.0, alpha = 1.0, mul = 1.0;
		^MageSC.ar(pitch, speed, alpha, mul);
	}

	*new { arg pitch = 1.0, speed = 1.0, alpha = 1.0, mul = 1.0;
		^MageSC.new(pitch, speed, alpha, mul);
	}

	*addVoice { arg server, synth, name, path;
		^MageSC.addVoice(server, synth, name, path);
	}

	*dictionary { arg server, synth, path;
		^MageSC.dictionary(server, synth, path);
	}

	*speak { arg server, synth, sentence;
		^MageSC.speak(server, synth, sentence);
	}

	*pushLab { arg server, synth, label;
		^MageSC.pushLab(server, synth, label);
	}

	*reloadLabs { arg server, synth, times;
		^MageSC.reloadLabs(server, synth, times);
	}

	*loadLabFile { arg server, synth, path;
		^MageSC.loadLabFile(server, synth, path);
	}

	*setWeight { arg server, synth, name, weight;
		^MageSC.setWeight(server, synth, name, weight);
	}

	*listenOSC { arg server, synth, port;
		^MageSC.listenOSC(server, synth, port);
	}
}