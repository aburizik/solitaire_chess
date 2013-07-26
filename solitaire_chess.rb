# Solitaire chess
# Start with a board with at least one chess piece.
# A piece can only move to take another piece.
# The victory condition is when there is only one piece left.
# The goal is to return all possible solutions,
# where a solution is an array of successive board states.

def move_one(row, column, direction)	
	case direction
		when "north"
			return [row-1, column]
		when "south"
			return [row+1, column]
		when "east"
			return [row, column+1]
		when "west"
			return [row, column-1]
		when "northeast"
			return [row-1, column+1]
		when "northwest"
			return [row-1, column-1]
		when "southeast"
			return [row+1, column+1]
		when "southwest"
			return [row+1, column-1]
			
		when "k1"
			return [row+1, column+2]
		when "k2"
			return [row+2, column+1]
		when "k3"
			return [row+1, column-2]
		when "k4"
			return [row+2, column-1]
		when "k5"
			return [row-1, column+2]
		when "k6"
			return [row-2, column+1]
		when "k7"
			return [row-1, column-2]
		when "k8"
			return [row-2, column-1]		
	end		
end

def legal?(move, board)
	n = board.length
	if (move[0] > n-1) or (move[1] > n-1) or (move[0] < 0) or (move[1] < 0)
		return "dne"
	else
		board[move[0]][move[1]] != nil
	end
end

def deep_copy(arry)
	copy = Marshal.load(Marshal.dump(arry))
	return copy
end

def get_legal_moves(board, row, column)

	piece = board[row][column]
	case piece
	when "P"
		directions = ["northeast", "northwest"]
		unbounded = false
	when "K"
		directions = ["north", "south", "east", "west",
					  "northeast", "northwest", "southeast", "southwest"]
		unbounded = false
	when "N"
		directions = ["k1", "k2", "k3", "k4", "k5", "k6", "k7", "k8"]
		unbounded = false
	when "B"
		directions = ["northeast", "northwest", "southeast", "southwest"]
		unbounded = true
	when "R"
		directions = ["north", "south", "east", "west"]
		unbounded = true
	when "Q"
		directions = ["north", "south", "east", "west",
					  "northeast", "northwest", "southeast", "southwest"]
		unbounded = true
	end									

	moves = []
	directions.each{|direction| move = move_one(row, column, direction)
						 		check = legal?(move, board)
								while (check == false) and unbounded
									move = move_one(move[0], move[1], direction)
									check = legal?(move, board)
								end
								if check == true
									mboard = deep_copy(board)
									mboard[move[0]][move[1]] = mboard[row][column]
									mboard[row][column] = nil
									moves.push(mboard)
								end}
	return moves
end

puts "get_legal_moves tests"

puts get_legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
  				  ["B","Q",nil,"R"]], 0, 2) == [[[nil,nil,nil,nil], 
												[nil,nil,nil,nil], 
												[nil,"N",nil,nil],
  												["B","Q",nil,"R"]]]
  								 
puts get_legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
				  ["B","Q",nil,"R"]], 2, 1) == []

puts get_legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
  				  ["B","Q",nil,"R"]], 3, 0) == [[[nil,nil,"N",nil], 
												[nil,nil,nil,nil], 
												[nil,"B",nil,nil],
  												[nil,"Q",nil,"R"]]]
  								 
puts get_legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
  				  ["B","Q",nil,"R"]], 3, 1) == [[[nil,nil,"N",nil], 
												 [nil,nil,nil,nil], 
												 [nil,"Q",nil,nil],
  												 ["B",nil,nil,"R"]],
  												[[nil,nil,"N",nil], 
												 [nil,nil,nil,nil], 
												 [nil,"P",nil,nil],
  										   		 ["B",nil,nil,"Q"]],
  												[[nil,nil,"N",nil], 
										   		 [nil,nil,nil,nil], 
												 [nil,"P",nil,nil],
  												 ["Q",nil,nil,"R"]]]

puts get_legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
  				  ["B","Q",nil,"R"]], 3, 3) == [[[nil,nil,"N",nil], 
												[nil,nil,nil,nil], 
												[nil,"P",nil,nil],
  												["B","R",nil,nil]]]


# if I had a board class I might be able to keep a record of the pieces I have
# so I wouldn't have to traverse :-(

def get_next_square(l, row, column)
	if column < l-1
		return [row, column+1]
	elsif row < l-1
		return [row+1, 0]
	else
		return false
	end
end


def get_next_piece(board, row, column)
	l = board.length
	next_square = get_next_square(l, row, column)

	while next_square
		row = next_square[0]
		column = next_square[1]
		if board[row][column] != nil
			break
		else
			next_square = get_next_square(l, row, column)
		end
	end
	
	return next_square
end

# this is much less elegant than the nested loop I initially had.
# The reason I have to do this is I need it to find the next piece
# AFTER the one I pass in, so I had to outsource the stepping to
# its own function to make that first step.	ugh.

puts "get_next_piece tests"

puts get_next_piece([["A",nil,"N",nil], 
				  	 [nil,nil,nil,nil], 
				  	 [nil,"P",nil,nil],
  				  	 ["B","Q",nil,"R"]], 0, -1) == [0,0]
  								 
