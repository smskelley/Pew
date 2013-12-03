//
//  KeyStates.h
//  Pew
//
//  Created by Sean Kelley on 11/24/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Key.h"


@interface KeyStates : NSObject {
    NSMutableArray *keys;
}
typedef NS_ENUM(NSUInteger, KeyCode) {
    KEY_SPACE = 49,
    KEY_W = 13,
    KEY_A = 0,
    KEY_S = 1,
    KEY_D = 2,
    KEY_DELETE = 51,
};
#define NUMBER_OF_KEYS 5

- (id) init;

- (BOOL) stateForKey: (KeyCode)key;

- (void) setDown: (KeyCode)key;

- (void) setUp: (KeyCode)key;

@end
