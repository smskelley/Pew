//
//  MyScene.m
//  Pew
//
//  Created by Sean Kelley on 11/24/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "MyScene.h"
#import "KeyStates.h"
#import "Sprite.h"
#import "Player.h"

@implementation MyScene
{
    Player *player;
    Sprite *ground;
    SKLabelNode *text;
    KeyStates *keyStates;
    int score;
}

@synthesize lastUpdateTimeInterval;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        score = 0;
        keyStates = [[KeyStates alloc] init];
        self.backgroundColor = [SKColor colorWithRed:0.83 green:0.8 blue:0.81 alpha:1.0];
        
        // setup player
        player = [[Player alloc] initWithImageNamed:@"dude"
                                           andScene:self ];
        player.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        player.scale = 0.2;
        player.speed = 10;
        
        // setup ground
        ground = [[Sprite alloc] initWithImageNamed:@"ground" andScene:self];
        ground.scale = 0.4;
        ground.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMinY(self.frame) +
                                      CGRectGetHeight(ground.frame) / 2.0);
        
        
        // setup text
        text = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        text.text = @"Score: 0";
        text.fontSize = 65;
        text.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMaxY(self.frame) -
                                    CGRectGetHeight(text.frame));
        
        [self addChild:ground];
        [self addChild:text];
        [self addChild:player];
    }
    return self;
}

// lowest/highest point something should occupy. Takes into account ground.
- (CGFloat) minX {
    return CGRectGetMinX(self.frame);
}
- (CGFloat) minY {
    return CGRectGetMaxY(ground.frame);
}
- (CGFloat) maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat) maxY {
    return CGRectGetMaxY(self.frame);
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    Sprite *monster = [[Sprite alloc] initWithImageNamed:@"monster1"
                                       andScene:self ];
    monster.position = location;
    monster.scale = 0.2;
    [self addChild:monster];
}

-(void)keyDown:(NSEvent *)theEvent {
    [keyStates setDown:[theEvent keyCode]];
}

-(void)keyUp:(NSEvent *)theEvent {
    [keyStates setUp:[theEvent keyCode]];
}

-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval deltat = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    
    [self movePlayerWithTimeDelta:deltat andCurrentTime:currentTime];
}

-(void)movePlayerWithTimeDelta:(CFTimeInterval)deltat
                andCurrentTime:(CFTimeInterval)currentTime {
    if ([keyStates stateForKey:KEY_A]) // left
        [player moveLeftWithDeltaT: deltat];
    if ([keyStates stateForKey:KEY_D]) // right
        [player moveRightWithDeltaT: deltat];
    if ([keyStates stateForKey:KEY_W]) // up
        [player jumpWithCurrentTime:currentTime];
    if ([keyStates stateForKey:KEY_SPACE]) // shoot
    {
        [self incrementScore];
        [player fireWithCurrentTime:currentTime];
    }
    
    // apply gravity
    [player moveWithCurrentTime:currentTime];
}

-(int)incrementScore {
    text.text = [NSString stringWithFormat:@"Score: %d", ++score];
    return score;
}

@end
