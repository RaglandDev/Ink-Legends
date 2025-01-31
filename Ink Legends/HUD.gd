extends CanvasLayer

@onready var playerBody = $".."
@onready var health = $Control/Bottom/HIBar/Health
@onready var ink = $Control/Bottom/HIBar/Ink

# Called when the node enters the scene tree for the first time.
func _ready():
	health.value = playerBody.hp
	ink.value = playerBody.ink
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
