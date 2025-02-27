@tool
class_name Evidence
extends VBoxContainer
@onready var evidence_name = self.get_name()
@onready var label_data_type = %Label_dataType
@onready var texture_rect_photo = %TextureRect_photo
@onready var label_sector = %Label_Sector
@onready var line_edit_s_1_p_1 = %LineEdit_S1_P1
@onready var button_decimal = %Button_decimal
@export var label_text:String = ""

@onready var sender_data = self.owner
@export var is_decimal = true
var decimal_pressed = false

@export var label_data_sector:String = ""
const _plugin_name = "CameraWatermarkGodot"
var _android_plugin

func _ready():
	label_data_type.text = label_text
	label_sector.text = label_data_sector
	if not is_decimal:
		button_decimal.queue_free()

func open_camara()->void:
	connect_android_signal()
	_android_plugin.openCamera(evidence_name,sender_data.get_photo_directory())
	
func connect_android_signal():
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
		_android_plugin.connect("update_photo",update_photo,CONNECT_ONE_SHOT)
	else:
		printerr("Couldn't find plugin " + _plugin_name)

#Android Signal
func update_photo(photo_path:String):
	if photo_path.is_empty():
		reeplace_evidence_photo("res://assets/camera-add-photo-svgrepo-com.svg",true)
		return
	reeplace_evidence_photo(photo_path,false)

func reeplace_evidence_photo(photo_path:String,is_original:bool):
	var _dir = DirAccess.open(photo_path)
	var image_path = photo_path
	var image = Image.new()
	image.load(image_path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	texture_rect_photo.texture = image_texture
	texture_rect_photo.set_meta("original",is_original)

func _on_button_data_pressed():
	open_camara()

func update_comma():
	if not decimal_pressed:
		line_edit_s_1_p_1.text += ","
		decimal_pressed = true
	else:
		line_edit_s_1_p_1.text = (line_edit_s_1_p_1.text as String).replace(",","")
		decimal_pressed = false

func _on_button_pressed():
	update_comma()
