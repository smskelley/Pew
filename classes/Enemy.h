//
//  Enemy.h
//  Pew
//
//  Created by Sean Kelley on 11/27/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "Player.h"

// Enemies have all abilities that players do, but they also have AI
@interface Enemy : Player {
    NSMutableArray *targets;
}

// Initialization
-(id) initWithImageNamed:(NSString *)name andScene:(SKScene *)parentScene;

// AI specific
-(void) moveWithDeltaT: (CFTimeInterval) deltat;
-(void) decideAndDoWithCurrentTime: (CFTimeInterval) currentTime;
-(void) addTarget: (Player *)target;

@end
