extends Button

@onready var tool_tip: Node2D = $ToolTip
@onready var confirm_delete: Panel = $"../../../ConfirmDelete"

var mouse_touching: bool = false
var tween : Tween = create_tween()
func _ready() -> void:
	tween = create_tween()
	tween.set_parallel()
func _process(delta: float) -> void:
	if mouse_touching:
		if Input.is_action_pressed("delete"):
			if not Globals.saves[Globals.hovered_save] == {}:
				confirm_delete.show()

func _on_mouse_entered() -> void:
	
	Globals.hovered_save = get_index()
	
	mouse_touching = true
	tween.stop()
	tween = create_tween()

	if Globals.saves[Globals.hovered_save] == {}:
		tool_tip.get_child(1).text = "empty."
	else:
		tool_tip.show()
		tool_tip.get_child(1).text = "press x to delete."
	tween.set_parallel()
	tween.tween_property(tool_tip, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	tween.tween_property(tool_tip, "scale", Vector2(3.565, 3.565), 0.1)

func _on_mouse_exited() -> void:
	mouse_touching = false
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(tool_tip, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
	tween.tween_property(tool_tip, "scale", Vector2(0, 0), 0.1)
	await tween.finished
	tool_tip.hide()
