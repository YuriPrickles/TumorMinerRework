class_name Language
var name:String="English"
var dialog:Dictionary[String,Array]
func get_dialog(key:String):
	var returned_dialog:Array = dialog.get(key,[key])
	if returned_dialog.size() == 1:
		return returned_dialog[0]
	return returned_dialog

static func from_txt(path:String)->Language:
	var language = Language.new()
	var file = FileAccess.open(path, FileAccess.READ)
	var lines_arr:PackedStringArray = file.get_as_text().split("\n")
	var any_dialogue_key:String
	var dialogue_array:Array
	var regex_dialogkey:RegEx = RegEx.create_from_string("^\\w+\\=.*")
	for line:String in lines_arr:
		if line and line[0] != "#":
			line = line.replace("\\n","\n")
			if regex_dialogkey.search(line) or line == "END_OF_DIALOG_FILE":
				var split_line := line.split("=",true,1)
				if any_dialogue_key:
					#print("dialog key: %s"%str(any_dialogue_key))
					#print("dialog array: %s"%str(dialogue_array))
					language.dialog[any_dialogue_key.trim_suffix("=")] = dialogue_array.duplicate()
					dialogue_array.clear()
					if line == "END_OF_DIALOG_FILE":
						print("reached end of loaded language!")
						break
				if split_line and split_line.size() == 2:
					line=split_line[0]
					if split_line[1]:
						dialogue_array.append(split_line[1])
				any_dialogue_key = line
			else:
				dialogue_array.append(line)
	return language
