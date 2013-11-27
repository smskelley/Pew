//
//  KeyStates.m
//  Pew
//
//  Created by Sean Kelley on 11/24/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "KeyStates.h"

@implementation KeyStates

- (id) init {
    if (self = [super init])
    {
        keys = [NSMutableArray arrayWithCapacity:NUMBER_OF_KEYS];
        for (int i = 0; i < NUMBER_OF_KEYS; i++)
            [keys addObject:[[Key alloc] init]];
    }
    return self;
}
- (KeyCode) indexToKeyCode: (int) index {
    switch (index)
    { // Starting from 0: A = 0, S = 1, D = 2, W = 3, Space = 4
        case 0:
        case 1:
        case 2:
            return index;
        case 3:
            return KEY_W;
        case 4:
            return KEY_SPACE;
    }
    return -1;
}

- (int) keyCodeToIndex: (KeyCode)key {
    switch (key)
    { // Starting from 0: A = 0, S = 1, D = 2, W = 3, Space = 4
        case KEY_A:
        case KEY_S:
        case KEY_D:
            return key;
        case KEY_W:
            return 3;
        case KEY_SPACE:
            return 4;
    }
    return -1;
}

- (BOOL) stateForKey: (KeyCode)key {
    Key *k = [keys objectAtIndex:[self keyCodeToIndex:key]];
    return [k status];
}

- (void) setDown: (KeyCode)key {
    int index = [self keyCodeToIndex:key];
    if (index >= 0) {
        Key *k = [keys objectAtIndex:index];
        [k setStatus:true];
    }
}

- (void) setUp: (KeyCode)key {
    int index = [self keyCodeToIndex:key];
    if (index >= 0) {
        Key *k = [keys objectAtIndex:index];
        [k setStatus:false];
    }
}

@end
