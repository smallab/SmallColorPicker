//
//  ViewController.h
//  USColorPickerProject
//
//  Created by USER STUDIO on 23/10/2015.
//  Copyright © 2015 User Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USColorPickerController.h"

@interface ViewController : UIViewController <USColorPickerControllerDelegate> {
    USColorPickerController     *usColorPickerCtrl;
    UIColor                     *previousColorPickerColor;
    CGPoint                     previousColorPickerPosition;
    
    UIButton                    *colorPickerPresentationBtn;
}


@end

