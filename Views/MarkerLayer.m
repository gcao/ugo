//
//  MarkerLayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/21/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "MarkerLayer.h"

#define kStoneLineWidth 8

static NSString * const kMarkerTypeKey = @"MarkerType";
static NSString * const kMarkerOptionsKey = @"MarkerOptions";

@implementation MarkerLayer

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_allMarkers release];
    
    [super dealloc];
}

- (void) gridSizeChanged
{
    [self removeAllMarkers];
    [_allMarkers release];
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    _allMarkers = [[NSMutableArray alloc] initWithCapacity:boardSize * boardSize];
    for (int i = 0; i < boardSize * boardSize; i++) [_allMarkers addObject:[NSNull null]];
}

- (void) removeMarkerAtLocation:(CGPoint)boardLocation
{
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    NSUInteger idx = (boardLocation.x - 1) + ((boardLocation.y - 1) * boardSize);
    NSAssert4([_allMarkers count] > idx, @"Request to remove a marker at location (%dx%d) that is beyond the board size (%dx%d)", boardLocation.x, boardLocation.y, boardSize, boardSize);
    CALayer *markerLayer = [_allMarkers objectAtIndex:idx];
    if (markerLayer && (NSNull *)markerLayer != [NSNull null]) [markerLayer removeFromSuperlayer];
    [_allMarkers replaceObjectAtIndex:idx withObject:[NSNull null]];
}

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options
{    
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    CGFloat lineSep = self.frame.size.width / (boardSize - 1);
    CGFloat stoneSize = lineSep * .95;
    CALayer *markerLayer = [CALayer layer];
    
    NSUInteger idx = (boardLocation.x - 1) + ((boardLocation.y - 1) * boardSize);
    NSAssert4([_allMarkers count] > idx, @"Request to add a marker at location (%dx%d) that is beyond the board size (%dx%d)", boardLocation.x, boardLocation.y, boardSize, boardSize);    
    
    CALayer *existingLayer = [_allMarkers objectAtIndex:idx];
    if (existingLayer && (NSNull *)existingLayer != [NSNull null]) [existingLayer removeFromSuperlayer];
    [_allMarkers replaceObjectAtIndex:idx withObject:markerLayer];
     
    if ([[options objectForKey:kGoMarkerOptionTemporaryMarker] boolValue] == YES) {
        markerLayer.opacity = 0.5;
    }
    
    if (options) [markerLayer setValue:options forKey:kMarkerOptionsKey];
    [markerLayer setValue:[NSNumber numberWithInt:type] forKey:kMarkerTypeKey];
    
    CGPoint vpoint;
    vpoint.x = (boardLocation.x - 1) * lineSep;
    vpoint.y = (boardLocation.y - 1) * lineSep;
    markerLayer.frame = CGRectMake(vpoint.x - stoneSize/2.0, vpoint.y - stoneSize/2.0, stoneSize, stoneSize);
    markerLayer.delegate = self;
    [self addSublayer:markerLayer];
    [markerLayer setNeedsDisplay];
}

- (void) _drawStone:(GoMarkerType)stoneType inContext:(CGContextRef)context
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSetLineWidth(context, kStoneLineWidth);
    if (stoneType == kGoMarkerWhiteStone) {
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    } else {
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    }
    
    CGContextAddEllipseInRect(context, CGRectMake(rect.origin.x + (kStoneLineWidth/2), rect.origin.y + (kStoneLineWidth/2), rect.size.width - kStoneLineWidth, rect.size.height - kStoneLineWidth));
    CGContextStrokePath(context);
    CGContextFillEllipseInRect(context, rect);
    
    UIGraphicsPopContext(); 
}

- (void) _drawShape:(NSDictionary *)options inContext:(CGContextRef)context
{
    // TODO: implement _drawShape
}

- (void) _drawLabel:(NSDictionary *)options inContext:(CGContextRef)context
{
    // TODO: implement _drawLabel
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context;
{
    GoMarkerType type = [[layer valueForKey:kMarkerTypeKey] intValue];
    switch (type) {
        case kGoMarkerWhiteStone:
        case kGoMarkerBlackStone:
            [self _drawStone:type inContext:context];
            break;
        case kGoMarkerShape:
            [self _drawShape:[layer valueForKey:kMarkerOptionsKey] inContext:context];
            break;
        case kGoMarkerLabel:
            [self _drawLabel:[layer valueForKey:kMarkerOptionsKey] inContext:context];
            break;
    }    
}

- (void)removeAllMarkers
{
    for (CALayer *marker in _allMarkers) {
        if ((NSNull *)marker != [NSNull null]) [marker removeFromSuperlayer];
    }
}

@end
