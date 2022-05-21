extends Reference

class_name State

var board = []
var black_score = 0
var white_score = 0

func _init(board, black_score, white_score):
	self.black_score = black_score
	self.white_score = white_score
	
	for cell in board:
		self.board.append(cell)

func increase_score(piece):
	if piece == BoardManager.BLACK:
		self.black_score += 1
	elif piece == BoardManager.WHITE:
		self.white_score += 1
