//
// Created by John Sparks on 9/12/15.
// Copyright (c) 2015 Johnny Sparks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


@interface KeyView : NSView
@property (nonatomic, copy) void (^onPress)(int key);
@end