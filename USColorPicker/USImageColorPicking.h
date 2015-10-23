//
//  USImageColorPicking.h
//  USColorPicker
//
//  Created by Matthieu Savary on 29/07/13.
//  Copyright (c) 2013 User Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface USImageColorPicking : NSObject

+ (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(CGImageRef)imgRef;
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)imgRef;
+ (CGPoint)getPositionForColor:(NSString *)colorhex inImage:(UIImage *)image;
+ (BOOL)color:(UIColor *)color1 isEqualToColor:(UIColor *)color2 withTolerance:(CGFloat)tolerance;

@end