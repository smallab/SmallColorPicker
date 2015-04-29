//
//  USColorPickerView.h
//  USColorPicker
//
//  Created by Matthieu Savary on 26/07/13.
//  Copyright (c) 2013 User Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol USColorPickerViewDelegate <NSObject>

- (void)hideUI;
- (void)showUI;

@end

@interface USColorPickerView : UIView

@property (nonatomic, strong) id<USColorPickerViewDelegate> delegate;
@property (nonatomic, retain) UIColor *lastColor;
@property (nonatomic, assign) CGPoint lastPosition;
@property (nonatomic, strong) UIImageView *colorPickerPalette;
@property (nonatomic, strong) UIImageView *colorPickerCursor;

- (void)applyPositionAndColor;
- (void)applyPosition:(CGPoint)position andColor:(UIColor*)color;

@end
