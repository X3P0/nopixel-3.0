/* eslint-disable @typescript-eslint/explicit-function-return-type */
const ClickSounds = [
	{ on: "sounds/clicks/01-on.ogg", off: "sounds/clicks/01-off.ogg", distortion: "sounds/clicks/01-distortion.ogg" },
	{ on: "sounds/clicks/02-on.ogg", off: "sounds/clicks/02-off.ogg" },
];

let IsRadioOn = false;

/* Hud Settings */
let RadioHudStyle = "normal";
let ClickVolume = 0.2;
let ClickSound = ClickSounds[0];

function PlaySound(soundTag = null, file = null, args = null) {
	const sound = document.querySelector(`#${soundTag}`);
	const soundFile = file;

	var args = args;

	for (i = 0; i < sound.attributes.length; i++) {
		if (sound.attributes[i].name != "id") {
			sound.removeAttribute(sound.attributes[i].name);
		}
	}

	if (soundFile == null) {
		sound.setAttribute("src", "");
	} else {
		if (args == null) {
		} else {
			for (const key in args) {
				if (key != "addMultiListener") {
					if (key == "volume") {
						sound.volume = args[key];
					} else {
						sound.setAttribute(key, args[key]);
					}
				}
			}
		}

		sound.setAttribute("src", soundFile);
		sound.play();
	}
}

function SetHUDVisibility(visible) {
	if (visible) {
		$("body").css("visibility", "visible");
	} else {
		$("body").css("visibility", "hidden");
	}
}

function SetRadioHUDStyle(style) {
	if (style === "minimal") {
		RadioHudStyle = "minimal";
	} else if (style === "normal") {
		RadioHudStyle = "normal";
	} else if (style === "hidden") {
		RadioHudStyle = "hidden";
	}
}

function SetRadioPowerState(enabled) {
	PlaySound("local", enabled ? "sounds/radioon.ogg" : "sounds/radiooff.ogg", {
		volume: ClickVolume,
	});
}

function PlayLocalClick(transmitting) {
	PlaySound("local", transmitting ? ClickSound.on : ClickSound.off, {
		volume: ClickVolume,
	});
}

function PlayRemoteClick(status, isDistortion) {
	PlaySound("remote", status ? (isDistortion ? ClickSound.distortion : ClickSound.on) : ClickSound.off, {
		volume: ClickVolume,
	});
}

function SetVoiceStatus(speaking) {
	if (speaking) {
		$("#voice").css("animation", "pulse 1s infinite");
	} else {
		$("#voice").css("animation", "");
	}
}

function SetHudSettings(settings) {
	ClickVolume = settings.clickVolume;
	ClickSound =
		typeof ClickSounds[settings.clickSound] !== "undefined"
			? ClickSounds[settings.clickSound]
			: ClickSounds[0];
}

function ChangeVoiceProximity(proximity) {
	$("#voice").removeClass();

	if (proximity === "Normal") {
		$("#voice").addClass("range-normal");
	} else if (proximity === "Shout") {
		$("#voice").addClass("range-shout");
	} else if (proximity === "Whisper") {
		$("#voice").addClass("range-whisper");
	}
}

window.addEventListener("message", (event) => {
	if (event.data.type === "hud") {
		SetHUDVisibility(event.data.enabled);
	} else if (event.data.type === "proximity") {
		ChangeVoiceProximity(event.data.proximity);
	} else if (event.data.type === "voiceStatus") {
		SetVoiceStatus(event.data.speaking);
	} else if (event.data.type === "radioPowerState") {
		SetRadioPowerState(event.data.state);
	} else if (event.data.type === "localClick") {
		PlayLocalClick(event.data.state);
	} else if (event.data.type === "remoteClick") {
    PlayRemoteClick(event.data.state, event.data.distortion);
	} else if (event.data.type === "settings") {
		SetHudSettings(event.data.settings);
	}
});
