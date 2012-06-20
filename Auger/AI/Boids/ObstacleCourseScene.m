//
//  HelloWorldLayer.m
//  BoidsExample
//
//  Created by Mario.Gonzalez on 9/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

// Import the interfaces
#import "ObstacleCourseScene.h"

// HelloWorld implementation
@implementation ObstacleCourseScene
@synthesize _flockPointer;
@synthesize _obstaclesPointer;

@synthesize _sheet;
@synthesize _currentTouch;
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ObstacleCourseScene *layer = [ObstacleCourseScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] ))
	{
		srandom(time(NULL));
		
		//[self setColor: ccc3(128, 128, 128)]
		//self._sheet = [CCSpriteBatchNode spriteSheetWithFile:@"boid.png" capacity:201];
		self._sheet = [CCSpriteBatchNode batchNodeWithFile:@"fish-red.png" capacity:201];
		
		
        self.isTouchEnabled = YES;
		self._currentTouch = CGPointZero;
		
		[_sheet setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE}];
		[self addChild:_sheet z:0 tag:0];
		
		// Slightly to the right of the screen so they can never get there (because they're being sent back to the left side when they pass the screen bounds)
		CGPointOfInterest = ccp([[CCDirector sharedDirector] winSize].width + 5, [[CCDirector sharedDirector] winSize].height/2);
		
		[self createRandomObstacles];
		[self createTouchChasingFlock];
		
		[self schedule: @selector(tick:)];
		
	}
	return self;
}

- (void) createRandomObstacles
{
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CGRect boidRect = CGRectMake(17, 0, 16, 16);
	
	// Make the head of the linked list
	_obstaclesPointer = [Boid spriteWithBatchNode:_sheet rect: boidRect];
	Boid *previousBoid = _obstaclesPointer;
	Boid *boid = _obstaclesPointer;
	
	// Create many of them
	float count = 10.0f;
	for (int i = 0; i < count; i++) 
	{
		// Create a linked list
		// The first one has no previous and is made for us already
		if(i != 0)
		{
			boid = [Boid spriteWithBatchNode:_sheet rect: boidRect];
			previousBoid->_next = boid; // special case for the first one
		}
		
		previousBoid = boid;
		
		// Initialize behavior properties for this boid
		// You want the flock to behavior basically the same, but have a TINY variation among members
		
		//[boid setSpeedMax: 2.0f andSteeringForceMax:1.0f];			
		[boid setSpeedMax:0.2f withRandomRangeOf:0.05f andSteeringForceMax:0.25f withRandomRangeOf:0.1f];
		[boid setWanderingRadius: 16.0f lookAheadDistance: 70.0f andMaxTurningAngle:0.1f];
		[boid setEdgeBehavior: EDGE_WRAP];
		
		// Cocos properties
		[boid setPos: ccp( (100 + CCRANDOM_0_1() * screenSize.width) - 50, (100 + CCRANDOM_0_1() * screenSize.height) - 50)];
		// Color
		[boid setOpacity:128];
		
		[boid setScale: 1.5];
		[boid setColor:ccc3(255, 50, 50)];
		[_sheet addChild:boid];
	}
}

- (void) createTouchChasingFlock
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CGRect boidRect = CGRectMake(0,0, 16, 16);
	
	_flockPointer = [Boid spriteWithBatchNode:_sheet rect: boidRect];
	Boid *previousBoid = _flockPointer;
	Boid *boid = _flockPointer;
	
	// Create many of them
	float count = 30;
	for (int i = 0; i < count; i++) 
	{
		// Create a linked list
		// The first one has no previous and is made for us already
		if(i != 0)
		{
			boid = [Boid spriteWithBatchNode:_sheet rect: boidRect];
			previousBoid->_next = boid; // special case for the first one
		}
		
		previousBoid = boid;
		
		boid.doRotation = YES;
		
		// Initialize behavior properties for this boid
		// You want the flock to behavior basically the same, but have a TINY variation among members
		
		//[boid setSpeedMax: 2.0f andSteeringForceMax:1.0f];			
		[boid setSpeedMax: 2.2f withRandomRangeOf:0.25f andSteeringForceMax:1.0f withRandomRangeOf:0.0f];
		[boid setWanderingRadius: 16.0f lookAheadDistance: 40.0f andMaxTurningAngle:0.2f];
		[boid setEdgeBehavior: EDGE_WRAP];
		
		// Cocos properties
		[boid setPos: ccp( CCRANDOM_0_1() * screenSize.width,  CCRANDOM_0_1() * screenSize.height)];
		// Color
		[boid setOpacity:128];
		[_sheet addChild:boid];
	}
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	[super onEnter];
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
	
}

-(void) tick: (ccTime) dt
{
	[self updateObstacles:dt];
	[self updateFlock:dt];
}

-(void) updateObstacles:(ccTime)dt
{
	Boid* boid = _obstaclesPointer;
	while(boid)
	{
		Boid* b = boid;
		boid = b->_next;
		[b wander: 1.0f];
		[b update];
	}
}

-(void) updateFlock:(ccTime)dt
{
	Boid* boid = _flockPointer;
	
	while(boid)
	{
		Boid* b = boid;
		boid = b->_next;
		[b wander: 0.45f];
		
		// Go to where the user is touching, OR go to the center of the screen other wise but care less about getting there
		if ( CGPointEqualToPoint( _currentTouch, CGPointZero ) == NO )
			[b seek:self._currentTouch usingMultiplier:0.25f]; // go towards touch
		else
			[b seek:CGPointOfInterest usingMultiplier:0.25f]; // go towards center of screen
		
		// Flock
		[b 
		 flock:_flockPointer
		 withSeparationWeight:0.5f
		 andAlignmentWeight:0.05f
		 andCohesionWeight:0.2f
		 andSeparationDistance:5.0f
		 andAlignmentDistance:15.0f
		 andCohesionDistance:20.0f
		 ];
		
		// Flee away from all obstacles
		Boid *nextObstacle = _obstaclesPointer;
		while(nextObstacle)
		{
			Boid *currentObstacle = nextObstacle;
			nextObstacle = currentObstacle->_next;
			
			[b flee:currentObstacle->_internalPosition panicAtDistance:30 usingMultiplier:0.5f];
		}
		
		[b update];
	}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	self._currentTouch = [self convertTouchToNodeSpace: touch];
	return YES;
}
// touch updates:
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	self._currentTouch = [self convertTouchToNodeSpace: touch];
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	self._currentTouch = CGPointZero;
}

// on "dealloc" you need to release all your retained objects

@end