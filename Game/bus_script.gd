extends RigidBody2D

class_name Bus
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

# The callback ref used by the API to restart the game
var _restart_callback_ref = JavaScriptBridge.create_callback(reset_game)

signal score_changed(score : int)
signal playing_changed(is_playing : bool)
signal failed_changed(failed : bool)
signal reset

var initial_x : float
var initial_y : float

var score := 0
var time := 0.0
var time_failed := 0.0

var playing := false
var failed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_x = position.x
	initial_y = position.y
	connect("body_entered", body_entered)
	
	# API Stuff (game_loaded hides the loading screen, and register_restart lets the wrapper restart the game)
	BussklubbenAPI.game_loaded()
	BussklubbenAPI.register_restart(_restart_callback_ref)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if playing && !failed:
		time += delta
		TreeGroup.speed = (sqrt(time*0.25)* 0.4 + 0.6 * clampf(time*0.5,0,1)) * 250
		if abs(position.y) > 960 && time > 0.5:
			set_failed(true)
	if failed:
		time_failed += delta

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Rotate bus relative to its vertical velocity
	state.transform.x = Vector2.RIGHT
	state.transform.y = Vector2.DOWN
	state.transform = state.transform.rotated_local(state.linear_velocity.y / 5000)
	if !playing:
		state.transform.origin.y = initial_y
		state.linear_velocity = Vector2.ZERO
	# Zero angular velocity to prevent spinning
	state.angular_velocity = 0.0
	# Constrain x position
	state.transform.origin.x = initial_x
	
func body_entered(body: Node) -> void:
	if body is TreeGroup && !failed:
		set_failed(true)

func _input(event):
	if event.is_action_pressed("Jump"):
		jump()
		
func jump() -> void:
	if !playing && !failed:
		set_playing(true)
	if playing && !failed:
		apply_central_impulse(Vector2(0,-1200))
		cpu_particles_2d.restart()
	
func increase_score() -> void:
	set_score(score + 1)
	
func set_score(new_score : int) -> void:
	score = new_score
	score_changed.emit(score)
	TreeGroup.difficulty = lerpf(0.25,1.0, clamp(score, 0, 15) / 15.0)
	
func set_playing(is_playing : bool) -> void:
	playing = is_playing
	playing_changed.emit(playing)
	gravity_scale = 2 if playing else 0
	

func set_failed(new_failed : bool) -> void:
	failed = new_failed
	failed_changed.emit(new_failed)
	if new_failed:
		linear_velocity = Vector2.ZERO
		gravity_scale = 0
		TreeGroup.speed = 0
		time = 0
		time_failed = 0.0
		BussklubbenAPI.set_score(score)
		BussklubbenAPI.game_done()
	
func reset_game(args) -> void:
	reset.emit()
	set_failed(false)
	set_playing(false)
	set_score(0)
