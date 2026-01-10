extends Node2D

@onready var name_text: RichTextLabel = $Control/Name
@onready var success_graph: Line2D = $Graph/SubViewport/SuccessGraph
@onready var time_left: ProgressBar = $Control/TimeLeft
@onready var buttons: HBoxContainer = $Control/Buttons
@onready var graph_camera: Camera2D = $Graph/SubViewport/GraphCamera
@onready var customer_satisfaction: HSlider = $CustomerSatisfaction
@onready var question: RichTextLabel = $Control/Question

var questions : Array[Dictionary] = [
	{'q': "What are you doing here!?", 'good': 'I have a proposal!', 'bad': "Buy my garbage you butthead!!!"},
	{'q': "Are you a fool?", 'good': "Of course not sir!", 'bad': "Maybe..."},
	{'q': "Are you a foul beast?", 'good': 'Far from it!', 'bad': "What did you call me chump?"},
	{'q': "What do you want?!", 'good': 'You to have some awesome new stuff!', 'bad': "To sell you garbage."},
	{'q': "Are you some scamming heathen?!", 'good': 'Nope, I just have a great deal for you!', 'bad': "Well.. yes.. but.."},
	{'q': "Your not from the IRS right?", 'good': 'Nope!', 'bad': "..Who??"},
	{'q': "You're gonna take my riches, arent you?!!", 'good': "Wouldn't dream of it!", 'bad': "Technically yes..."},
	{'q': "Are you apart of the slob glagglewares family!??", 'good': "Nope, I hate them too.", 'bad': "HEY! Glagglewares is awesome!"},
	{'q': "You better not be selling TRASH!", 'good': "I would never sell trash to such a fine rich man!", 'bad': "What does it matter to you snob?!!"},


]
var good : int = randi_range(0,1)
var camera_line_index : int = 0
var target_line_x : float = 0
var satisfaction : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	satisfaction = 10
	customer_satisfaction.value = satisfaction
	name_text.text = "[center]Deal with " + Globals.rich_person_name
	add_to_graph(0.0)
	ask_question()

func _process(delta: float) -> void:
	if success_graph.position.x > target_line_x + 32:
		
		var tween : Tween = create_tween()
		tween.tween_property(success_graph, "position", Vector2(target_line_x, success_graph.position.y), (target_line_x - success_graph.position.x) * 2).set_trans(Tween.TRANS_LINEAR)
	else:
		
		success_graph.position.x -= delta * 60
	while success_graph.get_point_position(camera_line_index).x < -success_graph.position.x + 64:
		camera_line_index += 1
	graph_camera.position.y = lerp(graph_camera.position.y, success_graph.get_point_position(camera_line_index).y, delta * 4)
func ask_question() -> void:
	var question_int : int = randi_range(0,len(questions) - 1)
	question.text = "[center]" + questions[question_int]['q']
	good = randi_range(0,1)
	buttons.get_child(good).get_child(0).text = questions[question_int]['good']
	buttons.get_child(posmod(good + 1, 2)).get_child(0).text = questions[question_int]['bad']
	
func add_to_graph(point : float) -> void:
	var new_points : Array = success_graph.points
	new_points.remove_at(len(new_points) - 1)
	var x_pos : int = -success_graph.position.x + 64
	for i in new_points:
		if i.x > x_pos:
			x_pos = i.x + 1
	new_points.append(Vector2(x_pos, new_points[len(new_points) - 1].y))
	new_points.append(Vector2(x_pos + 32, point))
	target_line_x = -x_pos - 32
	new_points.append(Vector2(-success_graph.position.x + 1000000, point))
	success_graph.points = new_points


func _on_button_pressed(index : int) -> void:
	if good == index:
		satisfaction += 1
		customer_satisfaction.value = satisfaction
		add_to_graph((success_graph.points[len(success_graph.points) - 1].y - time_left.value))
		success_graph.default_color = Color.GREEN
	else:
		satisfaction -= 2
		customer_satisfaction.value = satisfaction
		add_to_graph((success_graph.points[len(success_graph.points) - 1].y + (150 -  time_left.value)))
		success_graph.default_color = Color.RED
	ask_question()