puts get_next_piece([["A",nil,"N",nil], 
					 [nil,nil,nil,nil], 
				  	 [nil,"P",nil,nil],
				  	 ["B","Q",nil,"R"]], 0, 0) == [0,2]
				  
puts get_next_piece([[nil,nil,"N",nil], 
				  	 [nil,nil,nil,nil], 
				  	 [nil,"P",nil,nil],
				  	 ["B","Q",nil,"R"]], 2, 1) == [3,0]

puts get_next_piece([[nil,nil,"N",nil], 
					 [nil,nil,nil,nil], 
					 [nil,"P",nil,nil],
  				  	 ["B","Q",nil,"R"]], 3, 0) == [3,1]

puts get_next_piece([[nil,nil,"N",nil], 
				  	 [nil,nil,nil,nil], 
				  	 [nil,"P",nil,nil],
  				  	 ["B","Q",nil,"R"]], 3, 3) == false


def get_pieces(board)
	pieces = []
	next_piece = get_next_piece(board, 0, -1)
	while next_piece
		pieces.push(next_piece)
		next_piece = get_next_piece(board, next_piece[0], next_piece[1])
	end
	return pieces
end

puts "get_pieces tests"

puts get_pieces([[nil,nil,"N",nil], 
				 [nil,nil,nil,nil], 
				 [nil,"P",nil,nil],
  				 ["B","Q",nil,"R"]]) == [[0,2],[2,1],[3,0],[3,1],[3,3]]
  				 
puts get_pieces([[nil,nil,nil,nil], 
				 [nil,nil,nil,nil], 
				 [nil,"P",nil,nil],
  				 [nil,nil,nil,nil]]) == [[2,1]]

puts get_pieces([[nil,nil,nil,nil], 
				 [nil,nil,nil,nil], 
				 [nil,nil,nil,nil],
  				 [nil,nil,nil,nil]]) == []


def all_legal_moves(board)
	result = []
	pieces = get_pieces(board)
	pieces.each{|piece| result.concat(get_legal_moves(board, piece[0], piece[1]))}
	return result
end

# puts "all_legal_moves tests"
# 
# puts all_legal_moves([[nil,nil,"N",nil],
# 		   			  [nil,nil,nil,nil],
# 					  [nil,"P",nil,nil],
#   		  			  [nil,nil,nil,nil]]) == [[[nil,nil,nil,nil],
# 											   [nil,nil,nil,nil],
# 											   [nil,"N",nil,nil],
#   											   [nil,nil,nil,nil]]]
# 
# puts all_legal_moves([[nil,nil,nil,nil], 
# 		   			  [nil,nil,nil,nil], 
# 		   			  [nil,"P",nil,nil],
# 		   			  [nil,nil,nil,nil]]) == []
# 
# puts all_legal_moves([[nil,nil,nil,nil], 
# 		   			  [nil,nil,nil,"Q"], 
# 		   			  [nil,"P",nil,nil],
# 		   			  [nil,nil,nil,nil]]) == []


def play(board, path)
	pieces = get_pieces(board)
	start = []
	pieces.each{|piece| start.concat(get_legal_moves(board, piece[0], piece[1]))}
	lmoves = start

	if pieces.length == 1
		play(board, path).push(path)
	elsif lmoves == []
		return []
	else
		lmoves.each{|lmove| mpath = deep_copy(path)
							mpath.push(lmove)
							play(lmove, mpath)}
	end
end



puts "play tests"

puts "one move away"
puts play([[nil,nil,"N",nil], 
		   [nil,nil,nil,nil], 
		   [nil,"P",nil,nil],
  		   [nil,nil,nil,nil]], []) == [[[[nil,nil,nil,nil], 
									 	 [nil,nil,nil,nil], 
										 [nil,"N",nil,nil],
  										 [nil,nil,nil,nil]]]]

puts "two possible winning moves"
puts play([[nil,nil,nil,nil], 
		   [nil,nil,"B",nil], 
		   [nil,"P",nil,nil],
  		   [nil,nil,nil,nil]], []) == [[[[nil,nil,nil,nil], 
									 	 [nil,nil,nil,nil], 
										 [nil,"N",nil,nil],
  										 [nil,nil,nil,nil]]],
  									   [[[nil,nil,nil,nil], 
									 	 [nil,nil,nil,nil], 
										 [nil,"N",nil,nil],
  										 [nil,nil,nil,nil]]]]

puts "winning board"
puts play([[nil,nil,nil,nil], 
		   [nil,nil,nil,nil], 
		   [nil,"P",nil,nil],
  		   [nil,nil,nil,nil]], []) == [[]]

puts "no legal moves"
puts play([[nil,nil,nil,nil],
		   [nil,nil,nil,"Q"],
		   [nil,"P",nil,nil],
  		   [nil,nil,nil,nil]], []) == []

puts "unique solution"
puts play([[nil,nil,"N",nil], 
		   ["B","P",nil,nil], 
		   ["N","B","R",nil],
  		   [nil,nil,"R","P"]], []).length == 1