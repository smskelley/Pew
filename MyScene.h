//
//  MyScene.h
//  Pew
//

//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval deltat;


// Methods to define the area of the window that objects should reside
- (CGFloat) minX;
- (CGFloat) minY;
- (CGFloat) maxX;
- (CGFloat) maxY;

@end
