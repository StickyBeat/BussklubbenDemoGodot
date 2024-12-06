extends Control

@export var invert := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_node_visible(value : bool) -> void:
	if invert:
		visible = !value
	else:
		visible = value
