extends Camera3D

const THRESHOLD = 50
const STEP = .5

@onready var viewportSize = get_viewport().size

func _process(_delta):
	var localMousePos = get_viewport().get_mouse_position()
	edgeScroll(localMousePos.x, localMousePos.y)

func edgeScroll(x, y):
	var moveDirection = Vector3.ZERO
	if x < THRESHOLD:
		moveDirection.x -= STEP  # Move left
	if x > viewportSize.x - THRESHOLD:
		moveDirection.x += STEP  # Move right
	if y < THRESHOLD:
		moveDirection.z -= STEP  # Move forward 
	if y > viewportSize.y - THRESHOLD:
		moveDirection.z += STEP  # Move backward
	if moveDirection.length() > 0:
		moveDirection = moveDirection.normalized() * STEP

	position += moveDirection
