
#include <stdio.h>
#import <stdlib.h>
#import <time.h>
#import <string.h>

/*

 BOARDS

 Characters are 5x8: board is 16col x 2row
 16x40 points, 2x2 points per tile
*/

static const int kBoardHeight = 40;
static const int kBoardWidth = 8;
static const int kBoardSize = 8 * 40;

static const int kPieceSize = 4;
static const int kPieceDirections = 4;

typedef enum {
    up = 0,
    right,
    down,
    left,
    none
} Direction;

typedef struct Piece {
    int grid[kPieceDirections][kPieceSize][kPieceSize];
    Direction direction;
    int x;
    int y;
} Piece;

typedef struct Board {
    int grid[kBoardHeight][kBoardWidth];
} Board;

typedef struct Game {
    int pieceFalling;
    Piece currentPiece;
    int gameOver;
    Direction lastAction;
    Board board;
} Game;



Piece PieceRandom();

void BoardPrint( Board b );

Game GameTick(Game g);

Game GameMove(Game g, Direction d);

Board GameDisplayBoard(Game g);









