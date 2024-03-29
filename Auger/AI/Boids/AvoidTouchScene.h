//
//  BoidScene.h
//  BoidsExample
//
//  Created by Mario.Gonzalez on 9/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Boid.h"

// HelloWorld Layer
@interface AvoidTouchScene : CCLayerColor
{
	CCSpriteBatchNode* __unsafe_unretained _sheet;
	Boid* _flockPointer; // This is a cheap style linked list
	
	CGPoint _currentTouch;
}

@property(nonatomic) Boid* _flockPointer;
@property(nonatomic, unsafe_unretained) CCSpriteBatchNode* _sheet;
@property(nonatomic, assign) CGPoint _currentTouch;
// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) tick: (ccTime) dt;
@end
