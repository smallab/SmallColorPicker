//
//  USImageColorPicking.h
//  USColorPicker
//
//  Created by Matthieu Savary on 29/07/13.
//  Copyright (c) 2013 User Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USImageColorPicking : NSObject

+ (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(CGImageRef)imgRef;
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)imgRef;

@end
