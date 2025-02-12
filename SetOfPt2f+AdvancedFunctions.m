#import "SetOfPt2f+AdvancedFunctions.h"
#import "SetOfPt2f+BasicFunctions.h"

@implementation SetOfPt2f (SetOfPt2f_AdvancedFunctions)

#pragma mark -
#pragma mark Advanced geometric methods

- (SetOfPt2f*) convexHull
{
    // Create a set of point which will containt the convex hull
    SetOfPt2f* lConvexHull = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lConvexHull setName:@"convex hull"] ;
     NSLog(@"init %@",lConvexHull.name);
#endif

    // Sort angularly the set from the bottom point
    SetOfPt2f* lSortedAngularly = [[self sortAngularlyFromBottom] retain];

    // First point of the Convex hull is the lowest point
    [lConvexHull addPt:[lSortedAngularly ptAtIndex:0] andUpdateIndex:NO];

    // Second point of the convex hull is the second point on the list because they are sorted angularly
    [lConvexHull addPt:[lSortedAngularly ptAtIndex:1] andUpdateIndex:NO];

    // Variables for the while loop
    int lOrientation = 42;
    int i = 0;
    int j = i+1;
    int k = i+2;

    BOOL lLoop = YES;
        while (lLoop) {
        lOrientation = [lSortedAngularly orientationOfPtA:i PtB:j andPtC:k];
        if (lOrientation == 1) {
            // Check if the point as already been added
            NSUInteger lIndexPtToCheck = [[lSortedAngularly ptAtIndex:k] idx];

            BOOL lAlreadyIn = NO;
            for (NSUInteger lIt = 0; lIt < [lConvexHull nbOfPts]; lIt++) {
                if ([[lConvexHull ptAtIndex:lIt] idx] == lIndexPtToCheck) {
                    lAlreadyIn = YES;
                }
            }
            // if not, add it
            if (!lAlreadyIn) {
                [lConvexHull addPt:[lSortedAngularly ptAtIndex:k] andUpdateIndex:NO];
            }

            i++;
            j++;
            k++;

        } else {
            NSUInteger lIdxOfPointToDelete = [[lSortedAngularly ptAtIndex:j] idx];
            [lSortedAngularly removePtAtIndex:j andUpdateIndex:NO];

            // Take out false positive points in the convex hull
            for (NSUInteger lIt = 0; lIt < [lConvexHull nbOfPts]; lIt++) {
                if([[lConvexHull ptAtIndex:lIt] idx] == lIdxOfPointToDelete) {
                    [lConvexHull removePtAtIndex:lIt andUpdateIndex:NO];
                }
            }

            i--;
            j--;
            k--;

            // Check if we are not going beyond the table
            if (i<0) {
                i++;
                j++;
                k++;
            }

        }

        //Last point case
        NSUInteger lTmpSize = [lSortedAngularly nbOfPts];
        if (lTmpSize == (unsigned long)k) {
            k = 0;
        }
        if (k == -1) {
            k = (int)lTmpSize;
        }
        if (k == 1) {
            lLoop = NO;
        }
    }

    [lSortedAngularly removeAllPts];
    [lSortedAngularly release];

    return lConvexHull;
}

- (SetOfPt2f*) polygonizeMono
{
    // divide the set of points in the up and down part
    SetOfPt2f* lUp = [[SetOfPt2f alloc] init];
    SetOfPt2f* lDown = [[SetOfPt2f alloc] init];

    [self divideSetInUp:lUp andDown:lDown];

    SetOfPt2f* lSortedUp = nil;
    SetOfPt2f* lSortedDown = nil;

    // sort them from left to right
    if ([lUp nbOfPts] > 0) {
        lSortedUp = [[lUp sortLeftToRight] retain];
    }

    if ([lDown nbOfPts] > 0) {
        lSortedDown = [[lDown sortLeftToRight] retain];
    }



    // Add first the down points them the up points to the polygon
    SetOfPt2f* lSet = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lUp setName:@"up in polygonizemono"];
    [lDown setName:@"down in polygonizemono"];
    [lSet setName:@"polygon mono"];
    NSLog(@"init %@",lUp.name);
    NSLog(@"init %@",lDown.name);
    NSLog(@"init %@",lSet.name);
