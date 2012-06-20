
#import "HelloWorldLayer.h"
@interface HelloWorldLayer (PrivateMethods)
-(void) addLabels;
-(void) changeInputType:(ccTime)delta;
@end

@implementation HelloWorldLayer


-(void)reset
{
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:SCRATCHABLE_IMAGE];    

    CCSprite *sourceImage = [CCSprite spriteWithFile:@"ice_background.png"];
    sourceImage.position = ccp( size.width * 0.5f , size.height * 0.5f );
	sourceImage.scale = 2.0;
	//sourceImage.rotation = 90;
	//[self addChild:sourceImage];
	
    [scratchableImage begin];
    [sourceImage visit];
    [scratchableImage end];
    
       
}

-(id) init
{
	if ((self = [super init]))
	{
		CCLOG(@"%@ init", NSStringFromClass([self class]));
		
		glClearColor(0.2f, 0.1f, 0.15f, 1.0f);
		

		CCDirector* director = [CCDirector sharedDirector];
		
		//[[CCDirector sharedDirector] setPixelFormat:KKPixelFormatRGBA8888];
		
		//[director setOpenGLView:glView];
		
		// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	//	if( ! [director enableRetinaDisplay:YES] )
	//		CCLOG(@"Retina Display Not supported");
		
		CGPoint screenCenter = director.screenCenter;
		
		

		
/*
		particleFX = [CCParticleMeteor node];
		particleFX.position = screenCenter;
		[self addChild:particleFX z:-2];
*/
		[self addLabels];
		/*
		boids = [ObstacleCourseScene scene];
		boids.position = screenCenter;
		boids.scale = 2.0;
*/
//		[self addChild:boids];
				
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	//	CCNode *node = [CCNode node];
	//	[self addChild:node z:0];
		// Create a background image
        rippleImage = [ CCSprite spriteWithFile:@"OceanSequence.png" ];
		//id waves = [CCWaves actionWithWaves:5 amplitude:20 horizontal:YES vertical:NO grid:ccg(15,10) duration:5];
		//[rippleImage runAction: [CCRepeatForever actionWithAction: waves]];
		 //rippleImage.transformAnchor = cpvzero;
		rippleImage.position = screenCenter;
		rippleImage.scale = 2.0;
		
	//	background.scale = 2.0;
        [self addChild: rippleImage ];
        
        // Scratchable layer
        CCRenderTexture *scratchableImage = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
        scratchableImage.position = ccp( size.width * 0.5f , size.height * 0.5f );
        [self addChild:scratchableImage z:1 tag:SCRATCHABLE_IMAGE];
        [[scratchableImage sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
		
        // Source image
        [self reset];
		
		revealSprite = [CCSprite spriteWithFile:@"Particle.png"];
        revealSprite.position = ccp( -10000, 0);
		[revealSprite setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];

	
	 
		
				
		
		//[water runAction:[CCLiquid actionWithWaves:40 amplitude:37 grid:ccg(6, 33) duration:200]];
		
		[self scheduleUpdate];
		[self schedule:@selector(changeInputType:) interval:8.0f];
		
		// initialize KKInput
		KKInput* input = [KKInput sharedInput];
		//input.accelerometerActive = input.accelerometerAvailable;
		//input.gyroActive = input.gyroAvailable;
		input.multipleTouchEnabled = YES;
	//	input.gestureTapEnabled = input.gesturesAvailable;
	//	input.gestureDoubleTapEnabled = input.gesturesAvailable;
	//	input.gestureSwipeEnabled = input.gesturesAvailable;
		input.gestureLongPressEnabled = input.gesturesAvailable;
	//	input.gesturePanEnabled = input.gesturesAvailable;
	//	input.gestureRotationEnabled = input.gesturesAvailable;
	//	input.gesturePinchEnabled = input.gesturesAvailable;
	
		 
	}

	return self;
}

-(void) addLabels
{
	CCDirector* director = [CCDirector sharedDirector];
	CGPoint screenCenter = director.screenCenter;



}




-(void) moveParticleFXToTouch
{
	KKInput* input = [KKInput sharedInput];
	
	if (input.touchesAvailable)
	{
		particleFX.position = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
		
		CCSprite* touchSprite = [CCSprite spriteWithFile:@"Particle.png"];
		[touchSprite setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA  }];
		touchSprite.position = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
		touchSprite.scale = 0.1f;
		[self addChild:touchSprite];
		
		{
			id scaleUp = [CCScaleTo actionWithDuration:20 scale:3];
			id scaleDn = [CCScaleTo actionWithDuration:20 scale:0.1f];
			id sequence = [CCSequence actions:scaleUp, nil, nil];
			id repeat = [CCRepeat actionWithAction:sequence times:1];
			[touchSprite runAction:repeat];
		}
		

		
	}
}

-(void) detectSpriteTouched
{
	KKInput* input = [KKInput sharedInput];

	CCSprite* touchSprite = (CCSprite*)[self getChildByTag:99];
	if ([input isAnyTouchOnNode:touchSprite touchPhase:KKTouchPhaseAny])
	{
		touchSprite.color = ccGREEN;
	}
	else
	{
		touchSprite.color = ccWHITE;
	}
}

-(void) createSmallExplosionAt:(CGPoint)location
{
	CCParticleExplosion* explosion = [[CCParticleExplosion alloc] initWithTotalParticles:50];
#ifndef KK_ARC_ENABLED
	[explosion autorelease];
#endif
	explosion.autoRemoveOnFinish = YES;
	explosion.blendAdditive = YES;
	explosion.position = location;
	explosion.speed *= 4;
	[self addChild:explosion];
}

-(void) createLargeExplosionAt:(CGPoint)location
{
	CCParticleExplosion* explosion = [[CCParticleExplosion alloc] initWithTotalParticles:100];
#ifndef KK_ARC_ENABLED
	[explosion autorelease];
#endif
	explosion.autoRemoveOnFinish = YES;
	explosion.blendAdditive = NO;
	explosion.position = location;
	explosion.speed *= 8;
	[self addChild:explosion];
}

-(void) gestureRecognition
{

}

-(void) detectMouseOverTouchSprite
{
	KKInput* input = [KKInput sharedInput];
	
	CCSprite* touchSprite = (CCSprite*)[self getChildByTag:99];
	if ([touchSprite containsPoint:input.mouseLocation])
	{
		touchSprite.color = ccGREEN;
	}
	else
	{
		touchSprite.color = ccWHITE;
	}
}






-(void) update:(ccTime)delta
{
	
	

	//[rippleImage update: delta];

	/*
	KKInput* input = [KKInput sharedInput];
	if ([input isAnyTouchOnNode:self touchPhase:KKTouchPhaseAny])
	{
		CCLOG(@"Touch: beg=%d mov=%d sta=%d end=%d can=%d",
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseBegan], 
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseMoved], 
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseStationary],
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseEnded],
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseCancelled]);
	}
	//[boids tick:delta];
	
*/
	CCDirector* director = [CCDirector sharedDirector];
	
		[self gestureRecognition];
	
}

void drawSolidPoly( CGPoint *poli, int points )
{
	glVertexPointer(2, GL_FLOAT, 0, poli);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, points);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}

