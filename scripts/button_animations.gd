extends Control

@export var offset : Vector2 = Vector2(0.5,0.5)
@export var show_selected_on_top : bool = false
@export var animate : bool = true
@export var buttons_only : bool = false

var typing : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while not get_child_count() > 0:
		await get_tree().create_timer(0).timeout
		if get_child_count() > 0:
			break
	for child : Node in get_children():
		if child is Button:
			var button_size : Vector2 = Vector2(0,0)
			if get_node(self.get_path()) is BoxContainer:
				button_size = Vector2(size.x, child.custom_minimum_size.y)
			else:
				button_size = Vector2(child.size.x, child.size.y)
				
			child.pivot_offset = Vector2(button_size.x * offset.x, button_size.y * offset.y)
			child.mouse_entered.connect(button_entered.bind(child))
			child.mouse_exited.connect(button_exited.bind(child))
			child.button_down.connect(button_pressed.bind(0))
			
		if child is OptionButton:
			child.item_selected.connect(button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func button_entered(button : Control) -> void:
	if button is Button or (not button is Button and buttons_only == false):
		if show_selected_on_top:
			button.z_index = 1
		if animate:
			var tween : Tween = create_tween()
			tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		Globals.hover_sound.play()
	
func button_exited(button : Control) -> void:
	if button is Button or (not button is Button and buttons_only == false):
		if show_selected_on_top:
			button.z_index = 0
		if animate:
			var tween : Tween = create_tween()
			tween.tween_property(button, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func button_pressed(index : int) -> void:
	Globals.click_sound.pitch_scale = 1.0
	Globals.click_sound.play()
	

	
