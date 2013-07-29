# Solitaire chess
# Start with a board with at least one chess piece.
# A piece can only move to capture another piece.
# The victory condition is met when there is only one piece left.
# The goal is to return all possible solutions,
# where a solution is a legal succession of board states,
# ending with the victory condition.

# Solution to the challenge puzzle:

# Step 1
# [nil, nil, "N", nil]
# ["B", "P", nil, nil]
# [nil, "B", "R", nil]
# [nil, nil, "N", "P"]
# Step 2
# [nil, nil, "N", nil]
# ["B", "P", nil, nil]
# [nil, nil, "R", nil]
# [nil, nil, "B", "P"]
# Step 3
# [nil, nil, "N", nil]
# ["B", "P", nil, nil]
# [nil, nil, "R", nil]
# [nil, nil, nil, "P"]
# Step 4
# [nil, nil, nil, nil]
# ["N", "P", nil, nil]
# [nil, nil, "R", nil]
# [nil, nil, nil, "P"]
# Step 5
# [nil, nil, nil, nil]
# [nil, "P", nil, nil]
# [nil, nil, "N", nil]
# [nil, nil, nil, "P"]
# Step 6
# [nil, nil, nil, nil]
# [nil, nil, nil, nil]
# [nil, nil, "P", nil]
# [nil, nil, nil, "P"]
# Step 7
# [nil, nil, nil, nil]
# [nil, nil, nil, nil]
# [nil, nil, nil, nil]
# [nil, nil, nil, "P"]
# Victory!



def move_one(row, column, direction)	
	case direction
		when "north" then return [row-1, column]
		when "south" then return [row+1, column]
		when "east" then return [row, column+1]
		when "west" then return [row, column-1]
		when "northeast" then return [row-1, column+1]
		when "northwest" then return [row-1, column-1]
		when "southeast" then return [row+1, column+1]
		when "southwest" then return [row+1, column-1]
			
		when "k1" then return [row+1, column+2]
		when "k2" then return [row+2, column+1]
		when "k3" then return [row+1, column-2]
		when "k4" then return [row+2, column-1]
		when "k5" then return [row-1, column+2]
		when "k6" then return [row-2, column+1]
		when "k7" then return [row-1, column-2]
		when "k8" then return [row-2, column-1]
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
	if arry.is_a? Array
		arry.map{|x| deep_copy(x)}
	else
		return arry
	end
end

def get_legal_moves(board, row, column)

	piece = board[row][column]
	case piece
	when "P"
		directions = ["southeast", "southwest"]
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

# N.B. Because legal? returns "dne" when moving off the board,
# the while loop breaks when no legal moves are found.

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
				  ["B","Q",nil,"R"]], 2, 1) ==  [[[nil,nil,"N",nil], 
												[nil,nil,nil,nil], 
												[nil,nil,nil,nil],
  												["P","Q",nil,"R"]]]


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


def get_next_piece(board, row, column)
	l = board.length

	if column < l-1
		column += 1
	elsif row < l-1
		column = 0
		row += 1
	else
		return false
	end
	
	if board[row][column] != nil
		return [row, column]
	else
		get_next_piece(board, row, column)
	end

end

# this is much less elegant than the nested loop I initially had.

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


def play(board, path)
	pieces = get_pieces(board)
	lmoves = []
	pieces.each{|piece| lmoves.concat(get_legal_moves(board, piece[0], piece[1]))}
	solutions = []

	if pieces.length == 1
		solutions.push(path)
	else
		lmoves.each{|lmove| mpath = deep_copy(path)
							mpath.push(lmove)
							solutions = solutions + play(lmove, mpath)}
	end
	return solutions
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
		   [nil,"B",nil,nil],
  		   [nil,nil,nil,nil]], []) == [[[[nil,nil,nil,nil], 
									 	 [nil,nil,nil,nil], 
										 [nil,"B",nil,nil],
  										 [nil,nil,nil,nil]]],
  									   [[[nil,nil,nil,nil], 
									 	 [nil,nil,"B",nil], 
										 [nil,nil,nil,nil],
  										 [nil,nil,nil,nil]]]]

puts "winning board"
puts play( [[nil,nil,nil,nil], 
			[nil,nil,nil,nil], 
			[nil,"P",nil,nil],
			[nil,nil,nil,nil]], []) == [[]]

puts "no legal moves"
puts play( [[nil,nil,nil,nil],
			[nil,nil,nil,"Q"],
			[nil,"P",nil,nil],
			[nil,nil,nil,nil]], []) == []

puts "unique solution"
puts play( [[nil,nil,"N",nil], 
			["B","P",nil,nil], 
			["N","B","R",nil],
			[nil,nil,"R","P"]], []).length == 1


def solve(board)
	solutions = play(board, [])

	case solutions
	when [] then puts "There are no possible solutions."
	when [[]] then puts "You have a winning board!"
	else
		count = 1

		solutions.each{|solution| puts "Solution No. #{count}"
						countb = 1
						solution.each{|step| puts "Step #{countb}"
									   step.each{|row| p row}
									   countb += 1}
						puts "Victory!"
						count += 1}
	end
end



puts "solve tests"

puts "one move away"
solve( [[nil,nil,"N",nil],
		[nil,nil,nil,nil],
		[nil,"P",nil,nil],
		[nil,nil,nil,nil]])

puts "two possible winning moves"
solve( [[nil,nil,nil,nil],
		[nil,nil,"B",nil],
		[nil,"B",nil,nil],
		[nil,nil,nil,nil]])

puts "winning board"
solve( [[nil,nil,nil,nil],
		[nil,nil,nil,nil],
		[nil,"P",nil,nil],
		[nil,nil,nil,nil]])

puts "no solutions"
solve( [[nil,nil,nil,nil],
		[nil,nil,nil,"Q"],
		[nil,"P",nil,nil],
		[nil,nil,nil,nil]])

puts "challenge puzzle"
solve( [[nil,nil,"N",nil],
		["B","P",nil,nil],
		["N","B","R",nil],
  		[nil,nil,"R","P"]])