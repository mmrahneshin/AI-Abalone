extends Node

export var pieces_path : NodePath
onready var pieces = get_node(pieces_path)
var white_piece = preload("res://Scenes/White Piece.tscn")
var black_piece = preload("res://Scenes/Black Piece.tscn")

func _ready():
	draw_complete_board(BoardManager.current_board)
	var first_board = BoardManager.current_board
	var state = State.new(first_board, 0,0)
	#var temp = Successor.calculate_successor(state,2)
	#print(temp)
	
	state = minimax_depth_limit(state, 2, 2)
	
	update_board(state.board)
	
	


func minimax_depth_limit(state, depth, number):
	var next_state = max_func(state, depth, number)
	return next_state
	

func max_func(state, depth, number):
	if state.black_score == 6 or state.white_score == 6 or depth <= 0:
		return state
	
	var max_value = -99999999999
	var legal_move
	if number == 2:
		legal_move = Successor.calculate_successor(state,2)
	else:
		legal_move = Successor.calculate_successor(state,1)
	for move in legal_move:
		var white_state = min_func(move, depth-1, number)
		var diff
		if number == 2:
			diff = white_state.white_score - white_state.black_score
		else:
			diff = white_state.black_score - white_state.white_score
		if  diff >= max_value:
			max_value = diff
			state = move
	return state



func min_func(state, depth, number):
	if state.black_score == 6 or state.white_score == 6 or depth <= 0:
		return state
	
	var min_value = 9999999999
	var legal_move
	if number == 2:
		legal_move = Successor.calculate_successor(state,1)
	else:
		legal_move = Successor.calculate_successor(state,2)
	for move in legal_move:
		var black_state = max_func(move, depth-1, number)
		var diff
		if number == 2:
			diff = black_state.white_score - black_state.black_score
		else:
			diff = black_state.black_score - black_state.white_score
		if  diff <= min_value:
			min_value = diff
			state = move
	return state

func update_board(new_board):
	for child in pieces.get_children():
		child.queue_free()
	draw_complete_board(new_board)

func draw_complete_board(board):
	var coordinates = Vector3(0, 0, 0)
	for cell_number in range(len(board)):
		if board[cell_number] == BoardManager.WHITE:
			coordinates = get_3d_coordinates(cell_number)
			var piece = white_piece.instance()
			pieces.add_child(piece)
			piece.translation = coordinates
		elif board[cell_number] == BoardManager.BLACK:
			coordinates = get_3d_coordinates(cell_number)
			var piece = black_piece.instance()
			pieces.add_child(piece)
			piece.translation = coordinates

func get_3d_coordinates(cell_number):
	if cell_number >= 0 and cell_number <= 4:
		return Vector3(-0.6 + cell_number * 0.3, 0.01, -1.04)
	elif cell_number >= 5 and cell_number <= 10:
		return Vector3(-0.75 + (cell_number - 5) * 0.3, 0.01, -0.78)
	elif cell_number >= 11 and cell_number <= 17:
		return Vector3(-0.9 + (cell_number - 11) * 0.3, 0.01, -0.52)
	elif cell_number >= 18 and cell_number <= 25:
		return Vector3(-1.05 + (cell_number - 18) * 0.3, 0.001, -0.26)
	elif cell_number >= 26 and cell_number <= 34:
		return Vector3(-1.2 + (cell_number - 26) * 0.3, 0.01, 0)
	elif cell_number >= 35 and cell_number <= 42:
		return Vector3(-1.05 + (cell_number - 35) * 0.3, 0.01, 0.26)
	elif cell_number >= 43 and cell_number <= 49:
		return Vector3(-0.9 + (cell_number - 43) * 0.3, 0.01, 0.52)
	elif cell_number >= 50 and cell_number <= 55:
		return Vector3(-0.75 + (cell_number - 50) * 0.3, 0.01, 0.78)
	else:
		return Vector3(-0.6 + (cell_number - 56) * 0.3, 0.01, 1.04)
	
