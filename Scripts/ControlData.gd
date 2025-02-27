class_name ControlData
extends ScrollContainer
@onready var time_stamp:String
@onready var photo_path:String
var dictionary_data:Dictionary = {}
var storage_directory:String
const ERROR_FILE = "ERROR ARCHIVO"
var storage_link
var error:String

func _init():
	photo_path = "user://pictures/"
	time_stamp = Time.get_datetime_string_from_datetime_dict(Time.get_datetime_dict_from_system(),false)
	storage_directory = "https://firebasestorage.googleapis.com/v0/b/godotdata.appspot.com/o/"
#func print_group():
	#for i:LineEdit in get_tree().get_nodes_in_group("evidence_data"):
			#print(i.owner.get_name())

func upload_data(sector_name:String,data_group:String)->Array:
	photo_path += sector_name
	storage_link = storage_directory+sector_name+"%2F"
	
	if not Autoload.email:
		set_error("Error obteniendo email de sesión.")
		return [false,error]
	dictionary_data["email"]=Autoload.email
	
	if not await upload_media_evidence(sector_name):
		return [false,error]
	if not await upload_document(sector_name,data_group):
		return [false,error]
	return [true,"Subido exitosamente."]

func upload_document(sector_name,data_group)->bool:
	get_numeric_data(data_group)
	var firestore_collection = Firebase.Firestore.collection(sector_name)
	
	var add_task: FirestoreTask = firestore_collection.add(time_stamp, dictionary_data)
	await add_task.task_finished
	#print (add_task.task_error)
	#print (add_task.result_query.connect())
	return true
	

func get_numeric_data(data_group):
	print(data_group)
	print(get_tree().get_nodes_in_group(data_group))
	for i:LineEdit in get_tree().get_nodes_in_group(data_group):
		if i.owner.get_name().contains("_"):
			var split_name = i.owner.get_name().split("_")
			var key = split_name[0]
			var value = split_name[1]
			dictionary_data[key][value]["data"] = i.text
		else:
			dictionary_data[i.owner.get_name()]["data"] = i.text

func upload_media_evidence(sector_name)->bool:
	var generated_link:String
	var file_name_firestore:String
	var file_name_no_ext:String
	var dir = DirAccess.open(photo_path)
	
	if not dir:
		set_error("Error encontrando archivo.")
		return false
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			continue
		file_name_no_ext = file_name.split(".")[0]
		
		file_name_firestore = await upload_to_storage(sector_name,file_name)
		if file_name_firestore == ERROR_FILE:
			return false
		
		generated_link = storage_link + file_name_firestore + "?alt=media"
		append_to_dictionary(file_name_no_ext,generated_link)
		file_name = dir.get_next()
		
	if dictionary_data.size() == 1:
		set_error("Evidencias no se pudieron agregar correctamente")
		return false
	return true

func append_to_dictionary(file_name:String,generated_link:String):
	if not file_name.contains("_"):
		dictionary_data[file_name] = {
			"link":generated_link
		}
	else:
		var split_name = file_name.split("_")
		var key = split_name[0]
		var value = split_name[1]
		if not dictionary_data.has(key):
			dictionary_data[key] = {}
		dictionary_data[key][value] = {
			"link":generated_link
		}

func upload_to_storage(sector,photo_name)->String:
	print("upload_to_storage "+sector +" "+photo_name)
	var file_name_firestore:String = time_stamp+photo_name
	var upload_task:StorageTask = Firebase.Storage.ref(sector+"/"+file_name_firestore).put_file(photo_path+"/"+ photo_name)
	await upload_task.task_finished
	if upload_task.result == 0 and upload_task.response_code == 200:
		return file_name_firestore
		# print(file_name_firestore)
	else:
		set_error("Error subiendo archivo: "+ str(upload_task.response_code) +" "+ photo_path+"/"+ photo_name +"a"+ sector+"/"+file_name_firestore)
		return ERROR_FILE

func set_error(message):
	error = "Reportar error: "+message
	print(error)
