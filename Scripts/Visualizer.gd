extends Node

export var pieces_path : NodePath
onready var pieces = get_node(pieces_path)
var white_piece = preload("res://Scenes/White Piece.tscn")
var black_piece = preload("res://Scenes/Black Piece.tscn")

var circle1 = [21,22,31,39,38,29]
var circle2 = [13,14,15,23,32,40,47,46,45,37,28,20]
var circle3 = [6,7,8,9,16,24,33,41,48,54,53,52,51,44,36,27,19,12]
var circle4 = [0,1,2,3,4,10,17,25,34,42,49,55,60,59,58,57,56,50,43,35,26,18,11,5]
var weight = [-110,100,5,1000]
var state
var turn
#var transposition = []

func _ready():
	draw_complete_board(BoardManager.current_board)
	var first_board = BoardManager.current_board
	state = State.new(first_board, 0,0)
	turn = 2

func _process(delta):
	
#	transposition.append(state.board)
	
#	minimax function -------------------------
	state = minimax_depth_limit(state, 2, turn)
#	minimax function -------------------------
	
#	alpha beta function------------------------
#	state = alpha_beta_search(state, 2, turn)
#	alpha beta function------------------------
	
	update_board(state.board)
	turn = 3 - turn 

func eval(piece, board):
	var result = 0
	var marbles = get_marbles(piece, board)
	var marbles_opp = get_marbles(3 - piece, board)
	
	result += weight[0] * kill(marbles)
	result += weight[1] * enemy_center_distance(marbles_opp)
	result += weight[2] * center_distance(marbles)
	result += weight[3] * kill(marbles_opp)
	
	return result

func kill(marbles):
	return 14 - len(marbles)

func enemy_center_distance(marbles_opp):
	var result = 0
	for p in marbles_opp: 
		if p in circle1:
			result += 1
		elif p in circle2:
			result += 2
		elif p in circle3:
			result += 3
		elif p in circle4:
			result += 4
		else :
			result += 0
	return result

func center_distance(marbles):
	var result = 0
	for p in marbles: 
		if p in circle1:
			result += 4
		elif p in circle2:
			result += 3
		elif p in circle3:
			result += 2
		elif p in circle4:
			result += 1
		else :
			result += 5
	return result

func get_marbles(piece, board):
	var indexes = []
	for index in range(len(board)):
		if board[index] == piece:
			indexes.append(index)
	return indexes
#
#func filter(moves):
#	var filtered = []
#	for move in moves:
#		if transposition.has(move.board):
#			continue
#		filtered.append(move)
#	return filtered

func minimax_depth_limit(state, depth, number):
	var next_state
	next_state = max_func(state, depth, number)
	return next_state
	

func max_func(state, depth, number):
	if state.black_score == 6 or state.white_score == 6 or depth <= 0:
		return state
	
	var max_value = -99999999999
	var legal_moves
	legal_moves = Successor.calculate_successor(state,number)
#	var legal_move_filtered = filter(legal_moves)
	for move in legal_moves:
		var min_state = min_func(move, depth-1, number)
		var diff = eval(number, min_state.board)
		if  diff > max_value:
			max_value = diff
			state = move
	return state

func min_func(state, depth, number):
	if state.black_score == 6 or state.white_score == 6 or depth <= 0:
		return state
	
	var min_value = 9999999999
	var legal_moves
	legal_moves = Successor.calculate_successor(state, 3 - number)
#	var legal_move_filtered = filter(legal_moves)
	for move in legal_moves:
		var max_state = max_func(move, depth-1, number)
		var diff = eval(number, max_state.board)
		if  diff < min_value:
			min_value = diff
			state = move
	return state

func alpha_beta_search(state, depth, number):
	var next_state
	next_state = max_value(state, depth, number, -99999999999999, 9999999999999)
	return next_state

func max_value(state, depth, number, alpha, beta):
	if state.black_score == 6 or state.white_score == 6 or depth <= 0:
		return state
	
	var legal_moves
	legal_moves = Successor.calculate_successor(state,number)
#	var legal_move_filtered = filter(legal_moves)
	for move in legal_moves:
		var min_state = min_value(move, depth-1, number, alpha, beta)
		var diff = eval(number, min_state.board)
		if  diff >= beta:
			state = move
			return state
		if diff > alpha:
			state = move
			alpha = diff
	return state

func min_value(state, depth, number, alpha, beta):
	if state.black_score == 6 or state.white_score == 6 or depth <= 0:
		return state
	
	var legal_moves
	legal_moves = Successor.calculate_successor(state,number)
#	var legal_move_filtered = filter(legal_moves)
	for move in legal_moves:
		var max_state = max_value(move, depth-1, number, alpha, beta)
		var diff = eval(number, max_state.board)
		if  diff <= alpha:
			state = move
			return state
		if diff < beta:
			state = move
			beta = diff
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
	
