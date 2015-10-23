//
//  USColorPickerController.h
//  USColorPicker
//
//  Created by Matthieu Savary on 26/07/13.
//  Copyright (c) 2013 User Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USColorPickerView.h"

@protocol USColorPickerControllerDelegate <NSObject>
- (void)dismissColorPicker;
- (void)dismissColorPickerAndUseSelectedColor;
@end

@interface USColorPickerController : UIViewController<USColorPickerViewDelegate> {
    UIImageView     *paletteImgView;
    UIView          *btnsView;
    UIButton        *selectChosenColorBtn;
    UIButton        *cancelBtn;
}

@property (weak, nonatomic) id<USColorPickerControllerDelegate> delegate;
@property (strong, nonatomic) USColorPickerView *colorPicker;

@end
