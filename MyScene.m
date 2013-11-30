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
#import "Enemy.h"

@implementation MyScene
{
    Player *player;
    Enemy *enemy;
    CGFloat enemySpawnTimeFrequency;
    Sprite *ground;
    SKLabelNode *text;
    KeyStates *keyStates;
    int score;
}

@synthesize lastUpdateTimeInterval;
@synthesize lastSpawnTimeInterval;
@synthesize deltat;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // don't create the enemy in the initialization, allow them to be spawned naturally.
        enemy = nil;
        enemySpawnTimeFrequency = 10.0;
        
        score = deltat = lastUpdateTimeInterval = lastSpawnTimeInterval = 0;
        keyStates = [[KeyStates alloc] init];
        self.backgroundColor = [SKColor colorWithRed:0.83 green:0.8 blue:0.81 alpha:1.0];
        
        
        player.speed = 10;
        
        // setup ground
        ground = [[Sprite alloc] initWithImageNamed:@"ground" andScene:self];
        ground.scale = 0.4;
        ground.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMinY(self.frame) +
                                      CGRectGetHeight(ground.frame) / 2.0);
        
        // setup player
        player = [[Player alloc] initWithImageNamed:@"monster1"
                                           andScene:self ];
        player.scale = 0.2;
        player.position = CGPointMake(CGRectGetMidX(self.frame),
                                      [self minY] + [player height] / 2.0);
        player.maxSpeed = 8;
       
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

- (void) spawnNewEnemy {
    // setup Enemy
    enemy = [[Enemy alloc] initWithImageNamed:@"dude"
                                       andScene:self ];
    enemy.scale = 0.2;
    enemy.position = CGPointMake([self minX] + [enemy width] / 2.0,
                                 [self minY] + [enemy height] / 2.0);
    enemy.maxSpeed = 1.0;
    [self addChild:enemy];
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

/***********************************/
/* User Interaction Event Handlers */
/***********************************/
-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    Sprite *monster = [[Sprite alloc] initWithImageNamed:@"dude"
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

/********************************************/
/* Methods automatically called every frame */
/********************************************/
// perform basic actions
-(void)update:(CFTimeInterval)currentTime {
    deltat = currentTime - lastUpdateTimeInterval;
    lastUpdateTimeInterval = currentTime;
    
    [self movePlayer];
    
    if (enemy != nil)
        [enemy moveWithDeltaT:deltat];
    
    if (lastSpawnTimeInterval + enemySpawnTimeFrequency < currentTime) {
        lastSpawnTimeInterval = currentTime;
        [self spawnNewEnemy];
    }
}

// handle physics calculations
-(void)didEvaluateActions {
    // apply gravity on player
    [player applyGravityWithDeltaT:deltat];
    [enemy applyGravityWithDeltaT:deltat];
}

// perform actions after all physics calculations have completed
-(void)didSimulatePhysics {
    [enemy decideAndDoWithCurrentTime:lastUpdateTimeInterval];
}

/****************************************/
/* Methods called manually once a frame */
/****************************************/
// Handle input to move player
-(void)movePlayer {
    if ([keyStates stateForKey:KEY_A]) // left
        [player moveLeftWithDeltaT: deltat];
    if ([keyStates stateForKey:KEY_D]) // right
        [player moveRightWithDeltaT: deltat];
    if ([keyStates stateForKey:KEY_W]) // up
        [player jump];
    if ([keyStates stateForKey:KEY_SPACE]) // shoot
    {
        [self incrementScore];
        [player fireLeftWithCurrentTime:lastUpdateTimeInterval];
    }
}

/***************************/
/* Handle score operations */
/***************************/
-(int)incrementScore {
    text.text = [NSString stringWithFormat:@"Score: %d", ++score];
    return score;
}

@end
