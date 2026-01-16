extends Node2D

@onready var name_text: RichTextLabel = $Control/Name
@onready var success_graph: Line2D = $Graph/SubViewport/SuccessGraph
@onready var time_left: ProgressBar = $Control/TimeLeft
@onready var buttons: HBoxContainer = $Control/Buttons
@onready var graph_camera: Camera2D = $Graph/SubViewport/GraphCamera
@onready var customer_satisfaction: HSlider = $Control/CustomerSatisfaction
@onready var question: RichTextLabel = $Control/Question
@onready var timer: Timer = $Timer
@onready var wrong_anim: AnimationPlayer = $Control/Wrong/WrongAnim
@onready var time_up_anim: AnimationPlayer = $Control/TimeUp/TimeUpAnim
@onready var correct_anim: AnimationPlayer = $Control/Correct/CorrectAnim
@onready var start_anim: AnimationPlayer = $Control/Start/StartAnim
@onready var number: RichTextLabel = $Control/Number
@onready var click_and_hover: Node = $ClickAndHover
@onready var convinced: Control = $Control/Convinced
@onready var unconvinced: Control = $Control/Unconvinced
@onready var help: Control = $Help
@onready var buzzer: AudioStreamPlayer = $Buzzer
@onready var ding: AudioStreamPlayer = $Ding


var bad_questions : Array[Dictionary] = [
	{'q': "Are you a fool?", 'good': "Of course not sir!", 'bad': "Maybe..."},
	{'q': "Are you a foul beast?", 'good': 'Far from it!', 'bad': "What did you call me chump?"},
	{'q': "What do you want?!", 'good': 'You to have some awesome new stuff!', 'bad': "To sell you garbage."},
	{'q': "Are you some scamming heathen?!", 'good': 'Nope, I just have a great deal for you!', 'bad': "Well.. yes.. but.."},
	{'q': "You're gonna take my riches, arent you?!!", 'good': "Wouldn't dream of it!", 'bad': "Technically yes..."},
	{'q': "Are you a part of the slob GlaggleWares family!??", 'good': "Nope, I'm actually really cool.", 'bad': "Watch it with your language, buddy pal!!!"},
	{'q': "Filthy cretin...", 'good': "I take a shower every day!", 'bad': "Well I bet you are uhh... Pretty stinky!!!"},
	{'q': "No way I'll buy this!", 'good': "Just wait, it gets way better!", 'bad': "Okay, I don't even want your money."},
	{'q': "Scram!!!", 'good': "But don't you want your masterpiece?", 'bad': "Rude!!!"},
	{'q': "You disgust me.", 'good': "Okay.", 'bad': "You disgust ME, actually."}
]

var neutral_questions : Array[Dictionary] = [
	{'q': "What are you doing here?", 'good': 'I have a proposal!', 'bad': "Buy my garbage you butthead!!!"},
	{'q': "Are you a professional entreprenuer?", 'good': "That's me!", 'bad': "What even is that???"},
	{'q': "What's your opinion on the slob they call GlaggleWares?", 'good': "Same as yours, of course!", 'bad': "GlaggleWares is not a slob!!!"},
	{'q': "You're not from the IRS right?", 'good': 'Nope!', 'bad': "..The what??"},
	{'q': "You better not be selling TRASH!", 'good': "I would never sell trash to such a fine rich man!", 'bad': "What does it matter to you snob?!!"},
	{'q': "Is there anything else?", 'good': "There's so much more!", 'bad': 'Nope, nothing else.'},
	{'q': "Why should I buy this?", 'good': "Because it's a masterpiece!", 'bad': "To give me money."},
	{'q': "What is your stance on filthy disgusting rats?", 'good': "Rats? Gross.", 'bad': "Rats aren't disgusting! Rude!!!"},
	{'q': "I need to know more!", 'good': "I have so much to tell you!", 'bad': "Well too bad!!!"}
]

var good_questions : Array[Dictionary] = [
	{'q': "This is very interesting...", 'good': "I knew you would like it!", 'bad': "It's just trash..."},
	{'q': "What is the significance of this art piece?", 'good': "It's made by a very famous and rich artist", 'bad': "Uhh... I think it looks really cool???"},
	{'q': "Where do you reside?", 'good': "In a giant mansion of course!", 'bad': "Over there in the smelly alleyway."},
	{'q': "Where did you find this art piece?", 'good': "I got it from the original artist at an auction.", 'bad': "In a smelly dumpster."},
	{'q': "I'm pretty convinced on purchasing this.", 'good': "That's great to hear!", 'bad': "Uhh... Are you sure you want this trash?"},
	{'q': "By jove! this is so cool!", 'good': "That's what I was thinking!", 'bad': 'Only weird people like you say "by jove" these days...'},
	{'q': "How do I know this is a good deal?", 'good': "My financial advisor says it's a great idea!", 'bad': "Trust me, it's definitely not trash..."},
	{'q': "Are you rather wealthy?", 'good': "Obviously yes!", 'bad': "I can barely afford my disgusting alleyway..."},
	{'q': "What's your favorite song?", 'good': "Rich corporate presentation music by Mr. Corporations!", 'bad': "Rats inna Nasty Hood Dumpster by GlaggleTunes"},
	{'q': "This seems like it has potential...", 'good': "It sure does!", 'bad': "I don't think so..."}
]

