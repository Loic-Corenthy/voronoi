#import "Vec2f.h"

@implementation Vec2f

#pragma mark -
#pragma mark Basic methods

- (id)init
{
    self = [super init];
    if (self) {
        x = 0.0;
        y = 0.0;
    }

    return self;
}

- (void) dealloc
{
    [super dealloc];
}


- (double) x
{
    return x;
}

- (double) y
{
    return y;
}

- (double) valueAtIndex:(NSInteger) pIndex
{
    NSAssert(pIndex == 0 || pIndex == 1, @"Index out of range");

    if (pIndex == 0) {
        return x;
    } else if(pIndex == 1){
        return y;
    }

    NSAssert(FALSE, @"Impossible to reach this point");
    return 42.0;

}

- (void) setX:(double) pX
{
    x = pX;
}

- (void) setY:(double) pY
{
    y = pY;
}

- (void) setWithX:(double) pX Y:(double) pY
{
    x = pX;
    y = pY;
}

#pragma mark -
#pragma mark Functionality methods

- (void) addVector:(Vec2f*) pVector
{
    x = x + [pVector x];
    y = y + [pVector x];
}

- (void) substractVector:(Vec2f*) pVector
{
    x = x - [pVector x];
    y = y - [pVector x];
}

- (void) multiplyByScalar:(double) pScalar
{
    x = x * pScalar;
    y = y * pScalar;
}

- (double) scalarProductWith:(Vec2f *) pVec1
{
    return ([pVec1 x]*x + [pVec1 y]*y);
}

- (double) length
{
    return sqrtf(x*x + y*y);
}


- (void) normalize
{
    double lLength = [self length];

    x = x / lLength;
    y = y / lLength;
}


@end