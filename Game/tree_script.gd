extends StaticBody2D

class_name TreeGroup

static var speed := 0.0
static var difficulty := 0.25

@onready var area_2d: Area2D = $Area2D
@onready var tree_1: Sprite2D = $Tree1
@onready var tree_1_collision: CollisionPolygon2D = $Tree1Collision
@onready var tree_2: Sprite2D = $Tree2
@onready var tree_2_collision: CollisionPolygon2D = $Tree2Collision

@export var randomize_on_start := true

var activated := false
var start_x : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_x = position.x
	if randomize_on_start:
		randomize_tree()

func body_entered(body: Node2D) -> void:
	if !activated && body.name == "Bus":
		activated = true
		body.increase_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move trees to the left
	position.x -= delta * speed
	# Magic number offset to jump back to the end of the trees. This is based on the fact that there are four trees with an offset of 700 and the first starts at 400
	if position.x <= -1000:
		position.x += 2800
		randomize_tree()
		activated = false
		
func randomize_tree() -> void:
	var tree_1_y = 650 + (randi_range(-1, 1) * 275.0 * difficulty)
	tree_1.position.y = tree_1_y
	tree_1_collision.position.y = tree_1_y
	
	var tree_2_y = tree_1_y - 1600 + randf_range(150,400) * difficulty
	tree_2.position.y = tree_2_y
	tree_2_collision.position.y = tree_2_y

func reset() -> void:
	position.x = start_x
	activated = false
	if randomize_on_start:
		randomize_tree()
	else:
		var tree_1_y = 700
		tree_1.position.y = tree_1_y
		tree_1_collision.position.y = tree_1_y
		
		var tree_2_y = tree_1_y - 1500
		tree_2.position.y = tree_2_y
		tree_2_collision.position.y = tree_2_y
