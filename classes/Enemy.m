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
        target = nil;
        self.bulletsPerSecond = 0.5;
        self.bulletSpeed = 2.5;
        alive = YES;
        pixelJumpVelocity += 20;
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
    if ([self enemyIsSimilarAltitude])
    {
        [self fireRightWithCurrentTime:currentTime];
        // if they're close, try to jump over
        if ([self enemyIsClose])
            [self jump];
    }
}

-(void) addTarget: (Player *)newTarget {
    target = newTarget;
}

-(BOOL) enemyAbove {
    return CGRectGetMinY(self.frame) < CGRectGetMinY(target.frame);
}

-(BOOL) enemyIsSimilarAltitude {
    // Find the y distance between them. similar altitude if distance is within
    // half of our height.
    CGFloat dy = fabsf(CGRectGetMidY(self.frame) - CGRectGetMidY(target.frame));
    return dy <= (CGRectGetHeight(self.frame) / 2.0);
}

-(BOOL) enemyIsClose {
    // find the x distance between. We are close if the distance is within 3
    // of our widths
    CGFloat dx = fabsf(CGRectGetMidX(self.frame) - CGRectGetMidX(target.frame));
    return dx <= (CGRectGetWidth(self.frame) * 2.0);
}

@end
