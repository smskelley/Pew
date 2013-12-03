//
//  Enemy.m
//  Pew
//
//  Created by Sean Kelley on 11/27/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

// Initialization
-(id) initWithImageNamed:(NSString *)name andScene:(SKScene *)parentScene {
    if (self = [super initWithImageNamed:name andScene:parentScene]) {
        targets = [[NSMutableArray alloc] init];
        self.bulletsPerSecond = 0.5;
        self.bulletSpeed = 2.5;
        alive = YES;
    }
    return self;
}

// AI specific
-(void) moveWithDeltaT: (CFTimeInterval) deltat {
    // assume, for the moment being, move right every time
    [self moveRightWithoutBoundsWithDeltaT:deltat];
}

-(void) decideAndDoWithCurrentTime: (CFTimeInterval) currentTime {
    // check if there's something to the right, if there is, try to fire
    // (check doesn't exist at the moment)....
    [self fireRightWithCurrentTime:currentTime];
}

-(void) addTarget: (Player *)target {
    [targets addObject:target];
}

-(void) die {
    alive = NO;
}

-(BOOL) isAlive {
    return alive;
}
@end
