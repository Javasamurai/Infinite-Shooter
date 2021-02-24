extends Node

export(NodePath) var fireAudioPath
export(NodePath) var hitAudioPath
export(NodePath) var blastAudioPath
export(NodePath) var coinAudioPath

onready var fireAudio = get_node(fireAudioPath)
onready var hitAudio = get_node(hitAudioPath)
onready var blastAudio = get_node(blastAudioPath)
onready var coinAudio = get_node(coinAudioPath)

func _ready():
	EventBus.connect("playAudio", self, "playAudio")
	pass
	
func playAudio(path):
	match path:
		"fire": fireAudio.play()
		"hit": hitAudio.play()
		"explode": blastAudio.play()
		"coin": coinAudio.play()
	pass
