extends Node2D

var number_disabled : int = 0
var cost : int = 100
var block : bool = false

func main_check(button_pressed:bool,id:int):
	if button_pressed == true:
		if number_disabled < 5 and owner.mon >= cost:
			owner.show_item_disable_cost(false)
			owner.mon -= cost
			owner.mon_label.text = str(owner.mon)
			number_disabled += 1
			Globals.disabled_items.append(id)
			cost = update_cost(number_disabled)
			owner.item_dis_count.text = str(number_disabled) + "/5"
		else:
			block = true
			get_child(id).button_pressed = false
			if owner.mon < cost:
				owner.anim_player_2.play("not_enough_mon")
	else:
		if block:
			block = false
			return
		number_disabled -= 1
		cost = update_cost(number_disabled)
		owner.mon += cost
		owner.mon_label.text = str(owner.mon)
		Globals.disabled_items.erase(id)
		owner.item_dis_count.text = str(number_disabled) + "/5"
		

func update_cost(num_disabled:int):
	var new_cost
	match num_disabled:
		0: new_cost = 100
		1: new_cost = 150
		2: new_cost = 200
		3: new_cost = 400
		4: new_cost = 800
		5: new_cost = 800
	return new_cost

func mouse_entered(show_val:bool,id):
	if number_disabled < 5:
		if get_child(id).button_pressed:
			pass
		else:
			owner.item_disable_cost_label.text = str(cost)
			owner.show_item_disable_cost(show_val)

func _on_check_box_toggled(button_pressed):
	main_check(button_pressed,0)

func _on_check_box_2_toggled(button_pressed):
	main_check(button_pressed,1)

func _on_check_box_3_toggled(button_pressed):
	main_check(button_pressed,2)

func _on_check_box_4_toggled(button_pressed):
	main_check(button_pressed,3)

func _on_check_box_5_toggled(button_pressed):
	main_check(button_pressed,4)

func _on_check_box_6_toggled(button_pressed):
	main_check(button_pressed,5)

func _on_check_box_7_toggled(button_pressed):
	main_check(button_pressed,6)

func _on_check_box_8_toggled(button_pressed):
	main_check(button_pressed,7)

func _on_check_box_9_toggled(button_pressed):
	main_check(button_pressed,8)

func _on_check_box_10_toggled(button_pressed):
	main_check(button_pressed,9)

func _on_check_box_11_toggled(button_pressed):
	main_check(button_pressed,10)

func _on_check_box_12_toggled(button_pressed):
	main_check(button_pressed,11)

func _on_check_box_13_toggled(button_pressed):
	main_check(button_pressed,12)

func _on_check_box_14_toggled(button_pressed):
	main_check(button_pressed,13)

func _on_check_box_15_toggled(button_pressed):
	main_check(button_pressed,14)

func _on_check_box_16_toggled(button_pressed):
	main_check(button_pressed,15)

func _on_check_box_17_toggled(button_pressed):
	main_check(button_pressed,16)

func _on_check_box_18_toggled(button_pressed):
	main_check(button_pressed,17)

func _on_check_box_19_toggled(button_pressed):
	main_check(button_pressed,18)

func _on_check_box_20_toggled(button_pressed):
	main_check(button_pressed,19)

func _on_check_box_21_toggled(button_pressed):
	main_check(button_pressed,20)

func _on_check_box_22_toggled(button_pressed):
	main_check(button_pressed,21)

func _on_check_box_23_toggled(button_pressed):
	main_check(button_pressed,22)

func _on_check_box_24_toggled(button_pressed):
	main_check(button_pressed,23)

func _on_check_box_25_toggled(button_pressed):
	main_check(button_pressed,24)

func _on_check_box_26_toggled(button_pressed):
	main_check(button_pressed,25)

func _on_check_box_27_toggled(button_pressed):
	main_check(button_pressed,26)

##############################################################

func _on_check_box_mouse_entered():
	mouse_entered(true,0)

func _on_check_box_2_mouse_entered():
	mouse_entered(true,1)

