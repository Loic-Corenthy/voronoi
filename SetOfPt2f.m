#import "SetOfPt2f.h"

@implementation SetOfPt2f

#pragma mark -
#pragma mark Properties

#ifdef DEBUG
    @synthesize name;
#endif

#pragma mark -
#pragma mark Basic methods

- (id) init
{
    self = [super init];
    if (self) {
        mSetOfPts = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void) dealloc
{

#ifdef DEBUG
    NSLog(@"retain on %@ when delete: %lu",self.name, mSetOfPts.retainCount);
    [name release];
#endif

    [mSetOfPts release];
    [super dealloc];
}

- (IdxPt2f*) ptAtIndex:(NSUInteger) pIndex
{
    return [mSetOfPts objectAtIndex:pIndex];
}

- (void) setPtAtIndex:(NSUInteger) pIndex WithX:(double) pX WithY:(double) pY
{
    NSAssert(pIndex < [mSetOfPts count], @"Index out of range");

    [[mSetOfPts objectAtIndex:pIndex] setWithX:pX Y:pY];
}

- (NSUInteger) indexFromPt:(IdxPt2f*) pPt
{
    NSUInteger lIndex = [mSetOfPts indexOfObject:pPt];

    if ([[mSetOfPts objectAtIndex:lIndex] x] == [pPt x] && [[mSetOfPts objectAtIndex:lIndex] y] == [pPt y]) {
        return lIndex;
    } else {
        return NSNotFound;
    }
}

- (void) addPt:(IdxPt2f *)pPt andUpdateIndex:(BOOL)pValue
{
    [mSetOfPts addObject:pPt];
    if (pValue) {
        NSUInteger lNumberOfPoints = [mSetOfPts count];
        [[mSetOfPts objectAtIndex:(lNumberOfPoints-1)] setIdx:(lNumberOfPoints-1)];
    }

}

- (void) removeLastPt
{
    [mSetOfPts removeLastObject];
}

- (void) removePtAtIndex:(NSUInteger)pIndex andUpdateIndex:(BOOL)pValue
{
    [mSetOfPts removeObjectAtIndex:pIndex];
    if (pValue) {
        // WARNING !!! This works (faster) only if the same points is not added twice or more in the set. Otherwise, must reset all the indices of all the points in the set each time!!
        for (NSUInteger i = pIndex; i < [mSetOfPts count]; i++) {
            [[mSetOfPts objectAtIndex:i] setIdx:i];
        }
    }
}

- (void) removeAllPts
{
    [mSetOfPts removeAllObjects];
}

- (NSUInteger) nbOfPts
{
    return [mSetOfPts count];
}

#pragma mark -
#pragma mark Functionality methods

- (void) shakeWithinRange:(double) pValue
{
    // Initialize variables to be used in the for loop
    IdxPt2f* lTmpPt = nil;
    Vec2f* lTmpVec = [[Vec2f alloc] init];

    // Translate all the points in the set of point from a random value between 0 and pValue
    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        u_int32_t lRandomNumberX = arc4random();
        u_int32_t lRandomNumberY = arc4random();

        [lTmpVec setWithX:(((lRandomNumberX/(double)UINT32_MAX)-0.5)*2*pValue) Y:(((lRandomNumberY/(double)UINT32_MAX)-0.5)*2*pValue)];

        lTmpPt = [mSetOfPts objectAtIndex:i];
        [lTmpPt translateWithVector:lTmpVec];
    }

    [lTmpVec release];

}

#pragma mark -
#pragma mark Debug methods

- (void) displayPts
{
    NSLog(@"\n Set with %lu pts: \n", [mSetOfPts count]);
    for (NSUInteger i = 0; i< [mSetOfPts count]; i++) {
        NSLog(@"x: %f - y: %f  - Idx:%lu \n",[[mSetOfPts objectAtIndex:i] x],[[mSetOfPts objectAtIndex:i] y], [[mSetOfPts objectAtIndex:i] idx]);
    }
}

-(void) displayRetainOfPts
{
    NSLog(@"\n Retain number of the points in the set: \n");

    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        NSLog(@"x: %f - y: %f - retain: %lu \n",[[mSetOfPts objectAtIndex:i] x],[[mSetOfPts objectAtIndex:i] y], [[mSetOfPts objectAtIndex:i] retainCount]);
    }
}

@end



