//
//  Player.h
//  Pew
//
//  Created by Sean Kelley on 11/25/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "Sprite.h"

@interface Player : Sprite {
}

@property (nonatomic) NSTimeInterval lastBulletSpawn;
@property (nonatomic) float bulletsPerSecond;

-(id) initWithImageNamed:(NSString *)name andScene:(SKScene *)parentScene;

- (void) fireWithCurrentTime: (NSTimeInterval) currentTime;

@end