func _on_check_box_3_mouse_entered():
	mouse_entered(true,2)

func _on_check_box_4_mouse_entered():
	mouse_entered(true,3)

func _on_check_box_5_mouse_entered():
	mouse_entered(true,4)

func _on_check_box_6_mouse_entered():
	mouse_entered(true,5)

func _on_check_box_7_mouse_entered():
	mouse_entered(true,6)

func _on_check_box_8_mouse_entered():
	mouse_entered(true,7)

func _on_check_box_9_mouse_entered():
	mouse_entered(true,8)

func _on_check_box_10_mouse_entered():
	mouse_entered(true,9)

func _on_check_box_11_mouse_entered():
	mouse_entered(true,10)

func _on_check_box_12_mouse_entered():
	mouse_entered(true,11)

func _on_check_box_13_mouse_entered():
	mouse_entered(true,12)

func _on_check_box_14_mouse_entered():
	mouse_entered(true,13)

func _on_check_box_15_mouse_entered():
	mouse_entered(true,14)

func _on_check_box_16_mouse_entered():
	mouse_entered(true,15)

func _on_check_box_17_mouse_entered():
	mouse_entered(true,16)

func _on_check_box_18_mouse_entered():
	mouse_entered(true,17)

func _on_check_box_19_mouse_entered():
	mouse_entered(true,18)

func _on_check_box_20_mouse_entered():
	mouse_entered(true,19)

func _on_check_box_21_mouse_entered():
	mouse_entered(true,20)

func _on_check_box_22_mouse_entered():
	mouse_entered(true,21)

func _on_check_box_23_mouse_entered():
	mouse_entered(true,22)

func _on_check_box_24_mouse_entered():
	mouse_entered(true,23)

func _on_check_box_25_mouse_entered():
	mouse_entered(true,24)

func _on_check_box_26_mouse_entered():
	mouse_entered(true,25)

func _on_check_box_27_mouse_entered():
	mouse_entered(true,26)

#######################################################

func _on_check_box_mouse_exited():
	mouse_entered(false,0)

func _on_check_box_2_mouse_exited():
	mouse_entered(false,1)

func _on_check_box_3_mouse_exited():
	mouse_entered(false,2)

func _on_check_box_4_mouse_exited():
	mouse_entered(false,3)

func _on_check_box_5_mouse_exited():
	mouse_entered(false,4)

func _on_check_box_6_mouse_exited():
	mouse_entered(false,5)

func _on_check_box_7_mouse_exited():
	mouse_entered(false,6)

func _on_check_box_8_mouse_exited():
	mouse_entered(false,7)

func _on_check_box_9_mouse_exited():
	mouse_entered(false,8)

func _on_check_box_10_mouse_exited():
	mouse_entered(false,9)

func _on_check_box_11_mouse_exited():
	mouse_entered(false,10)

func _on_check_box_12_mouse_exited():
	mouse_entered(false,11)

func _on_check_box_13_mouse_exited():
	mouse_entered(false,12)

func _on_check_box_14_mouse_exited():
	mouse_entered(false,13)

func _on_check_box_15_mouse_exited():
	mouse_entered(false,14)

func _on_check_box_16_mouse_exited():
	mouse_entered(false,15)

func _on_check_box_17_mouse_exited():
	mouse_entered(false,16)

func _on_check_box_18_mouse_exited():
	mouse_entered(false,17)

func _on_check_box_19_mouse_exited():
	mouse_entered(false,18)

func _on_check_box_20_mouse_exited():
	mouse_entered(false,19)

func _on_check_box_21_mouse_exited():
	mouse_entered(false,20)

func _on_check_box_22_mouse_exited():
	mouse_entered(false,21)

func _on_check_box_23_mouse_exited():
	mouse_entered(false,22)

func _on_check_box_24_mouse_exited():
	mouse_entered(false,23)

func _on_check_box_25_mouse_exited():
	mouse_entered(false,24)

func _on_check_box_26_mouse_exited():
	mouse_entered(false,25)

func _on_check_box_27_mouse_exited():
	mouse_entered(false,26)
