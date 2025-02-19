extends CanvasLayer

@onready var cursor: AnimatedSprite2D = $Menu/Cursor
@onready var select_sound: AudioStreamPlayer = $Menu/SelectSound
@onready var resume_button: Label = $Menu/ResumeButton
@onready var quit_button: Label = $Menu/QuitButton

enum State {Resume, Quit}

var state: State

func _ready() -> void:
	visible = false
	state = State.Resume

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and Global.current_level != 0:
		toggle_pause()
	
	# pause menu is active
	elif visible:
		handle_menu()

func handle_menu() -> void:
	# cursor position
	if state == State.Resume:
		cursor.position.y = resume_button.position.y + 10
	elif state == State.Quit:
		cursor.position.y = quit_button.position.y + 10
	
	# select an option
	if (Input.is_action_just_pressed("basic_slash") \
	or Input.is_action_just_pressed("dash") \
	or Input.is_action_just_pressed("magic_slash")):
		if state == State.Resume:
			toggle_pause()
		elif state == State.Quit:
			get_tree().quit()
	
	# choose option
	elif Input.is_action_just_pressed("up") \
	and state == State.Quit:
		state = State.Resume
		select_sound.play()
	
	elif Input.is_action_just_pressed("down") \
	and state == State.Resume:
		state = State.Quit
		select_sound.play()

func toggle_pause() -> void:
	state = State.Resume
	
	if not visible:
		visible = true
		get_tree().paused = true	
	else:
		visible = false
		get_tree().paused = false
