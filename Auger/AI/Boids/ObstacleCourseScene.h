//
//  ObstacleCourseScene.h
//  BoidsExample
//
//  Created by Mario.Gonzalez on 9/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Boid.h"

// HelloWorld Layer
@interface ObstacleCourseScene : CCLayerColor
{
	CCSpriteBatchNode *__unsafe_unretained _sheet;
	Boid *_flockPointer; // This is a cheap style linked list
	Boid *_obstaclesPointer;
	
	CGPoint _currentTouch;
	CGPoint CGPointOfInterest;
}

@property(nonatomic) Boid *_flockPointer;
@property(nonatomic) Boid *_obstaclesPointer;

@property(nonatomic, unsafe_unretained) CCSpriteBatchNode* _sheet;
@property(nonatomic, assign) CGPoint _currentTouch;
// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) tick: (ccTime) dt;
-(void) updateObstacles:(ccTime)dt;
-(void) updateFlock:(ccTime)dt;

- (void) createTouchChasingFlock;
- (void) createRandomObstacles;
@end
