extends Node

@onready var email
@onready var rol

func load_global_user_session():
	email = Firebase.Auth.auth.email
	rol = await get_user_rol()

func reload_global_user_session():
	if Firebase.Auth.check_auth_file():
		email = Firebase.Auth.auth.email
		rol = await get_user_rol()
		
func get_user_rol()->String:
	var query : FirestoreQuery = FirestoreQuery.new().from("users").where("email",FirestoreQuery.OPERATOR.EQUAL,Autoload.email).limit(1)
	var result:Array = await Firebase.Firestore.query(query).result_query
	return result[0]["doc_fields"]["rol"]

