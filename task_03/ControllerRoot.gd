extends Node3D


func _ready():
	$"./Fire/FirePlayer".play("amin_fire")


func _on_button_back_pressed():
	var parent = get_parent()
	while parent != null && not 'reload_ui' in parent:
		parent = parent.get_parent()
	if parent != null:
		parent.call('reload_ui')
