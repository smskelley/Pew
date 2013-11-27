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

const float SPEEDUP_FACTOR = 160.0;

/**************************/
/* Initialization Methods */
/**************************/
-(id) init {
    if ([super init]) {
        // setup defaults that may be overridden
        maxSpeed = 5;
        mass = 5;
        velocity = CGPointMake(0.0,0.0);
        gravity = -9.81;
        // similarly, we need to base our initial upward velocity on realistic pixel values
        pixelJumpVelocity = 55;
        jumpDeltaTMultiplier = 20.0;
    }
    return self;
}

-(id) initWithImageNamed:(NSString *)name {
    // setup base values and then initialize with image
    if ([self init] && [super initWithImageNamed:name])
    {
    }
    return self;
}

-(id) initWithImageNamed:(NSString *)name andScene:(MyScene *)parentScene {
    if ([self initWithImageNamed:name]) {
        scene = parentScene;
    }
    
    return self;
}

-(id) initWithTexture: (SKTexture *)texture andScene:(MyScene *)parentScene {
    if ([self init] && [super initWithTexture:texture]) {
        scene = parentScene;
    }
    
    return self;
}

// Move in the given direction based on the amount of time that has passed.
// Does not take into account gravity. Only takes into account basic scene bounds.
// If the move goes out of bounds, move back into bounds.
-(void) moveRightWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x + self.maxSpeed * SPEEDUP_FACTOR * deltat,
                                self.position.y);
    if ([self maxX] > [scene maxX])
        self.position = CGPointMake([scene maxX] - [self width]/2.0, self.position.y);
}

-(void) moveLeftWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x - self.maxSpeed * SPEEDUP_FACTOR * deltat,
                                self.position.y);
    if ([self minX] < [scene minX])
        self.position = CGPointMake([scene minX] + [self width] / 2, self.position.y);
}

-(void) moveUpWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x,
                                self.position.y + self.maxSpeed * SPEEDUP_FACTOR * deltat);
    if ([self maxY] > [scene maxY])
        self.position = CGPointMake(self.position.x, [scene maxY] - [self height]/2.0);
}

-(void) moveDownWithDeltaT: (CFTimeInterval)deltat {
    self.position = CGPointMake(self.position.x,
                                self.position.y - self.maxSpeed * SPEEDUP_FACTOR * deltat);
    if ([self minY] < [scene minY])
        self.position = CGPointMake(self.position.x, [scene minY] + [self height] / 2.0);
}

// Complex movements
// Jump with height based on maxSpeed. This is a velocity based movement, so changes in positions
// must be calculated each frame by calling moveWithDeltaT:
-(void) jump {
    // single jumps only...
    if (![self isInAir])
    {
        velocity = CGPointMake(velocity.x, velocity.y + pixelJumpVelocity);
    }
}

-(void) moveWithDeltaTime: (CFTimeInterval)deltat {
    deltat *= jumpDeltaTMultiplier;
    if ([self isInAir] || velocity.y > 0)
    {
        // apply gravity
        self.position = CGPointMake(self.position.x,
                                    self.position.y                     // initial position
                                    + velocity.y * deltat                 // plus initial upward vel
                                    + 0.5 * gravity * deltat * deltat   // and accel due to gravity
                                    );
        // Adjust velocity
        velocity = CGPointMake(velocity.x, velocity.y + gravity * deltat);
        // make sure gravity didn't take us through the ground
        if ([self minY] < [scene minY])
            self.position = CGPointMake(self.position.x, [scene minY] + [self height] / 2.0);
    }
    else { // if not in the air, make sure velocity is 0.
        velocity = CGPointMake(0.0, 0.0);
    }
}

/******************************************************/
/* Simple helper methods, used to get the min/max X/Y */
/******************************************************/
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

// Returns yes if in air within a small threshold
- (BOOL) isInAir{
    return [self minY] >= [scene minY] + 0.01;
}

@end
