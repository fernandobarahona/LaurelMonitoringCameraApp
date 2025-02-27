@tool
extends VBoxContainer

var photo_directory:String = "vibrations"
@onready var label_sector = %Label_Sector
@export var title = ""
@onready var evidences_container = $Evidences
const EVIDENCE = preload("res://Scenes/Evidence.tscn")
#const EVIDENCES_NUMBER = 3
const EVIDENCES:Array[String] = ["Axial","RadialVertical","RadialHorizontal"]
@onready var evidences = %Evidences

func _ready():
	label_sector.text = title
	generate_evidences()

func generate_evidences():
	var evidence:Evidence
	for i in EVIDENCES:
		evidence = EVIDENCE.instantiate()
		evidences_container.add_child(evidence)
		(evidence.label_sector as Label).queue_free()
		(evidence.label_data_type as Label).text = i
		evidence.evidence_name = self.get_name()+"_"+i
		evidence.name = self.get_name()+"_"+i
		evidence.sender_data = self

func get_photo_directory():
	return photo_directory
