

#import "tetris_game.h"

/**

 PIECES!!!

 */

static const int kNumPieces = 7;

static const Board kEmptyBoard = { .grid = {} };

static const Piece kPieceSquare = {
        .direction = up,
        .grid = {
                {
                        {0,1,1,0},
                        {0,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,1,0},
                        {0,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,1,0},
                        {0,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,1,0},
                        {0,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
        }
};


static const Piece kPieceBar = {
        .grid = {
                {
                        {1,1,1,1},
                        {0,0,0,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,0,1,0},
                        {0,0,1,0},
                        {0,0,1,0},
                        {0,0,1,0},
                },
                {
                        {1,1,1,1},
                        {0,0,0,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,0,1,0},
                        {0,0,1,0},
                        {0,0,1,0},
                        {0,0,1,0},
                },
        }
};

static const Piece kPieceZ = {
        .grid = {
                {
                        {1,1,0,0},
                        {0,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,0,0},
                        {1,1,0,0},
                        {1,0,0,0},
                        {0,0,0,0},
                },
                {
                        {1,1,0,0},
                        {0,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,0,0},
                        {1,1,0,0},
                        {1,0,0,0},
                        {0,0,0,0},
                },
        }
};

static const Piece kPieceZ2 = {
        .grid = {
                {
                        {0,1,1,0},
                        {1,1,0,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {1,0,0,0},
                        {1,1,0,0},
                        {0,1,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,1,0},
                        {1,1,0,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {1,0,0,0},
                        {1,1,0,0},
                        {0,1,0,0},
                        {0,0,0,0},
                },
        }
};

static const Piece kPieceT = {
        .grid = {
                {
                        {0,1,0,0},
                        {1,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,0,0},
                        {0,1,1,0},
                        {0,1,0,0},
                        {0,0,0,0},
                },
                {
                        {0,0,0,0},
                        {1,1,1,0},
                        {0,1,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,0,0},
                        {1,1,0,0},
                        {0,1,0,0},
                        {0,0,0,0},
                },
        }
};

static const Piece kPieceL = {
        .grid = {
                {
                        {1,0,0,0},
                        {1,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,1,0},
                        {0,1,0,0},
                        {0,1,0,0},
                        {0,0,0,0},
                },
                {
                        {0,0,0,0},
                        {1,1,1,0},
                        {0,0,1,0},
                        {0,0,0,0},
                },
                {
                        {0,1,0,0},
                        {0,1,0,0},
                        {1,1,0,0},
                        {0,0,0,0},
                },
        }
};

static const Piece kPieceL2 = {
        .grid = {
                {
                        {0,0,1,0},
                        {1,1,1,0},
                        {0,0,0,0},
                        {0,0,0,0},
                },
                {
                        {0,1,0,0},
                        {0,1,0,0},
                        {0,1,1,0},
                        {0,0,0,0},
                },
                {
                        {0,0,0,0},
                        {1,1,1,0},
                        {1,0,0,0},
                        {0,0,0,0},
                },
                {
                        {1,1,0,0},
                        {0,1,0,0},
                        {0,1,0,0},
                        {0,0,0,0},
                },
        }
};

Piece PieceRandomStarting() {

    int r = rand();
    int randIndex = r % kNumPieces;

    Piece kPieceTemplates[kNumPieces] = {
            kPieceL2,
            kPieceL,
            kPieceSquare,
            kPieceBar,
            kPieceT,
            kPieceZ,
            kPieceZ2
    };

    return kPieceTemplates[randIndex];
}

Piece PieceRandom(){

    int r1 = rand();
    int r2 = rand();
    int r3 = rand();

    Piece p = PieceRandomStarting();
    p.x = r1 % kBoardWidth;
    p.y = r2 % kBoardHeight;
    p.direction = (Direction)(r3 % kPieceDirections);

    return p;
};

void BoardPrint( Board b ) {

    char o[kBoardSize + kBoardHeight + 1] = {};
    int charOffset = 0;

    for (int y = 0; y < kBoardHeight; y++ ) {
        for (int x = 0; x < kBoardWidth; x++) {

            char tile = b.grid[y][x] ? 'x' : '.';

            o[charOffset] = tile;

            charOffset++;
            if (x == kBoardWidth - 1) {

                o[charOffset] = '\n';
                charOffset++;
            }
        }
    }

    printf("\n%s", o);
}

int BoardCanAddPiece( Board b, Piece p ) {

    for (int y = 0; y < kPieceSize; y++ ) {
        for (int x = 0; x < kPieceSize; x++ ) {

            int xTile = x + p.x;
            int yTile = y + p.y;
            int xfits = xTile < kBoardWidth && xTile >= 0;
            int yfits = yTile >= 0 && yTile < kBoardHeight;

            int isOnBoard = xfits && yfits;
            int pieceFilled = p.grid[p.direction][y][x];
            int boardFilled = b.grid[y + p.y][x + p.x];

            // Can't add a piece over a filled spot
            if (isOnBoard && pieceFilled && boardFilled ) {
                return 0;
            }

            // Can't add a piece off screen (empty tiles don't count)
            if ( !isOnBoard && pieceFilled ) {
                return 0;
            }
        }
    }
    // If we get the the end without problems, it's a valid piece position
    return 1;
}

Board BoardAddPiece( Board b, Piece p ) {

    for (int y = 0; y < kPieceSize; y++ ) {
        for (int x = 0; x < kPieceSize; x++ ) {

            int xfits = x < kBoardWidth && x >= 0;
            int yfits = y >= 0 && y < kBoardHeight;
            int isOnBoard = xfits && yfits;
            int pieceFilled = p.grid[p.direction][y][x];
            int boardFilled = b.grid[y + p.y][x + p.x];

            // Empty tiles can't block
            if ( !pieceFilled ) {
                continue;
            } else {
                // If a tile is not empty, it's only a valid position if it's
                // on the board and the board isn't already filled
                if ( isOnBoard && !boardFilled ) {
                    b.grid[y + p.y][x + p.x] = 1;
                }
            }
        }
    }

    return b;
}

Board BoardRandomFill(Board b){
    Piece p = PieceRandom();
    while (!BoardCanAddPiece(b, p)){
        p = PieceRandom();
    }
    b = BoardAddPiece(b, p);
    return b;
}


int BoardIsRowFilled(Board b, int row){

    if ( row >= kBoardHeight || row < 0){
        return 0;
    }

    for(int x = 0; x < kBoardWidth; x++){
        if(b.grid[row][x] == 0){
            return 0;
        }
    }

    return 1;
}

int BoardFilledRowCount(Board b){

    int count = 0;
    for(int row = 0; row < kBoardHeight; row++){
        if(BoardIsRowFilled(b, row)){
            count++;
        }
    }
    return count;
}

Board BoardDeleteRow(Board b, int row){

    int inRange = row >= 0 && row < kBoardHeight;

    if(inRange){
        // We move every row one row down, starting by
        // overwriting the deleted row, up until the top row
        // (which will always be cleared)

        for(int y = row; y > 0; y -- ){
            for(int x = 0; x < kBoardWidth; x ++){

                // if on the bottom row, clear it
                if(y == 0){

                    b.grid[y][x] = 0;

                } else {

                    // otherwise move all tiles down
                    b.grid[y][x] = b.grid[y - 1][x];
                }
            }
        }
    }

    return b;
}

Board BoardRemoveFilledRows(Board b){

    for( int row = 0; row < kBoardHeight; row++ ) {

        if( BoardIsRowFilled(b, row) ){
            b = BoardDeleteRow(b, row);
        }
    }

    return b;
}


Game GameTick(Game g) {
    // Check to see if we need to add a new peice to the top of the board
    if(g.pieceFalling < 1){

        Piece startPiece = PieceRandomStarting();
        startPiece.x = 2;

        // If we can't add the piece, it must be game over
        if(!BoardCanAddPiece(g.board, startPiece)){
            g.gameOver = 1;
            g.board = kEmptyBoard;
            return g;
        }

        // Add the starting piece, and start dropping it
        g.currentPiece = startPiece;
        g.pieceFalling = 1;
    } else {

        // Finally drop the piece down, or lock it if it can't be added
        Piece p = g.currentPiece;
        p.y += 1;

        if(BoardCanAddPiece(g.board, p)){

            g.currentPiece = p;

        } else {

            g.board = BoardAddPiece(g.board, g.currentPiece);
            g.pieceFalling = 0;

            // Once locked, clear our rows and add some points
            int rowsToClear = BoardFilledRowCount(g.board);

            if(rowsToClear){
                printf("cleared %i rows!", rowsToClear);
            }

            g.board = BoardRemoveFilledRows(g.board);
        }
    }

    return g;
}


Game GameMove(Game g, Direction d) {

    // Update position of falling peice from keypress if possible

    switch(d){
        case up: {
            // Up arrow changes piece direction
            Piece p = g.currentPiece;
            Direction dir = p.direction;
            if (dir == left) {
                dir = up;
            } else {
                dir += 1;
            }

            p.direction = dir;
            if(BoardCanAddPiece(g.board, p)){
                g.currentPiece = p;
            }
        } break;

        case right:{

            // Move Right if possible
            Piece p = g.currentPiece;
            p.x -= 1;
            if(BoardCanAddPiece(g.board, p)){
                g.currentPiece = p;
            }
        } break;

        case down:{
            // Move Right if possible
            Piece p = g.currentPiece;
            p.y += 1;
            if(BoardCanAddPiece(g.board, p)){
                g.currentPiece = p;
            }

        } break;

        case left:{
            // Move Right if possible
            Piece p = g.currentPiece;
            p.x += 1;
            if(BoardCanAddPiece(g.board, p)){
                g.currentPiece = p;
            }

        } break;

        case none:break;
    }

    return g;
};


/**
 * TESTS
 */

void test(int passed){
    printf("%c", passed ? '*' : 'X');
}

void runTests() {

    printf("Begining tests: \n------------------ \n");

    Board a = kEmptyBoard;
    Board b = kEmptyBoard;
    Board c = kEmptyBoard;

    Piece p = kPieceL2;
    p.y = 3;

    Piece p2 = kPieceL2;
    p2.x = 4;
    p2.y = 8;

    Piece p3 = kPieceSquare;
    p3.y = 12;

    b = BoardAddPiece(a, p);
    c = BoardAddPiece(b, p2);
    c = BoardAddPiece(c, p3);

    test(!BoardCanAddPiece(c, p2));

    // Can add an old piece to a previous board
    // (immutable)
    test(BoardCanAddPiece(a, p2));

    // Can't re-add original piece
    test(!BoardCanAddPiece(b, p));


    // Test filling a row
    Board fullRowBoard = kEmptyBoard;
    int i = kBoardWidth;
    while ( i-- ) {
        Piece s = kPieceSquare;
        s.x = i - 1;
        s.y = 5;

        if(BoardCanAddPiece(fullRowBoard, s)){
            fullRowBoard = BoardAddPiece(fullRowBoard, s);
        }

        Piece top = s;
        top.y = kBoardHeight - 2;
        if(BoardCanAddPiece(fullRowBoard, top)){
            fullRowBoard = BoardAddPiece(fullRowBoard, top);
        }
    }

    test(BoardIsRowFilled(fullRowBoard, 5));
    test(BoardIsRowFilled(fullRowBoard, 6));
    test(!BoardIsRowFilled(fullRowBoard, 2));
    test(!BoardIsRowFilled(fullRowBoard, 10));
    test(BoardIsRowFilled(fullRowBoard, kBoardHeight - 1));


    // Delete a few rows
    fullRowBoard = BoardDeleteRow(fullRowBoard, 5);
    fullRowBoard = BoardDeleteRow(fullRowBoard, 5);
    test(!BoardIsRowFilled(fullRowBoard, 6));
    test(!BoardIsRowFilled(fullRowBoard, kBoardHeight - 1));


    // Clear out rows and capture the number removed
    Board pointBoard = kEmptyBoard;
    i = kBoardWidth;
    while ( i-- ) {
        Piece s = kPieceSquare;
        s.x = i - 1;
        s.y = 5;

        if(BoardCanAddPiece(pointBoard, s)){
            pointBoard = BoardAddPiece(pointBoard, s);
        }

        Piece top = s;
        top.y = kBoardHeight - 2;
        if(BoardCanAddPiece(pointBoard, top)){
            pointBoard = BoardAddPiece(pointBoard, top);
        }
    }

    int filledRowCount = BoardFilledRowCount(pointBoard);
    test((filledRowCount == 4));

    // after removing filled rows, the filled count should go to zero
    pointBoard = BoardRemoveFilledRows(pointBoard);
    filledRowCount = BoardFilledRowCount(pointBoard);

    test((filledRowCount == 0));

}

Board GameDisplayBoard(Game g) {
    Board b = g.board;
    if(g.pieceFalling){
        b = BoardAddPiece(g.board, g.currentPiece);
    }
    return b;
}
