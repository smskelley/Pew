//
//  Player.h
//  Pew
//
//  Created by Sean Kelley on 11/25/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "Sprite.h"

@interface Player : Sprite {
    SKTexture *bulletTexture;
    BOOL alive;
    SKAction *playProjectileSound;
    SKAction *playHitSound;
}

@property (nonatomic) NSTimeInterval lastBulletSpawn;
@property (nonatomic) float bulletsPerSecond;
@property (nonatomic) float bulletSpeed;
@property (nonatomic) int lives;

-(id) initWithImageNamed:(NSString *)name andScene:(SKScene *)parentScene;

- (void) fireLeftWithCurrentTime: (NSTimeInterval) currentTime;
- (void) fireRightWithCurrentTime: (NSTimeInterval) currentTime;
- (void) die;
- (BOOL) isAlive;
- (void) wasHit;

@end
