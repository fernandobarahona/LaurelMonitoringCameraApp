extends Control

func _ready():
	(%Label_username as Label).text = Autoload.email
	(%Label_rol as Label).text = Autoload.rol
	if Autoload.rol=="operador":
		(%Button_fluviometro as Button).disabled = false
	create_android_directory()

func create_android_directory():
	var dir = DirAccess.open("user://")
	dir.make_dir("pictures")
	

func _on_button_vibraciones_pressed():
	get_tree().change_scene_to_file("res://Scenes/VibrationsData.tscn")


func _on_button_presion_pressed():
	get_tree().change_scene_to_file("res://Scenes/PressuresData.tscn")


func _on_button_fluviometro_pressed():
	get_tree().change_scene_to_file("res://Scenes/FluviometerData.tscn")


func _on_button_logout_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://Scenes/Login.tscn")
