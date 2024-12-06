extends Label

@export var invert_hidden := false

var wrap_text := "%s"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wrap_text = text
	set_score(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_score(score : int) -> void:
	text = wrap_text % str(score)
	
func set_label_hidden(hidden : bool) -> void:
	if invert_hidden:
		visible = hidden
	else:
		visible = !hidden
