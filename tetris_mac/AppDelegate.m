//
//  AppDelegate.m
//  tetris_mac
//
//  Created by John Sparks on 9/12/15.
//  Copyright (c) 2015 Johnny Sparks. All rights reserved.
//


#import "AppDelegate.h"
#import "KeyView.h"
#import "tetris_game.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>




@interface AppDelegate () <NSWindowDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, copy) NSArray *tileViews;
@property(nonatomic, strong) KeyView *keyView;
@property(nonatomic, strong) NSTimer *timer;


@property(nonatomic) Game game;


@end

@implementation AppDelegate

- (void)gameTick
{
    self.game = GameTick(self.game);
    // Print the scene!
    [self render];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    self.window.delegate = self;

    Game g = {};
    self.game = g;

    self.keyView = [[KeyView alloc] initWithFrame:[self.window.contentView bounds]];
    [self.window.contentView resignFirstResponder];
    [self.keyView becomeFirstResponder];
    self.keyView.wantsLayer = YES;

    self.keyView.onPress = ^(int direction){
        self.game = GameMove(self.game, (Direction) direction);
        [self render];
    };

    // Setup views
    for(NSView *view in self.tileViews){
        [self.keyView addSubview:view];
    }
    
    [self.window.contentView addSubview:self.keyView];

    [self render];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameTick) userInfo:nil repeats:YES];
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
    Board b = GameDisplayBoard(self.game);

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