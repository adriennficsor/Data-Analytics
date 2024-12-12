def main():
    # creating the board and emptry dictionary for storing the positions of placed pieces
    board = create_board()
    taken_positions = {}

    # asking for user input and adding the piece to taken positions
    w_piece, w_position = get_user_input("white").split()

    taken_positions[w_position] = w_piece
    board_update(board, w_position, f"W_{w_piece}")
    print(f"Your {w_piece} is placed to {w_position}.")

    # checking the possible range of movement of the white piece
    white_possible_moves = white_moves(board, w_piece, w_position, "abcdefgh")

    get_black_piece(board, taken_positions)

    print_board(board)

    # checking the overlapping elements in possible moves and the taken positions
    potential_hits = get_potential_hits(white_possible_moves, taken_positions)
    actual_moves = get_actual_moves(w_position, w_piece, potential_hits, "abcdefgh")

    evaluation(actual_moves, potential_hits, w_piece)


def create_board():
    numbers = [str(i) for i in range(8, 0, -1)]
    letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    return [[f"{i}{j}" for i in letters] for j in numbers]

def get_user_input(color):
    while True:
        if color == "white":
            user_input = input("Place a white rook or bishop by addig a position (e.g. rook a1)! ")
        else:
            user_input = input("Place any black piece by naming it and addig a position (e.g. rook a1) and type 'done' after placing all pieces you wanted! ")
        
        if validate_input(user_input, color) == False:
            break
    return user_input

def validate_input(user_input, color):
    if color == "black" and user_input == "done":
        return False
    elif len(user_input.split()) != 2:
        print("Invalid input format. Please use the format 'piece position' (e.g. rook a1).")
        return True
    piece, position = user_input.split()

    if color == "white" and piece not in ["rook", "bishop"]:
        print("You have to choose either rook or bishop!")
        return True
    elif color == "black" and piece not in ["rook", "knight", "bishop", "king", "queen", "pawn"]:
        print("Please enter a valid piece!")
        return True
    if position[0] not in "abcdefgh" or position[1] not in "12345678" or len(position) != 2:
        print("You have to enter a valid position (a letter between a-h followed by a bumber between 1-8 e.g. a1).")
        return True
    return False

def board_update(board, placement, piece):
    for row in board:
        for i in range(len(row)):
            if row[i] == placement:
                row[i] = piece

def white_moves(board, piece, position, cols):
    possible_moves =[]
    w_col = position[0]
    w_col_index = cols.index(w_col)
    w_row = int(position[1])
    if piece == "rook":
        for row in board:
            for i in range(len(row)):
                if row[i][0] == w_col and i != position:
                    possible_moves.append(row[i])
                elif row[i][1] == position[1] and i != position:
                    possible_moves.append(row[i])
    # if the piece is bishop, it takes all the fields diagonally going from the upper left side of the board
    # and going from the bottom left corner of the board (using the indices of the colums and rows)
    if piece == "bishop":
        for i in cols:
            diff = w_col_index - cols.index(i)
            number_from_left_up = w_row + int(diff)
            if 0 < number_from_left_up < 9 and number_from_left_up != w_row:
                possible_moves.append(f"{i}{number_from_left_up}")
            number_from_left_bottom = w_row - int(diff)
            if 0 < number_from_left_bottom < 9 and number_from_left_bottom != w_row:    
                possible_moves.append(f"{i}{number_from_left_bottom}")
    return possible_moves

def get_black_piece(board, taken_positions):
    pieces_placed = 0
    while pieces_placed < 16:
        place_black = get_user_input("black")
        # securing to add at least one black piece on the board
        if pieces_placed == 0 and place_black == "done":
            print("Place at least one black piece! ")
            continue
        elif place_black == "done":
            break
        else:
            piece, position = place_black.split(" ")
            if check_if_taken(taken_positions, position):
                print("This position is already taken, select another one! ")
            else:
                board_update(board, position, f"B_{piece}")
                print(f"Your {piece} is placed to {position}.")
                taken_positions[position] = piece
                pieces_placed += 1

def print_board(board):
    for row in board:
        print(row)

def check_if_taken(list_of_positions, placement):
    if placement in list_of_positions:
        return True
    else:
        return False

def get_potential_hits(moves, taken_positions):
    # empty distionary to store the overlapping elements (pieces with their positions)
    hits = {}
    for move in moves:
        if move in taken_positions:
            hits[move] = taken_positions[move]
    return hits

# in case several pieces are placed in line, only the closest piece can be taken
# for this we get only the pieces closes to the white
def get_actual_moves(position, piece, possible_hits, cols):
    actual_moves = []
    w_col = position[0]
    w_row = int(position[1])
    w_col_index = cols.index(w_col)
    # dividing the board into four segments, based on the indices of columns and rows, relative to the white piece's position
    select_closest_0 = {}
    select_closest_1 = {}
    select_closest_2 = {}
    select_closest_3 = {}
    if piece == "rook":
        for i in possible_hits:
            # sorting the potential hits into the four segments
            if i[0] == w_col:
                if int(i[1]) < w_row:  
                    diff = w_row - int(i[1])
                    select_closest_0[diff] = i
                elif int(i[1]) > w_row:
                    diff = int(i[1]) - w_row
                    select_closest_1[diff] = i
            elif i[1] == position[1]:
                if cols.index(i[0]) < w_col_index:
                    diff = w_col_index - cols.index(i[0])
                    select_closest_2[diff] = i
                elif cols.index(i[0]) > w_col_index:
                    diff = cols.index(i[0]) - w_col_index
                    select_closest_3[diff] = i
    if piece == "bishop":
        for i in possible_hits:
            if i[0] < w_col:
                if int(i[1]) < w_row:  
                    diff = w_row - int(i[1])
                    select_closest_0[diff] = i
                elif int(i[1]) > w_row:
                    diff = int(i[1]) - w_row
                    select_closest_1[diff] = i
            elif i[0] > w_col:
                if int(i[1]) < w_row:
                    diff = w_row - int(i[1])
                    select_closest_2[diff] = i
                elif int(i[1]) > w_row:
                    diff = int(i[1]) - w_row
                    select_closest_3[diff] = i
    # getting the pieces with the minimum distance from each segments
    for closest in [select_closest_0, select_closest_1, select_closest_2, select_closest_3]:
        if closest:
            min_key = min(closest.keys())
            actual_moves.append(closest[min_key])
    # returning only the valid moves
    return actual_moves

def evaluation(moves, hits, piece):
    actual_hits = {}
    for i in moves:
        actual_hits[i] = hits[i]

    if actual_hits == {}:
        print(f"Your {piece} cannot take any of the black pieces.")
    else:
        print(f"Your white {piece} can take the following black pieces:")
        for position in actual_hits:
            print(f"{actual_hits[position]} on {position}")

main()