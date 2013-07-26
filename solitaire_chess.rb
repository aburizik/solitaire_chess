#Main function will take an array of arrays, e.g.

# [ [nil,nil,"N",nil] 
#   [nil,nil,nil,nil] 
#   [nil,"P",nil,nil]
#   ["B","Q",nil,"R"] ]
#   
# and return all the intermediate arrays in all solutions.
# To do so, it will have to traverse the array
# and generate all possible solutions starting with each piece.
# To generate all possible solutions given a start piece,
# it will have to make a list of all possible moves, determine which ones are legal,
# and repeat for each piece in the resulting boards.

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

def apply(row, column, board, move)
	mboard = Marshal.load(Marshal.dump(board))
	mboard[move[0]][move[1]] = mboard[row][column]
	mboard[row][column] = nil
	return mboard
end

def legal_moves(board, row, column)

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
									moves.push(apply(row, column, board, move))
								end}
	return moves
end

puts legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
  				  ["B","Q",nil,"R"]], 0, 2) == [[[nil,nil,nil,nil], 
												[nil,nil,nil,nil], 
												[nil,"N",nil,nil],
  												["B","Q",nil,"R"]]]
  								 
puts legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
				  ["B","Q",nil,"R"]], 2, 1) == []

puts legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
  				  ["B","Q",nil,"R"]], 3, 0) == [[[nil,nil,"N",nil], 
												[nil,nil,nil,nil], 
												[nil,"B",nil,nil],
  												[nil,"Q",nil,"R"]]]
  								 
puts legal_moves([[nil,nil,"N",nil], 
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

puts legal_moves([[nil,nil,"N",nil], 
				  [nil,nil,nil,nil], 
				  [nil,"P",nil,nil],
  				  ["B","Q",nil,"R"]], 3, 3) == [[[nil,nil,"N",nil], 
												[nil,nil,nil,nil], 
												[nil,"P",nil,nil],
  												["B","R",nil,nil]]]


# Next, write a function that finds the first or next piece after a given piece.
# i.e., it traverses until it finds a square that is not equal to "."

# Next, write a function that will check whether I am done,
# i.e., whether there is just one piece on the board.

# Next, write the main function, which takes a board and:
# 1. checks whether we have reached the victory condition.
# 2. finds the first/next piece and gets all the places we could go from there.
# 3. recurses on each of these boards.

# N.B.// I will need to find a way for it to output these intermediate boards.
# 'Twill not do to print because I will need to discard paths if they stop working.
# Would be best to store the path somewhere and delete if no legal moves are found.