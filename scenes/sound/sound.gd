class_name Sound
extends Node

enum Instrument {
	HARP,
	GLASS,
	XYLOPHONE,
}

enum Scale {
	PENTA,
	JAP_PENTA,
	HICAZ,
	MAJOR,
	MELODIC_MINOR,
	WHOLE_TONE,
	DIMINISHED,
	BLUES,
	DORIC_HICAZ,
}

const NUM_OCTAVES: int = 3
const NUM_NOTES: int = 15
const STARTING_OCTAVES: Array[int] = [3, 5, 3]

const PENTA_SCALE: PackedStringArray = ["C", "D", "E", "G", "A"]
const JAP_PENTA_SCALE: PackedStringArray = ["A", "B", "C", "E", "F"]
const HICAZ_SCALE: PackedStringArray = ["A", "A#", "C#", "D", "E", "F", "G"]
const MAJOR_SCALE: PackedStringArray = ["A", "B", "C", "D", "E", "F", "G"]
const MELODIC_MINOR_SCALE: PackedStringArray = ["A", "B", "C", "D", "E", "F#", "G#"]
const WHOLE_TONE_SCALE: PackedStringArray = ["C", "D", "E", "F#", "G#", "A#"]
const DIMINISHED_SCALE: PackedStringArray = ["C", "C#", "D#", "E", "F#", "G", "A", "A#"]
const BLUES_SCALE: PackedStringArray = ["A", "C", "D", "D#", "E", "G"]
const DORIC_HICAZ_SCALE: PackedStringArray = ["D", "E", "F", "G#", "A", "B", "C"]

const MUSIC_SCALES: Array[PackedStringArray] = [
	PENTA_SCALE,
	JAP_PENTA_SCALE,
	HICAZ_SCALE,
	MAJOR_SCALE,
	MELODIC_MINOR_SCALE,
	WHOLE_TONE_SCALE,
	DIMINISHED_SCALE,
	BLUES_SCALE,
	DORIC_HICAZ_SCALE
]

static var enabled: bool = false:
	set(value):
		enabled = value
		samplers[instrument].release()
static var selected_scale: Scale = Scale.PENTA
static var samplers: Array[SamplerInstrument]
static var instrument: int = Instrument.HARP


func _ready() -> void:
	samplers.append($HarpSampler)
	samplers.append($GlassSampler)
	samplers.append($XylophoneSampler)


static func play_note(index: int) -> void:
	if enabled:
		var notes: PackedStringArray = MUSIC_SCALES[selected_scale]
		@warning_ignore("integer_division")
		samplers[instrument].play_note(
			notes[index % notes.size()], STARTING_OCTAVES[instrument] + index / notes.size()
		)
