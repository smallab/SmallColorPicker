//
//  USImageColorPicking.m
//  USColorPicker
//
//  Created by Matthieu Savary on 29/07/13.
//  Copyright (c) 2013 User Studio. All rights reserved.
//

#import "USImageColorPicking.h"

@implementation USImageColorPicking

+ (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(CGImageRef)imgRef
{
    UIColor* color = nil;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpha, Red, Green, Blue
    CGContextRef cgctx = [USImageColorPicking createARGBBitmapContextFromImage:imgRef];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(imgRef);
    size_t h = CGImageGetHeight(imgRef);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, imgRef);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

+ (UIColor*)getPixelColorAtLocation:(CGPoint)point withData:(unsigned char*)data andContext:(CGContextRef)cgctx andWidth:(size_t)w
{
    //offset locates the pixel in the data from x,y.
    //4 for 4 bytes of data per pixel, w is width of one row of data.
    int offset = 4*((w*round(point.y))+round(point.x));
    int alpha =  data[offset];
    int red = data[offset+1];
    int green = data[offset+2];
    int blue = data[offset+3];
    //		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
    return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
}

+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)imgRef
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(imgRef);
    size_t pixelsHigh = CGImageGetHeight(imgRef);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}




+ (UIColor*)colorWithHexString:(NSString*)hex
{
    // Remove # from hex
    NSString *hexWithoutX = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSString *cString = [[hexWithoutX stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (BOOL)color:(UIColor *)color1 isEqualToColor:(UIColor *)color2 withTolerance:(CGFloat)tolerance {
    
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return
    fabs(r1 - r2) <= tolerance &&
    fabs(g1 - g2) <= tolerance &&
    fabs(b1 - b2) <= tolerance &&
    fabs(a1 - a2) <= tolerance;
}

+ (CGPoint)getPositionForColor:(NSString *)colorhex inImage:(UIImage *)image
{
    CGPoint position;
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    
    UIColor *currentColor = [USImageColorPicking colorWithHexString:colorhex];
    
    BOOL breakable = NO;
    
    CGImageRef imgRef = image.CGImage;
    UIColor *itColor = nil;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpha, Red, Green, Blue
    CGContextRef cgctx = [USImageColorPicking createARGBBitmapContextFromImage:imgRef];
    //    if (cgctx == NULL) { break; /* error */ }
    
    size_t w = CGImageGetWidth(imgRef);
    size_t h = CGImageGetHeight(imgRef);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, imgRef);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        for(int i = 0; i < image.size.height; i= i+7)
        {
            // NSLog(@"%d", j);
            for(int j = 0; j < image.size.width; j++)
            {
                itColor = [USImageColorPicking getPixelColorAtLocation:CGPointMake(j, i) withData:data andContext:cgctx andWidth:w];
                if ([USImageColorPicking color:itColor isEqualToColor:currentColor withTolerance:0.05]) {
                    yPos = (CGFloat)i;
                    xPos = (CGFloat)j;
                    breakable = YES;
                    break;
                }
            }
            if (breakable) break;
        }
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    position = CGPointMake(xPos, yPos);
    
    return position;
}

@end
