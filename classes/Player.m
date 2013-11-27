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

-(id) initWithImageNamed:(NSString *)name
                andScene:(SKScene*)parentScene {
    if (self = [super initWithImageNamed:name andScene:parentScene]) {
        lastBulletSpawn = 0;
        bulletsPerSecond = 10.0;
        bulletTexture = [SKTexture textureWithImageNamed:@"bullet1"];
    }
    
    return self;
}

- (void) fireWithCurrentTime: (NSTimeInterval) currentTime {
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
        SKAction *flyRight =  [SKAction moveByX:-1000 y:0.0 duration: 0.5];
        [self.scene addChild:bullet];
        [bullet runAction:flyRight];
    }
}

@end