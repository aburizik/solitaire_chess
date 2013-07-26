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
# i.e., it traverses until it finds a square that is not nil
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
# its own function to make that first step.		

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
  				  	 

# Next, write a function that will check whether I am done,
# i.e., whether there is just one piece on the board.



# Next, write the main function, which takes a board and:
# 1. checks whether we have reached the victory condition.
# 2. finds the first/next piece and gets all the places we could go from there.
# 3. recurses on each of these boards.

# N.B.// I will need to find a way for it to output these intermediate boards.
# 'Twill not do to print because I will need to discard paths if they stop working.
# Would be best to store the path somewhere and delete if no legal moves are found.