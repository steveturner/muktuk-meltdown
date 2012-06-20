

#import "kobold2d.h"
#import "RippleSprite.h"
#import "ObstacleCourseScene.h"

#define SCRATCHABLE_IMAGE   10
typedef enum 
{
	kAccelerometerValuesRaw,
	kAccelerometerValuesSmoothed,
	kAccelerometerValuesInstantaneous,
	kGyroscopeRotationRate,
	kDeviceMotion,
	
	kInputTypes_End,
} InputTypes;

@interface HelloWorldLayer : CCScene
{
	CCSprite* ship;
	CCSprite* background;
	CCSprite* revealSprite;
	CCRenderTexture* scratchLayer;
	CCSprite *rippleImage;
	CCParticleSystem* particleFX;
	ObstacleCourseScene* boids;
	InputTypes inputType;
}

@end
