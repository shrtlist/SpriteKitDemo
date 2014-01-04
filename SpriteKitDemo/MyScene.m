/*
 * Copyright 2014 shrtlist.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MyScene.h"

@implementation MyScene

#pragma mark - Designated initializer

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        // Set up scene here
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
    }
    
    return self;
}

#pragma mark - SKScene methods

- (void)didMoveToView:(SKView *)view {
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    sprite.position = CGPointMake(100.0, 100.0);
    sprite.name = @"spaceship";
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width * 0.5];
    sprite.physicsBody.affectedByGravity = YES;
    sprite.physicsBody.restitution = 0.5;
    
    [self addChild:sprite];
}

// Called when a touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    NSArray *nodes = [self nodesAtPoint:location];
    
    SKNode *spaceship = [self childNodeWithName:@"spaceship"];
    
    if ([nodes count] == 0) {
        
        double angle = atan2(location.y-spaceship.position.y, location.x-spaceship.position.x);
        [spaceship runAction:[SKAction rotateToAngle:angle duration:0.75]];
        
        [spaceship.physicsBody applyImpulse:CGVectorMake(20*cos(angle), 20*sin(angle))];
    }
    else { // tapped on a node
        // load the particles
        NSString *path = [[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"sks"];
        SKEmitterNode *particles = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

        [particles runAction:[SKAction sequence:@[[SKAction waitForDuration:0.8],
                                                  [SKAction fadeAlphaTo:0 duration:.2],
                                                  [SKAction removeFromParent]]]];
        
        [spaceship addChild:particles];
    }
}

@end
