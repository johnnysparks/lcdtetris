//
// Created by John Sparks on 9/12/15.
// Copyright (c) 2015 Johnny Sparks. All rights reserved.
//

#import "KeyView.h"


@implementation KeyView

- (void)keyDown:(NSEvent*)event
{
    switch( [event keyCode] ) {
        case 126:       // up arrow
            self.onPress(0);
            break;
        case 125:       // down arrow
            self.onPress(2);
            break;
        case 124:       // right arrow
            self.onPress(1);
            break;
        case 123:       // left arrow
            self.onPress(3);
            break;
        default:
            break;
    }
}


- (BOOL)acceptsFirstResponder
{
    return YES;
}


@end