void drawSolidCircle( CGPoint center, float r, float a, int segs, BOOL
					 drawLineToCenter)
{
	int additionalSegment = 1;
	if (drawLineToCenter)
		additionalSegment++;
	
	const float coef = 2.0f * (float)M_PI/segs;
	
	float *vertices = malloc( sizeof(float)*2*(segs+2));
	if( ! vertices )
		return;
	
	memset( vertices,0, sizeof(float)*2*(segs+2));
	
	for(int i=0;i<=segs;i++)
	{
		float rads = i*coef;
		float j = r * cosf(rads + a) + center.x;
		float k = r * sinf(rads + a) + center.y;
		
		vertices[i*2] = j;
		vertices[i*2+1] =k;
	}
	vertices[(segs+1)*2] = center.x;
	vertices[(segs+1)*2+1] = center.y;
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, segs+additionalSegment);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	
	free( vertices );
}


-(void) draw
{
	KKInput* input = [KKInput sharedInput];
	if (input.touchesAvailable)
	{
		NSUInteger color = 0;
		KKTouch* touch;
		
		//if(input.gestureLongPressBegan)
		
		
		CCARRAY_FOREACH(input.touches, touch)		
		{
			revealSprite.position = touch.location;
			switch (color)
			{
				case 0:
					glColor4f(0.2f, 1, 0.2f, 0.5f);
					break;
				case 1:
					glColor4f(0.2f, 0.2f, 1, 0.5f);
					break;
				case 2:
					glColor4f(1, 1, 0.2f, 0.5f);
					break;
				case 3:
					glColor4f(1, 0.2f, 0.2f, 0.5f);
					break;
				case 4:
					glColor4f(0.2f, 1, 1, 0.5f);
					break;
					
				default:
					break;
			}
			color++;
			
			glLineWidth(4.0f);
			ccDrawCircle(touch.location, 60, 0, 16, NO);
			
			glLineWidth(2.0f);
			ccDrawCircle(touch.previousLocation, 30, 0, 16, NO);
			
			glLineWidth(1.0f);
			glColor4f(1, 1, 1, 1);
			ccDrawLine(touch.location, touch.previousLocation);
			
			if (CCRANDOM_0_1() > 0.98f)
			{
				//[input removeTouch:touch];
			}
		}
		
		// reset GL state
		glColor4f(1, 1, 1, 1);
		glLineWidth(1.0f);
	}
	
	CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:SCRATCHABLE_IMAGE];
    
    // Update the render texture
    [scratchableImage begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw
    [revealSprite visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [scratchableImage end];
}
 
@end
