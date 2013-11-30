//
//  Player.m
//  Pew
//
//  Created by Sean Kelley on 11/25/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "Player.h"

@implementation Player {
}

@synthesize lastBulletSpawn;
@synthesize bulletsPerSecond;
@synthesize bulletSpeed;

-(id) initWithImageNamed:(NSString *)name
                andScene:(SKScene*)parentScene {
    if (self = [super initWithImageNamed:name andScene:parentScene]) {
        lastBulletSpawn = 0;
        bulletsPerSecond = 10.0;
        bulletSpeed = 0.5;
        bulletTexture = [SKTexture textureWithImageNamed:@"bullet1"];
    }
    
    return self;
}

- (void) fireRightWithCurrentTime: (NSTimeInterval) currentTime {
    // Only allow the player to fire 10 bullets per second.
    if (currentTime - lastBulletSpawn > 1.0 / bulletsPerSecond) {
        // Fire the bullet
        lastBulletSpawn = currentTime;
        // Create the bullet
        Sprite *bullet = [[Sprite alloc] initWithTexture:bulletTexture
                                                andScene:scene ];
        // Position it on the right side of the player
        bullet.position = CGPointMake(CGRectGetMaxX(self.frame),
                                      CGRectGetMidY(self.frame));
        bullet.scale = 0.2;
        SKAction *flyRight =  [SKAction moveByX:1000 y:0.0 duration: bulletSpeed];
        [self.scene addChild:bullet];
        [bullet runAction:flyRight];
    }
}

- (void) fireLeftWithCurrentTime: (NSTimeInterval) currentTime {
    // Only allow the player to fire 10 bullets per second.
    if (currentTime - lastBulletSpawn > 1.0 / bulletsPerSecond) {
        // Fire the bullet
        lastBulletSpawn = currentTime;
        // Create the bullet
        Sprite *bullet = [[Sprite alloc] initWithTexture:bulletTexture
                                                andScene:scene ];
        // Position it on the right side of the player
        bullet.position = CGPointMake(CGRectGetMinX(self.frame),
                                      CGRectGetMidY(self.frame));
        bullet.scale = 0.2;
        SKAction *flyRight =  [SKAction moveByX:-1000 y:0.0 duration: bulletSpeed];
        [self.scene addChild:bullet];
        [bullet runAction:flyRight];
    }
}

@end
