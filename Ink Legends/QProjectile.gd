extends Node3D

@onready var hitbox = $MeshInstance3D/Hitbox

var targetPos = null

var VELOCITY = .25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if targetPos and position.distance_to(targetPos) < .5:
		queue_free()
	if targetPos and !targetPos.is_equal_approx(self.position):
		look_at(targetPos)
		var targetDirection = position.direction_to(targetPos).normalized()
		position =  position + VELOCITY * targetDirection

func _on_hit_box_body_entered(body):
	if body.is_in_group("Enemy Minions"):
		body.takeDamage(10)
		queue_free()
