//
//  Sprite.h
//  Pew
//
//  Created by Sean Kelley on 11/24/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"

@interface Sprite : SKSpriteNode {
    MyScene *scene;
    CGPoint velocity;
    CGFloat pixelJumpVelocity;
    CGFloat jumpDeltaTMultiplier;
}
@property (nonatomic) CGFloat maxSpeed;
@property (nonatomic) CGFloat mass;
@property (nonatomic) CGFloat gravity;
@property (nonatomic) CGFloat SPEEDUP_FACTOR;

// It is recommended that you use these initialization methods. Parent Scene
// needed for bounds checking.
-(id) initWithImageNamed:(NSString *)name andScene:(SKScene *)parentScene;
-(id) initWithTexture: (SKTexture *)texture andScene:(MyScene *)parentScene;


// move without bounds check
-(void) moveRightWithoutBoundsWithDeltaT: (CFTimeInterval)deltat;

// Movement
-(void) moveLeftWithDeltaT: (CFTimeInterval)deltat;
-(void) moveRightWithDeltaT: (CFTimeInterval)deltat;

// up/down should not be used directly with objects that also use jump/moveWithCurrentTime
-(void) moveUpWithDeltaT: (CFTimeInterval)deltat;
-(void) moveDownWithDeltaT: (CFTimeInterval)deltat;

// more complicated movement functions that use velocity
-(void) jump;
-(void) applyGravityWithDeltaT: (CFTimeInterval)currentTime;

// Basic utility methods, mostly to cut down on typing CGRectGetMaxX, etc.
// Totally not needed, but a little useful.
- (CGFloat) minX;
- (CGFloat) minY;
- (CGFloat) maxX;
- (CGFloat) maxY;
- (CGFloat) height;
- (CGFloat) width;
- (BOOL) isInFrame: (CGRect)otherFrame;

// Basic status methods
// Yes if our character's feet are *not* on the lowest point of the scene.
- (BOOL) isInAir;

@end
