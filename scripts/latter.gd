extends Node3D
class_name Note3d

@export var use_text: String = "Press [E]"
@export var note_contents:String = ""
@onready var note_mesh:CSGBox3D = $NoteMesh
@onready var collision_shap_3d: CollisionShape3D = $Area3D/CollisionShape3D
var player:Player



func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
func interact():
	player.show_note(self)
	print("pla pla")
	collision_shap_3d.disabled = true
	note_mesh.hide()
	pass
