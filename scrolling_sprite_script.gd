extends Sprite2D

var shader_mat : ShaderMaterial
var offset_x := 0.0

@export var relative_speed := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_mat = material as ShaderMaterial
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset_x += TreeGroup.speed * delta * relative_speed
	shader_mat.set_shader_parameter("offset", Vector2(offset_x,0.0))
