extends Control

var remember_session := false
var _plugin_name = "CameraWatermarkGodot"

func _ready():
	if Firebase.Auth.check_auth_file():
		self.hide()
		await Autoload.reload_global_user_session()
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)

func on_login_succeeded(auth):
	#Engine.get_singleton(_plugin_name).descriptionToast("Iniciando sesión")
	if (remember_session):
		Firebase.Auth.save_auth(auth)
	await Autoload.load_global_user_session()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	

func on_login_failed(error_code, message):
	Engine.get_singleton(_plugin_name).descriptionToast("Error al ingresar"+message)
	print("Login failed: ", error_code, message)

func _on_button_login_pressed():
	var email = %LineEdit_username.text
	var password = %LineEdit_password.text
	Firebase.Auth.login_with_email_and_password(email,password)

func _on_check_box_remember_session_pressed():
	remember_session = !remember_session
