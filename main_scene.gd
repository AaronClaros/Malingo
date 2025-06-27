extends Node2D
@onready var main_menu: BoxContainer = $UI/MainMenu
@onready var button_start: Button = $UI/MainMenu/CenterContainer2/BoxContainer/ButtonStart
@onready var button_exit: Button = $UI/MainMenu/CenterContainer2/BoxContainer/ButtonExit
@onready var text_banned_words: RichTextLabel = $UI/MainMenu/CenterContainer2/BoxContainer/TextBannedWords
@onready var exercise_menu: BoxContainer = $UI/ExerciseMenu
@onready var text_challenges_index: RichTextLabel = $UI/ExerciseMenu/VBoxContainer/TextChallengesIndex
@onready var english_word_r_tlabel: RichTextLabel = $UI/ExerciseMenu/CenterContainer/BoxContainer/EnglishWordRTlabel
@onready var button_option_a: Button = $UI/ExerciseMenu/CenterContainer/BoxContainer/ButtonOptionA
@onready var button_option_b: Button = $UI/ExerciseMenu/CenterContainer/BoxContainer/ButtonOptionB
@onready var button_option_c: Button = $UI/ExerciseMenu/CenterContainer/BoxContainer/ButtonOptionC
@onready var malingo_message: BoxContainer = $UI/MalingoMessage
@onready var text_new_banned_word_1: RichTextLabel = $UI/MalingoMessage/CenterContainer/BoxContainer/BoxContainer2/TextNewBannedWord1
@onready var text_new_banned_word_2: RichTextLabel = $UI/MalingoMessage/CenterContainer/BoxContainer/BoxContainer2/TextNewBannedWord2
@onready var text_new_banned_word_3: RichTextLabel = $UI/MalingoMessage/CenterContainer/BoxContainer/BoxContainer2/TextNewBannedWord3
@onready var text_new_banned_word_4: RichTextLabel = $UI/MalingoMessage/CenterContainer/BoxContainer/BoxContainer2/TextNewBannedWord4
@onready var text_new_banned_word_5: RichTextLabel = $UI/MalingoMessage/CenterContainer/BoxContainer/BoxContainer2/TextNewBannedWord5
@onready var button_play_again: Button = $UI/MalingoMessage/CenterContainer/BoxContainer/BoxContainer3/ButtonPlayAgain
@onready var button_exit_game: Button = $UI/MalingoMessage/CenterContainer/BoxContainer/BoxContainer3/ButtonExitGame
@onready var game_over_banned_words: RichTextLabel = $UI/MalingoMessage/CenterContainer/BoxContainer/GameOverBannedWords

var exerciseIndex = 0
var exerciseIndexMax = 5
var challengesArray:Array[Dictionary] = []
var currentEngWord = ""
var currentSpaOptions = ["","",""]
var bannedWords = []
var newBannedWords:PackedStringArray = []
#dictionary english - spanish, size 100
var english_to_spanish = {
	"hello": "hola",
	"goodbye": "adios",
	"thank you": "gracias",
	"please": "por favor",
	"yes": "si",
	"no": "no",
	"water": "agua",
	"food": "comida",
	"house": "casa",
	"car": "coche",
	"dog": "perro",
	"cat": "gato",
	"man": "hombre",
	"woman": "mujer",
	"child": "niño",
	"friend": "amigo",
	"family": "familia",
	"time": "tiempo",
	"day": "dia",
	"night": "noche",
	"morning": "mañana",
	"afternoon": "tarde",
	"evening": "tarde",
	"week": "semana",
	"month": "mes",
	"year": "año",
	"today": "hoy",
	"tomorrow": "mañana",
	"yesterday": "ayer",
	"now": "ahora",
	"later": "luego",
	"soon": "pronto",
	"always": "siempre",
	"never": "nunca",
	"sometimes": "a veces",
	"big": "grande",
	"small": "pequeño",
	"good": "bueno",
	"bad": "malo",
	"happy": "feliz",
	"sad": "triste",
	"beautiful": "hermoso",
	"ugly": "feo",
	"hot": "caliente",
	"cold": "frio",
	"new": "nuevo",
	"old": "viejo",
	"young": "joven",
	"right": "derecho",
	"left": "izquierdo",
	"up": "arriba",
	"down": "abajo",
	"near": "cerca",
	"far": "lejos",
	"easy": "facil",
	"difficult": "dificil",
	"fast": "rapido",
	"slow": "lento",
	"work": "trabajo",
	"school": "escuela",
	"book": "libro",
	"pen": "pluma",
	"paper": "papel",
	"computer": "computadora",
	"phone": "telefono",
	"money": "dinero",
	"city": "ciudad",
	"country": "pais",
	"street": "calle",
	"number": "numero",
	"color": "color",
	"red": "rojo",
	"blue": "azul",
	"green": "verde",
	"yellow": "amarillo",
	"black": "negro",
	"white": "blanco",
	"one": "uno",
	"two": "dos",
	"three": "tres",
	"four": "cuatro",
	"five": "cinco",
	"six": "seis",
	"seven": "siete",
	"eight": "ocho",
	"nine": "nueve",
	"ten": "diez",
	"first": "primero",
	"second": "segundo",
	"third": "tercero",
	"last": "ultimo",
	"name": "nombre",
	"age": "edad",
	"birthday": "cumpleaños",
	"language": "idioma",
	"english": "ingles",
	"spanish": "español",
	"question": "pregunta",
	"answer": "respuesta",
	"true": "verdad",
	"false": "falso"
}

