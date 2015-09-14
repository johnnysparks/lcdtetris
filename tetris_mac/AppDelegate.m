//
//  AppDelegate.m
//  tetris_mac
//
//  Created by John Sparks on 9/12/15.
//  Copyright (c) 2015 Johnny Sparks. All rights reserved.
//


#import "AppDelegate.h"
#import "KeyView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

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

typedef struct Board {
    int grid[kBoardHeight][kBoardWidth];
} Board;

static const Board kEmptyBoard = { .grid = {} };



/**

 PIECES!!!

 */


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

static const int kNumPieces = 7;

Board BoardDeleteRow(Board b, int row);

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

Board BoardRemoveFilledRows(Board b){

    for( int row = 0; row < kBoardHeight; row++ ) {

        if( BoardIsRowFilled(b, row) ){
            b = BoardDeleteRow(b, row);
        }
    }

    return b;
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


@interface AppDelegate () <NSWindowDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, copy) NSArray *tileViews;
@property (nonatomic) Board b;


@property(nonatomic, strong) KeyView *keyView;
@property(nonatomic) int pieceFalling;
@property(nonatomic) Piece currentPiece;
@property(nonatomic) int gameOver;
@property(nonatomic) Direction lastAction;
@property(nonatomic, strong) id keyMonitor;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation AppDelegate

- (void)gameLoop
{
    NSLog(@"loop");
    // Check to see if we need to add a new peice to the top of the board
    if(self.pieceFalling < 1){

        Piece startPiece = PieceRandomStarting();
        startPiece.x = 2;

        // If we can't add the piece, it must be game over
        if(!BoardCanAddPiece(self.b, startPiece)){
//            self.gameOver = 1;
            self.b = kEmptyBoard;
            [self render];
            return;
        }

        // Add the starting piece, and start dropping it
        self.currentPiece = startPiece;
        self.pieceFalling = 1;
    } else {

        // Finally drop the piece down, or lock it if it can't be added
        Piece p = self.currentPiece;
        p.y += 1;

        if(BoardCanAddPiece(self.b, p)){

            self.currentPiece = p;

        } else {

            self.b = BoardAddPiece(self.b, self.currentPiece);
            self.pieceFalling = 0;

            // Once locked, clear our rows and add some points
            int rowsToClear = BoardFilledRowCount(self.b);

            if(rowsToClear){
                NSLog(@"cleared %i rows!", rowsToClear);
            }

            self.b = BoardRemoveFilledRows(self.b);
        }
    }

    // Print the scene!
    [self render];
}


- (void)move
{
    // Update position of falling peice from keypress if possible
    switch(self.lastAction){

        case up: {
            // Up arrow changes piece direction

            Direction d = self.currentPiece.direction;
            if (d == left) {
                d = up;
            } else {
                d += 1;
            }
            Piece p = self.currentPiece;
            p.direction = d;
            if(BoardCanAddPiece(self.b, p)){
                self.currentPiece = p;

            }
        } break;

        case right:{

            // Move Right if possible
            Piece p = self.currentPiece;
            p.x -= 1;
            if(BoardCanAddPiece(self.b, p)){
                self.currentPiece = p;
            }
        } break;

        case down:{
            // Move Right if possible
            Piece p = self.currentPiece;
            p.y += 1;
            if(BoardCanAddPiece(self.b, p)){
                self.currentPiece = p;
            }

        } break;

        case left:{
            // Move Right if possible
            Piece p = self.currentPiece;
            p.x += 1;
            if(BoardCanAddPiece(self.b, p)){
                self.currentPiece = p;
            }

        } break;

        case none:break;
    }

    // Clear out the last action
    self.lastAction = none;

    [self render];
}




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    runTests();

    self.window.delegate = self;

    self.keyView = [[KeyView alloc] initWithFrame:[self.window.contentView bounds]];
    [self.window.contentView resignFirstResponder];
    [self.keyView becomeFirstResponder];
    self.keyView.wantsLayer = YES;

    self.keyView.onPress = ^(int direction){
        self.lastAction = (Direction)direction;
        [self move];
    };

    // Setup views
    for(NSView *view in self.tileViews){
        [self.keyView addSubview:view];
    }
    
    [self.window.contentView addSubview:self.keyView];
    
    self.gameOver = 0;
    self.pieceFalling = 0;
    self.b = kEmptyBoard;

    [self render];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}


- (void)windowDidResize:(NSNotification *)notification {
    [self render];
}


- (NSArray *)tileViews
{
    if(!_tileViews){
        NSMutableArray *views = [NSMutableArray new];
        int i = kBoardSize;
        while (i--){
            NSView *view = [[NSView alloc] initWithFrame:[self.window.contentView bounds]];
            [view setWantsLayer:YES];
            [views addObject:view];
        }
        _tileViews = views;
    }
    return _tileViews;
}

- (void)render
{
    self.keyView.frame = [self.window.contentView bounds];

    CGFloat topMargin = self.titleBarHeight;
    CGFloat width = self.window.frame.size.width;
    CGFloat height = self.window.frame.size.height - topMargin;
    CGFloat cellSize = MIN( width / kBoardWidth, height / kBoardHeight );

    NSRect frame = {
        .origin = {
            .x = 0,
            .y = 0
        },
        .size = {
            .width = cellSize,
            .height = cellSize
        }
    };

    Board b = self.b;
    if(self.pieceFalling){
        b = BoardAddPiece(self.b, self.currentPiece);
    }

    u_int tile = 0;
    for(int y = 0; y < kBoardHeight; y++){
        for(int x = 0; x < kBoardWidth; x++){

            NSRect fillFrame = frame;
            fillFrame.origin.y += cellSize * y;
            fillFrame.origin.x += cellSize * x;

            int color = x % 2 == 0;
            color = y % 2 == 0 ? color : !color;

            NSView *view = self.tileViews[tile];
            view.frame = fillFrame;

            color = b.grid[kBoardHeight - y - 1][kBoardWidth - x - 1] > 0 ? 2 : color;

            switch (color) {
                case 0:
                    view.layer.backgroundColor = [NSColor colorWithCalibratedRed:0.98 green:0.98 blue:0.98 alpha:1].CGColor;
                    break;
                case 1:
                    view.layer.backgroundColor = [NSColor whiteColor].CGColor;
                    break;
                case 2:
                    view.layer.backgroundColor = [NSColor colorWithCalibratedRed:239.0/255.0 green:130.0/255.0 blue:74.0/255.0 alpha:1].CGColor;
                    break;
                default:break;
            }

            tile++;
        }
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (float)titleBarHeight
{
    NSRect frame = NSMakeRect (0, 0, 100, 100);

    NSRect contentRect;
    contentRect = [NSWindow contentRectForFrameRect: frame
                                          styleMask: NSTitledWindowMask];

    return (frame.size.height - contentRect.size.height);

} // titleBarHeight


@end