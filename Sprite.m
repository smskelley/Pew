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
@synthesize gravity;
@synthesize lastJump;

const float SPEEDUP_FACTOR = 160.0;
-(id) initWithImageNamed:(NSString *)name {
    if ([super initWithImageNamed:name])
    {
        // setup defaults that may be overridden
        maxSpeed = 5;
        mass = 5;
        lastJump = 0;
        // Pixels aren't the best metric for gravity, so define gravity based on the real world
        // but convert the m/s^2 accel due to gravity into something meaningful in pixels.
        gravity = -9.81;
        pixelGravity = gravity * 50; // pixels per second per second (50px = 1meter)
        // similarly, we need to base our initial upward velocity on realistic pixel values
        pixelJumpVelocity = -gravity * 10;
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
// Does not take into account gravity. Only takes into account basic scene bounds.
// If the move goes out of bounds, move back into bounds.
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

// Complex movements
// Jump with height based on maxSpeed. This is a velocity based movement, so changes in positions
// must be calculated each frame by calling moveWithDeltaT:
-(void) jumpWithCurrentTime: (CFTimeInterval)currentTime {
    velocity = CGPointMake(velocity.x, velocity.y + maxSpeed);
    lastJump = currentTime;
    
    // move instantly a few pixels upwards so that the physics of jumping takes effect
    self.position = CGPointMake(self.position.x, self.position.y + 1);
}

-(void) moveWithCurrentTime: (CFTimeInterval)currentTime {
    CFTimeInterval deltat = currentTime - lastJump;
    if ([self isInAir] && lastJump != 0)
    {
        NSLog(@"Before gravity y = %f, deltat = %f", self.position.y, deltat);
        // apply gravity
        self.position = CGPointMake(self.position.x,
                                    self.position.y                     // initial position
                                    + pixelJumpVelocity * deltat                 // plus initial upward vel
                                    + 0.5 * pixelGravity * deltat * deltat   // and accel due to gravity
                                    );
        // make sure gravity didn't take us through the ground
        if ([self minY] < [scene minY])
            self.position = CGPointMake(self.position.x, [scene minY] + [self height] / 2.0);
        NSLog(@"After gravity y = %f", self.position.y);
    }
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

// within a small threshold
- (BOOL) isInAir{
    return [self minY] >= [scene minY] + 0.01;
}

@end