func _ready() -> void:
	main_menu.show()
	exercise_menu.hide()
	malingo_message.hide()
	button_start.pressed.connect(startGame)
	button_exit.pressed.connect(exitGame)
	button_play_again.pressed.connect(startGame)
	button_exit_game.pressed.connect(exitGame)
	LoadBannedWords()
	UpdateBannedWordsRTLabel()

func _input(event: InputEvent) -> void:
	if event.is_action_released("simulateDaemon"):
		InvokeMalingoDaemon(["correr","gritar"])

func UpdateBannedWordsRTLabel():
	var labelStrArray = [
		"[b]Palabras Prohibidas:[/b]",
		PackedStringArray(bannedWords)
	]
	text_banned_words.text = "\n".join(labelStrArray)

func UpdateGameOverBannedWordsRTLabel():
	var labelStrArray = [
		"[b]Palabras Prohibidas:[/b]",
		PackedStringArray(bannedWords)
	]
	game_over_banned_words.text = "\n".join(labelStrArray)

func UpdateChallengesIndexRTlabel():
	text_challenges_index.text = "Pruebas Superadas: %d/%d" % [exerciseIndex,exerciseIndexMax]

func startGame():
	malingo_message.hide()
	main_menu.hide()
	exerciseIndex = 0
	newBannedWords.clear()
	newBannedWords.resize(5)
	challengesArray.clear()
	challengesArray = [
		GetEnglishWordAndSpanishOptions(),
		GetEnglishWordAndSpanishOptions(),
		GetEnglishWordAndSpanishOptions(),
		GetEnglishWordAndSpanishOptions(),
		GetEnglishWordAndSpanishOptions(),
	]
	SetupExerciseMenu(challengesArray[exerciseIndex])

func exitGame():
	get_tree().quit()

func ChangeExerciseIndexToNext():
	exerciseIndex+=1
	
func SetupExerciseMenu(challengesData:Dictionary):
	UpdateChallengesIndexRTlabel()
	exercise_menu.show()
	for engWord in challengesData:
		currentEngWord = engWord
		english_word_r_tlabel.text = engWord
		var optionsArray = challengesData.get(engWord) as Array
		currentSpaOptions = optionsArray
		currentSpaOptions.shuffle()
		button_option_a.text = currentSpaOptions[0]
		button_option_b.text = currentSpaOptions[1]
		button_option_c.text = currentSpaOptions[2]

func SetupGameOverMessage():
	exercise_menu.hide()
	main_menu.hide()
	text_new_banned_word_1.text = newBannedWords[0]
	text_new_banned_word_2.text = newBannedWords[1]
	text_new_banned_word_3.text = newBannedWords[2]
	text_new_banned_word_4.text = newBannedWords[3]
	text_new_banned_word_5.text = newBannedWords[4]
	for nWord in newBannedWords:
		if nWord.length()>0 and !bannedWords.has(nWord):
			bannedWords.append(nWord)
	UpdateGameOverBannedWordsRTLabel()
	malingo_message.show()
	InvokeMalingoDaemon(bannedWords)

