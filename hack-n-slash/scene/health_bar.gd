extends ProgressBar

var parent
var health_max:int
var health_min:int
var health:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	health_max = parent.health_max
	health_min = parent.health_min
	self.min_value = health_min
	self.max_value = health_max

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health = parent.health
	if health != health_max:
		self.visible = true
		if health <= health_min:
			self.visible = false
		self.value = health
	else:
		self.visible = false
