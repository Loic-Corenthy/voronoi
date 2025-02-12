// Basic imports
#import <Foundation/Foundation.h>

// Local imports
#import "IdxPt2f.h"

@interface SetOfPt2f : NSObject
{
    NSMutableArray* mSetOfPts;
}

#pragma mark -
#pragma mark Properties

#ifdef DEBUG
    @property (readwrite,retain) NSString* name;
#endif

#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;

/// Get the point at a specific index
- (IdxPt2f*) ptAtIndex:(NSUInteger)pIndex;

/// Change the value of a point at a specific index
- (void) setPtAtIndex:(NSUInteger)pIndex WithX:(double)pX WithY:(double)pY;

/// Get the index of a specific point, return NSNotFound if the point is not in the set
- (NSUInteger) indexFromPt:(IdxPt2f*)pPt;

/// Add a point at the end of the set
- (void) addPt:(IdxPt2f*)pPt andUpdateIndex:(BOOL)pValue;

/// Remove the last point of the set
- (void) removeLastPt;

/// Remove a point at a specific index
- (void) removePtAtIndex:(NSUInteger)pIndex andUpdateIndex:(BOOL)pValue;

/// Remove all the points of the set
- (void) removeAllPts;

/// Return the number of points in the set
- (NSUInteger) nbOfPts;

#pragma mark -
#pragma mark Functionality methods

/// Shake the points by moving them by a random vector of lenght pRange
- (void) shakeWithinRange:(double)pValue;

#pragma mark -
#pragma mark Debug methods

/// DEBUG: Display the value of the points of the set in the output window
- (void) displayPts;

/// DEBUG: Display the retain value of the point in the output window
- (void) displayRetainOfPts;

@end

