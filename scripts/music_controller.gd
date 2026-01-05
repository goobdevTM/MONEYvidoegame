extends Node

#READY
func _ready() -> void:
	#LOOPS
	while true:
		#CYCLES THROUGH CHILDREN
		for i: AudioStreamPlayer in get_children():
			i.play()
			await i.finished