func InvokeMalingoDaemon(forbidenWords):
	#var bannedWordsModified = forbidenWords
	#for word:String in forbidenWords:
		#if word.length()>0 and !bannedWordsModified.has(word):
			#bannedWordsModified.append(word)
	SaveBannedWords(forbidenWords)
	var exePath = ""
	if OS.has_feature("editor"):
		exePath = "D:/Projects Godot/malingo/m.exe"
	else:
		exePath = OS.get_executable_path()
	print("exePath: " + exePath)
	var exePathArray = exePath.split("/")
	exePathArray[exePathArray.size()-1] = "malingo_daemon.exe"
	var malingoPath = "/".join(exePathArray)
	print("malingoPath: " + malingoPath)
	OS.execute_with_pipe(malingoPath,forbidenWords)

func GetEnglishWordAndSpanishOptions()->Dictionary:
	var spaOptions = PackedStringArray() #create array for spanish translation options
	var randomEngWord = english_to_spanish.keys().pick_random()#get random english word
	var randomEngWordTraduction = english_to_spanish.get(randomEngWord,"") #get random english word translation to spanish
	while spaOptions.size()<2:
		var newSpaOption = english_to_spanish.values().pick_random()#get random word
		if !spaOptions.has(newSpaOption) and newSpaOption != randomEngWordTraduction:
			spaOptions.append(newSpaOption)
	spaOptions.append(randomEngWordTraduction)
	return {randomEngWord:spaOptions}

func ValidateOptionIsCorrect(englishWord, selectedOptionText):
	return selectedOptionText == english_to_spanish.get(englishWord,"")

func LoadBannedWords():
	if not FileAccess.file_exists("user://malingo.save"):
		return # Error! We don't have a save to load.
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://malingo.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# Creates the helper class to interact with JSON.
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object.
		var saved_data = json.data
		bannedWords = PackedStringArray(saved_data["bannedWords"])


func SaveBannedWords(bannedWordsArray:Array):
	var save_file = FileAccess.open("user://malingo.save", FileAccess.WRITE)
	# JSON provides a static method to serialized JSON string.
	var save_data = {
		"bannedWords":bannedWordsArray
	}
	var json_string = JSON.stringify(save_data)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)


func _on_button_option_a_pressed(extra_arg_0: int) -> void:
	var isValidAnswer = ValidateOptionIsCorrect(currentEngWord,currentSpaOptions[extra_arg_0])
	if isValidAnswer:
		print("Valid Answer")
	else:
		newBannedWords.append(english_to_spanish.get(currentEngWord))
		print("Wrong Answer")
	ChangeExerciseIndexToNext()
	if exerciseIndex<challengesArray.size():
		SetupExerciseMenu(challengesArray[exerciseIndex])
	else:
		SetupGameOverMessage()

func _on_button_option_b_pressed(extra_arg_0: int) -> void:
	var isValidAnswer = ValidateOptionIsCorrect(currentEngWord,currentSpaOptions[extra_arg_0])
	if isValidAnswer:
		print("Valid Answer")
	else:
		newBannedWords.append(english_to_spanish.get(currentEngWord))
		print("Wrong Answer")
	ChangeExerciseIndexToNext()
	if exerciseIndex<challengesArray.size():
		SetupExerciseMenu(challengesArray[exerciseIndex])
	else:
		SetupGameOverMessage()

func _on_button_option_c_pressed(extra_arg_0: int) -> void:
	var isValidAnswer = ValidateOptionIsCorrect(currentEngWord,currentSpaOptions[extra_arg_0])
	if isValidAnswer:
		print("Valid Answer")
	else:
		newBannedWords.append(english_to_spanish.get(currentEngWord))
		print("Wrong Answer")
	ChangeExerciseIndexToNext()
	if exerciseIndex<challengesArray.size():
		SetupExerciseMenu(challengesArray[exerciseIndex])
	else:
		SetupGameOverMessage()
