extends CharacterBody3D

@onready var navigationAgent = $NavigationAgent3D

const SPEED = 5
const MAXPOS = Vector3(99999, 99999, 99999)

func _ready():
	checkTarget()

func _process(delta):
	if navigationAgent.is_target_reached():
		return
	moveToPoint(delta, SPEED)
	navigationAgent.get_next_path_position()

func moveToPoint(_delta, speed):
	var targetPos = navigationAgent.target_position
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	velocity = direction * speed 
	move_and_slide()

func faceDirection(direction):
	var lookAtPos := Vector3(direction.x, global_position.y, direction.z)
	if lookAtPos != self.position:
		look_at(lookAtPos, Vector3.UP)

func checkTarget():
	var targetPos = MAXPOS
	var enemyTowerLocations = get_tree().get_nodes_in_group("Enemy Tower Locations")
	for i in enemyTowerLocations.size():
		var towerPos = enemyTowerLocations[i].global_position
		var newDistanceToTower = self.global_position.distance_to(towerPos)
		var currDistanceToTower = self.global_position.distance_to(targetPos)
		if newDistanceToTower < currDistanceToTower:
			targetPos = towerPos
	navigationAgent.target_position = targetPos
