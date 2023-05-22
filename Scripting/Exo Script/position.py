board = [
    ["O","X","."],
    [".","O","."],
    ["X",".","O"]
]
def position_win(board):
    for motif in ["XXX","OOO"]:
        line1 = board[0][0] + board[0][1] +board[0][2]
        line2 = board[1][0] + board[1][1] +board[1][2]
        line3 = board[2][0] + board[2][1] +board[2][2]
        col4 = board[0][0] + board[1][0] +board[2][0]
        col5 = board[0][1] + board[1][1] +board[2][1]
        col6 = board[0][2] + board[1][2] +board[2][2]
        diag7 = board[0][0] + board[1][1] +board[2][2]
        diag8 = board[0][2] + board[1][1] +board[2][0]
        if (line1 == motif or line2 == motif or line3 == motif or col4 == motif or col5 == motif or col6 == motif or diag7 == motif or diag8 == motif):
            return True
    return False

print(position_win(board))