#endif

    for (NSUInteger i = 0; i < [lSortedDown nbOfPts]; i++) {
        [lSet addPt:[mSetOfPts objectAtIndex:[[lSortedDown ptAtIndex:i] idx]]andUpdateIndex:NO];
    }

    for (NSUInteger i = ([lSortedUp nbOfPts]-1); i > 0; i--) {
        [lSet addPt:[mSetOfPts objectAtIndex:[[lSortedUp ptAtIndex:i] idx]] andUpdateIndex:NO];
    }

    // Add the leftmost point to close the polygon
    [lSet addPt:[mSetOfPts objectAtIndex:[[lSortedUp ptAtIndex:0] idx]] andUpdateIndex:NO];

    // Free memory
    if ([lUp nbOfPts] > 0) {
         [lSortedUp release];// No need to remove all points because we didn't allocated memory for them -> just a reading of the new order (the release are already done inside sortLeftToRight)
    }

    if ([lDown nbOfPts] > 0) {
        [lSortedDown release];// No need to remove all points because we didn't allocated memory for them -> just a reading of the new order (the release are already done inside sortLeftToRight)
    }

    [lUp removeAllPts]; // Remove all these points because we have allocated the memory for them -> the add method will retain each one
    [lUp release];
    [lDown removeAllPts]; // Remove all these points because we have allocated the memory for them -> the add method will retain each one
    [lDown release];

    return lSet;
}

- (SetOfPt2f*) triangularizeAngular
{
    // Create a set of point which will containt all the points to trace all the segments of the triangulation
    SetOfPt2f* lTriangulation = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lTriangulation setName:@"angular triangulation"];
    NSLog(@"init %@",lTriangulation.name);
#endif

    // Create a set of point which will containt the convex hull
    // Sort angularly the set from the bottom point
    SetOfPt2f* lSortedAngularly = [[self sortAngularlyFromBottom] retain];

    // Put all the segment linked to the bottom point
    for (NSUInteger lIt = 1; lIt < [lSortedAngularly nbOfPts]; lIt++) {
        [lTriangulation addPt:[lSortedAngularly ptAtIndex:0] andUpdateIndex:NO];
        [lTriangulation addPt:[lSortedAngularly ptAtIndex:lIt] andUpdateIndex:NO];
    }

    // Variables for the while loop
    int lOrientation = 42;
    int i = 0;
    int j = i+1;
    int k = i+2;

    BOOL lLoop = YES;
    while (lLoop) {
        lOrientation = [lSortedAngularly orientationOfPtA:i PtB:j andPtC:k];
        if (lOrientation == 1) {
            [lTriangulation addPt:[lSortedAngularly ptAtIndex:j] andUpdateIndex:NO];
            [lTriangulation addPt:[lSortedAngularly ptAtIndex:k] andUpdateIndex:NO];

            i++;
            j++;
            k++;

        } else {
            [lTriangulation addPt:[lSortedAngularly ptAtIndex:j] andUpdateIndex:NO];
            [lTriangulation addPt:[lSortedAngularly ptAtIndex:k] andUpdateIndex:NO];

            [lSortedAngularly removePtAtIndex:j andUpdateIndex:NO];


            i--;
            j--;
            k--;

            // Check if we are not going beyond the table
            if (i<0) {
                i++;
                j++;
                k++;
            }

        }

        NSUInteger lTmpSize = [lSortedAngularly nbOfPts];
        if (lTmpSize == (unsigned long)k) {
            k = 0;
        }
        if (k == -1) {
            k = (int)lTmpSize;
        }
        if (k == 1) {
            lLoop = NO;
        }

    }

    [lSortedAngularly removeAllPts];
    [lSortedAngularly release];

    return lTriangulation;
}


@end







