var good : int = randi_range(0,1)
var camera_line_index : int = 0
var target_line_x : float = 0
var satisfaction : float
var questions_answered : int = 0
var max_questions : int = 20
var last_question : Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.set_ui_sounds(click_and_hover)
	if Globals.first_time_minigame:
		Globals.question_speed_mult = 0.4
	else:
		Globals.question_speed_mult = 1
	Globals.question_speed_mult *= (0.75 + (float(Globals.rich_difficulty) / 4.0))
	if Globals.question_speed_mult == 0.75:
		Globals.question_speed_mult = 0.55 #easier easy
	timer.wait_time = 1 / Globals.question_speed_mult
	time_left.max_value = timer.wait_time
	satisfaction = 13
	if Globals.rich_difficulty == 0:
		satisfaction = 18
	customer_satisfaction.value = satisfaction
	name_text.text = "[center]Deal with " + Globals.rich_person_name
	add_to_graph(0.0)
	#more random feling
	for i in range(randi_range(0,2)):
		good_questions.remove_at(randi_range(0,len(good_questions) - 1))
		
	for i in range(randi_range(0,2)):
		neutral_questions.remove_at(randi_range(0,len(neutral_questions) - 1))
		
	for i in range(randi_range(0,2)):
		bad_questions.remove_at(randi_range(0,len(bad_questions) - 1))
		
	ask_question()
	
		
	
	
	

func _process(delta: float) -> void:
	if success_graph.position.x > target_line_x + 325:
		
		var tween : Tween = create_tween()
		tween.tween_property(success_graph, "position", Vector2(target_line_x, success_graph.position.y), 2).set_trans(Tween.TRANS_LINEAR)
	else:
		
		success_graph.position.x -= delta * 120
	while success_graph.get_point_position(camera_line_index).x < -success_graph.position.x + 320:
		camera_line_index += 1
	graph_camera.position.y = lerp(graph_camera.position.y, success_graph.get_point_position(camera_line_index).y, delta * 2)

	time_left.value = timer.time_left
	time_left.self_modulate = lerp(Color.RED, Color.GREEN, timer.time_left / timer.wait_time)

func ask_question() -> void:
	if questions_answered >= max_questions:
		help.queue_free()
		if satisfaction > (customer_satisfaction.max_value / 2):
			convinced.start()
		else:
			unconvinced.start()
		get_tree().paused = true
		return
	questions_answered += 1
	number.text = "[center]" + str(questions_answered) + "/" + str(max_questions) + " Questions Answered"
	number.modulate = lerp(Color.YELLOW, Color.GREEN, float(questions_answered) / float(max_questions))
	if not Globals.rich_difficulty == 0:
		Globals.question_speed_mult += 0.0075
		if Globals.first_time_minigame and Globals.question_speed_mult < 1:
			Globals.question_speed_mult += 0.02
	timer.wait_time = 1 / Globals.question_speed_mult
	time_left.max_value = timer.wait_time
	
	var question_dict : Dictionary = last_question
	
	while question_dict == last_question:
	
		var question_int : int = randi_range(0,len(bad_questions) - 1)
		question_dict = bad_questions[question_int]
			
		if satisfaction > customer_satisfaction.max_value / 3:
			question_int = randi_range(0,len(neutral_questions) - 1)
			question_dict = neutral_questions[question_int]
			
		if satisfaction > customer_satisfaction.max_value / 1.5:
			question_int = randi_range(0,len(good_questions) - 1)
			question_dict = good_questions[question_int]
		
	question.text = "[center]" + question_dict['q']
	good = randi_range(0,1)
	buttons.get_child(good).get_child(0).get_child(0).text = question_dict['good']
	buttons.get_child(posmod(good + 1, 2)).get_child(0).get_child(0).text = question_dict['bad']
	
	if start_anim.is_playing():
		await start_anim.animation_finished
	timer.start()
	last_question = question_dict
	
func add_to_graph(point : float) -> void:
	var new_points : Array = success_graph.points
	new_points.remove_at(len(new_points) - 1)
	var x_pos : int = -success_graph.position.x + 320
	for i in new_points:
		if i.x > x_pos:
			x_pos = i.x + 1
	new_points.append(Vector2(x_pos, new_points[len(new_points) - 1].y))
	new_points.append(Vector2(x_pos + 64 * randf_range(1,1.1), (point * randf_range(1,1.1))))
	target_line_x = -x_pos - (new_points[len(new_points) - 1].x - x_pos)
	new_points.append(Vector2(-success_graph.position.x + 1000000, new_points[len(new_points) - 1].y))
	success_graph.points = new_points


func _on_button_pressed(index : int) -> void:
	if not timer.time_left <= 0:
		timer.stop()
	
		if good == index:
			ding.play()
			correct_anim.play("show")
			satisfaction += 1
			customer_satisfaction.value = satisfaction
			add_to_graph((success_graph.points[len(success_graph.points) - 1].y - 48))
			success_graph.default_color = Color.GREEN
			await correct_anim.animation_finished
		else:
			buzzer.play()
			wrong_anim.play("show")
			satisfaction -= 2
			customer_satisfaction.value = satisfaction
			add_to_graph((success_graph.points[len(success_graph.points) - 1].y + (1 -  (time_left.value / time_left.max_value)) * 64) + 48)
			success_graph.default_color = Color.RED
			await wrong_anim.animation_finished
		satisfaction = clamp(satisfaction, 0, customer_satisfaction.max_value)
		ask_question()


func _on_timer_timeout() -> void:
	timer.stop()
	buzzer.play()
	time_up_anim.play("show")
	satisfaction -= 2
	customer_satisfaction.value = satisfaction
	add_to_graph((success_graph.points[len(success_graph.points) - 1].y + ((1 - (time_left.value / time_left.max_value)) * 64) + 48))
	success_graph.default_color = Color.RED
	await time_up_anim.animation_finished
	ask_question()
