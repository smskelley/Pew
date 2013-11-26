//
//  Sprite.m
//  Pew
//
//  Created by Sean Kelley on 11/24/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "Sprite.h"
#import "MyScene.h"

@implementation Sprite

@synthesize maxSpeed;
@synthesize mass;

const float SPEEDUP_FACTOR = 160.0;
-(id) initWithImageNamed:(NSString *)name {
    if ([super initWithImageNamed:name])
    {
        // setup defaults that may be overridden
        maxSpeed = 5;
        mass = 5;
    }
    return self;
}

-(id) initWithImageNamed:(NSString *)name
                andScene:(MyScene *)parentScene {
    self = [self initWithImageNamed:name];
    
    scene = parentScene;
    
    return self;
}

// Move in the given direction based on the amount of time that has passed.
// If the move goes out of bounds, move into bounds.
-(void) moveRightWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x + self.speed * SPEEDUP_FACTOR * deltat,
                                self.position.y);
    if ([self maxX] > [scene maxX])
        self.position = CGPointMake([scene maxX] - [self width]/2.0, self.position.y);
}

-(void) moveLeftWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x - self.speed * SPEEDUP_FACTOR * deltat,
                                self.position.y);
    if ([self minX] < [scene minX])
        self.position = CGPointMake([scene minX] + [self width] / 2, self.position.y);
}

-(void) moveUpWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x,
                                self.position.y + self.speed * SPEEDUP_FACTOR * deltat);
    if ([self maxY] > [scene maxY])
        self.position = CGPointMake(self.position.x, [scene maxY] - [self height]/2.0);
}

-(void) moveDownWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x,
                                self.position.y - self.speed * SPEEDUP_FACTOR * deltat);
    if ([self minY] < [scene minY])
        self.position = CGPointMake(self.position.x, [scene minY] + [self height] / 2.0);
}

// Simple helper methods, used to get the min/max X/Y
- (CGFloat) minX {
    return CGRectGetMinX(self.frame);
}
- (CGFloat) minY {
    return CGRectGetMinY(self.frame);
}
- (CGFloat) maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat) maxY {
    return CGRectGetMaxY(self.frame);
}
- (CGFloat) height {
    return CGRectGetHeight(self.frame);
}
- (CGFloat) width {
    return CGRectGetWidth(self.frame);
}
@end
