//
//  BoardLayer.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface BoardLayer : CALayer {
	CALayer*            _gridLayer;
    CALayer*            _stoneLayer;
    CALayer*            _tempStoneLayer;
    NSMutableArray*     _allStones;
	
	NSUInteger	_gridSize;
	CGFloat		_gridInnerBorder;
    CGFloat     _lineSep;
    
    BOOL        _whiteTurn;
}

@property (nonatomic, retain) CALayer* gridLayer;
@property (nonatomic, retain) CALayer* stoneLayer;

// returns a point in Go board coordinates (1,1) to (boardSize,boardSize) for a given UIView coordinate
- (CGPoint) boardPointForUIPoint:(CGPoint)point;

- (void) placeTemporaryStone:(CGPoint)boardLocation;
- (void) placeStone:(CGPoint)boardLocation;

- (void) drawGridOfSize: (NSInteger)size;

@end
