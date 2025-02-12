#import "Pt2f.h"

@implementation Pt2f

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

- (double) valueAtIndex:(NSInteger)pIndex
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

- (void) setX:(double)pX
{
    x = pX;
}

- (void) setY:(double)pY
{
    y = pY;
}

- (void) setWithX:(double)pX Y:(double)pY
{
    x = pX;
    y = pY;
}

- (void) setValueAtIndex:(NSInteger) pIndex Value:(double)pValue
{
    if (pIndex == 0) {
        x = pValue;
    } else if(pIndex == 1) {
        y = pValue;
    }
}

- (BOOL) isEqual:(Pt2f*) pPt
{
    if (x == [pPt x] && y == [pPt y]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark Functionality methods

- (void) translateWithVector:(Vec2f*) pVect
{
    x = x + [pVect x];
    y = y + [pVect y];
}



@end
