extends Reference

class_name Successor

static func calculate_successor(state, piece): # calculates all the successor states of a state, given a piece
	var result = []
	for cell_number in range(len(state.board)):
		if state.board[cell_number] == piece:
			for cluster_length in range(1, 4):
				for cluster_direction in Move.get_possible_cluster_directions(cluster_length):
					if BoardManager.check_cluster(state.board, cell_number, piece, cluster_length, cluster_direction):
						for move_direction in Move.get_possible_move_directions(cluster_length, cluster_direction):
							var legal_status = []
							legal_status = Move.is_legal(state, cell_number, piece, cluster_length, cluster_direction, move_direction)
							if legal_status["move is legal"] == true:
								var new_state = State.new(state.board, state.black_score, state.white_score)
								Move.execute(new_state, cell_number, piece, cluster_length, cluster_direction, move_direction, legal_status)
								result.append(new_state)
	return result
