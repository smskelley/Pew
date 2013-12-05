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
    CGFloat enemySpawnTimeFrequency;
    int enemiesSpawned;
    Sprite *ground;
    SKLabelNode *scoreText;
    SKLabelNode *livesText;
    KeyStates *keyStates;
    int score;
    SKAction *playLossSound;
}

@synthesize lastUpdateTimeInterval;
@synthesize lastSpawnTimeInterval;
@synthesize deltat;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // don't create the enemy in the initialization, allow them to be spawned naturally.
        enemySpawnTimeFrequency = 2.0;
        enemiesSpawned = 0;
        
        // setup sounds
        playLossSound = [SKAction playSoundFileNamed:@"yougetnothing.mp3"
                                   waitForCompletion:NO];
        
        score = deltat = lastUpdateTimeInterval = lastSpawnTimeInterval = 0;
        keyStates = [[KeyStates alloc] init];
        self.backgroundColor = [SKColor colorWithRed:0.83 green:0.8 blue:0.81 alpha:1.0];
        
        
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
        player.lives = 10;
        player.maxSpeed = 8;
       
        // setup scoreText
        scoreText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreText.fontSize = 65;
        scoreText.text = @"Score: 0";
        scoreText.position = CGPointMake(CGRectGetMinX(self.frame) + 20
                                         + CGRectGetWidth(scoreText.frame) * .5,
                                         CGRectGetMaxY(self.frame)
                                         - CGRectGetHeight(scoreText.frame));
        // setup livesText
        livesText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        livesText.fontSize = 65;
        livesText.text = [NSString stringWithFormat:@"Lives %d",player.lives];
        livesText.position = CGPointMake(CGRectGetMaxX(self.frame)
                                         - CGRectGetWidth(livesText.frame),
                                         CGRectGetMaxY(self.frame)
                                         - CGRectGetHeight(livesText.frame));
        [self addChild:ground];
        [self addChild:scoreText];
        [self addChild:livesText];
        [self addChild:player];
    }
    return self;
}

- (void) spawnNewEnemy {
    // setup Enemy
    Enemy *enemy = [[Enemy alloc] initWithImageNamed:@"dude"
                                       andScene:self ];
    float difficultyRamp = 0.5;
    enemy.scale = 0.2;
    enemy.position = CGPointMake([self minX] + [enemy width] / 2.0,
                                 [self minY] + [enemy height] / 2.0);
    enemy.maxSpeed = 1.0 + enemiesSpawned * 0.5 * difficultyRamp;
    // screen width / (self.maxSpeed * SPEEDUP_FACTOR) is time taken to traverse screen
    enemy.bulletSpeed = (CGRectGetWidth(self.frame) / (enemy.maxSpeed * enemy.SPEEDUP_FACTOR)) * 0.5;
    enemy.bulletsPerSecond = 0.5 + enemiesSpawned * 0.1 * difficultyRamp;
    enemy.name = @"enemy";
    [enemy addTarget:player];
    [self addChild:enemy];
    enemiesSpawned++;
    
    // limit maximum difficulty
    enemy.maxSpeed = MIN(7.0, enemy.maxSpeed);
    enemy.bulletsPerSecond = MIN(3.0, enemy.bulletsPerSecond);
    enemySpawnTimeFrequency = MAX(0.7, enemySpawnTimeFrequency * 0.95);
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
    if ([theEvent keyCode] == KEY_DELETE)
        [self restartGame];
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
    
    // perform actions only when scene is not paused
    if (!self.paused) {
        [self movePlayer];
        
        // Move all enemies
        [self enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *enemy, BOOL *stop) {
            if ([(Enemy*)enemy isAlive]) {
                [(Enemy*)enemy moveWithDeltaT:deltat];
                [(Enemy*)enemy decideAndDoWithCurrentTime:lastUpdateTimeInterval];
            }
        }];
        
        if (lastSpawnTimeInterval + enemySpawnTimeFrequency < currentTime) {
            lastSpawnTimeInterval = currentTime;
            [self spawnNewEnemy];
        }
    }
}

// handle physics calculations
-(void)didEvaluateActions {
    // apply gravity on player and enemies, only when scene is not paused
    if (!self.paused) {
        [player applyGravityWithDeltaT:deltat];
        [self enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *enemy, BOOL *stop) {
            if ([(Enemy*)enemy isAlive])
                [(Enemy*)enemy applyGravityWithDeltaT:deltat];
        }];
    }
}

// perform actions after all physics calculations have completed
-(void)didSimulatePhysics {
    // check for collisions only when scene is not paused
    if (!self.paused) {
        //check for collision between enemy and player
        [self enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *enemy, BOOL *stop) {
            // make sure the enemy is still in the scene's frame, if it isn't, remove it
            if (!CGRectIntersectsRect(enemy.frame, self.frame))
                [enemy removeFromParent];
            // now check for collision
            else if ([player isInFrame:enemy.frame] && [(Enemy*)enemy isAlive]) {
                [(Enemy*)enemy die];
                [self incrementScore];
                [player hitEnemy];
            }
        }];
        
        //check for collision between player and bullets
        [self enumerateChildNodesWithName:@"bullet" usingBlock:^(SKNode *node, BOOL *stop) {
            // make sure bullet still in frame
            if (!CGRectIntersectsRect(node.frame, self.frame))
                [node removeFromParent];
            // Then check for collision with the player
            else if ([player isInFrame:node.frame]) {
                [player wasHit];
                [self updateLivesText];
                if (player.lives == 0)
                    [self gameOver];
                [node removeFromParent];
            }
        }];
    }
    // remove children of scene if they're not within the scene's frame
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
    if ([keyStates stateForKey:KEY_W] | [keyStates stateForKey:KEY_SPACE]) // jump
        [player jump];
}

/**************************/
/* Handle text operations */
/**************************/
-(int)incrementScore {
    scoreText.text = [NSString stringWithFormat:@"Score: %d", ++score];
    scoreText.position = CGPointMake(CGRectGetMinX(self.frame) + 20
                                     + CGRectGetWidth(scoreText.frame) * .5,
                                     CGRectGetMaxY(self.frame)
                                     - CGRectGetHeight(scoreText.frame));
    return score;
}
-(int)updateLivesText {
    livesText.text = [NSString stringWithFormat:@"Lives: %d", player.lives];
    return player.lives;
}

/*************************/
/* Game state operations */
/*************************/
-(void)gameOver {
    SKLabelNode* gameOverText = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameOverText.fontSize = 35;
    gameOverText.text = @"Game Over. Press Delete to Restart";
    gameOverText.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
    [self addChild:gameOverText];
    [self runAction:[SKAction sequence:@[ playLossSound,
                                          [SKAction runBlock:^{ self.paused = YES; }]
                                        ]]];
}
-(void)restartGame {
    SKScene *thisScene = [[MyScene alloc] initWithSize:self.size];
    SKTransition *door = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    [self.view presentScene:thisScene transition:door];
}

@end
