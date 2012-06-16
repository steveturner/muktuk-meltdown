

#import "kobold2d.h"

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
	CCParticleSystem* particleFX;
	InputTypes inputType;
}

@end
