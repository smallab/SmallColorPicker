//
//  USColorPickerView.m
//  USColorPicker
//
//  Created by Matthieu Savary on 26/07/13.
//  Copyright (c) 2013 User Studio. All rights reserved.
//

#import "USColorPickerView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CoreAnimation.h>

#import "USImageColorPicking.h"

@implementation USColorPickerView

@synthesize lastColor;
@synthesize lastPosition;



#pragma mark - Handle the touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate hideUI];
    [self touch:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.delegate showUI];
    [self touch:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touch:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate showUI];
    [self touch:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}
- (void)touch:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.y >= CGImageGetHeight(self.colorPickerPalette.image.CGImage))
        point = CGPointMake(point.x, point.y-1);
	self.lastColor = [USImageColorPicking getPixelColorAtLocation:point inImage:self.colorPickerPalette.image.CGImage];
    self.lastPosition = point;
    [self applyPositionAndColor];
}



#pragma mark - Apply current or other values to view

- (void)applyPositionAndColor
{
    [self.colorPickerCursor setCenter:self.lastPosition];
    self.backgroundColor = self.lastColor;
}

- (void)applyPosition:(CGPoint)position andColor:(UIColor*)color
{
    self.lastPosition = position;
    [self.colorPickerCursor setCenter:position];
    self.lastColor = color;
    self.backgroundColor = color;
}

#pragma mark - Get position for color

- (void)findPositionForColor:(NSString *)colorhex
{
    self.lastPosition = [USImageColorPicking getPositionForColor:(NSString *)colorhex inImage:self.colorPickerPalette.image];
}

@end
