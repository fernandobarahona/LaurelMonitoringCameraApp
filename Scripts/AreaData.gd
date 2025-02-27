class_name AreaData
extends Control

const _plugin_name = "CameraWatermarkGodot"
const DATA_GROUP = "evidence_data"
const PHOTOS_GROUP = "evidence_photos"
var _android_plugin
#get the first child of the node
@onready var control_data:ControlData = self.get_child(0)

#REQUIRED
@onready var button_upload_data = %Button_UploadData
@onready var label_username = %Label_username
#REQUIRED pressures fluviometer or vibrations  
@export var photo_directory:String                   

func _ready():               
	label_username.text = Autoload.email
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
	else:
		printerr("Couldn't find plugin " + _plugin_name)

func _on_button_upload_data_pressed():
	#($ControlPresionData as ControlData).print_group()
	if not _android_plugin:
		printerr("Couldn't find plugin " + _plugin_name)
		return
	if check_submitted_data():
	#if true:	
		button_upload_data.disabled = true
		_android_plugin.descriptionToast("Cargando datos...")
		var response:Array = await control_data.upload_data(photo_directory,DATA_GROUP) 
		_android_plugin.restartApp(response[1])


func get_photo_directory():
	return photo_directory

func check_submitted_data()->bool:
	return check_numeric_data() and check_media_data()
		
func check_numeric_data()->bool:
	var text:String = ""
	var regex:RegEx = RegEx.new()
	regex.compile("^[0-9]+(,[0-9]+)?$")
	for i:LineEdit in get_tree().get_nodes_in_group(DATA_GROUP):
		if i.text.is_empty():
			_android_plugin.descriptionToast("Faltan datos numéricos")
			return false
		if regex.search(i.text) == null:
			_android_plugin.descriptionToast("Datos numéricos incorrectos")
			return false
		
	return true
	
func check_media_data()->bool:
	for i:TextureRect in get_tree().get_nodes_in_group(PHOTOS_GROUP):
		if i.get_meta("original"):
			_android_plugin.descriptionToast("Faltan evidencias fotográficas")
			return false
	return true

func _on_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://Scenes/Login.tscn")

func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
