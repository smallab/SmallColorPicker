//
//  ViewController.m
//  USColorPickerProject
//
//  Created by USER STUDIO on 23/10/2015.
//  Copyright © 2015 User Studio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    colorLabel.text = @"Click on the following button:";
    [colorLabel setTextAlignment:NSTextAlignmentCenter];
    
    // Set current color
    UIColor *colorToDisplay = [UIColor colorWithRed:((float) 255.0f / 255.0f)
                                              green:((float) 0.0f / 255.0f)
                                               blue:((float) 82.0f / 255.0f)
                                              alpha:1.0f];
    previousColorPickerColor = colorToDisplay;
    
    // Create the color choosing (modal) view
    usColorPickerCtrl = [[USColorPickerController alloc] initWithNibName:@"USColorPickerController" bundle:nil];
    usColorPickerCtrl.delegate = self;
    usColorPickerCtrl.colorPicker.lastColor = colorToDisplay;
    [usColorPickerCtrl view]; // preload
    [usColorPickerCtrl.colorPicker findPositionForColor:@"#ff0052"];
    [usColorPickerCtrl.colorPicker applyPosition:usColorPickerCtrl.colorPicker.lastPosition andColor:colorToDisplay];
    previousColorPickerPosition = usColorPickerCtrl.colorPicker.lastPosition;

    // Button
    colorPickerPresentationBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/10*1, colorLabel.frame.size.height+30, self.view.frame.size.width/10*8, 30)];
    [colorPickerPresentationBtn setTitle:@"" forState:UIControlStateNormal];
    [colorPickerPresentationBtn setTintColor:usColorPickerCtrl.colorPicker.lastColor];
    [colorPickerPresentationBtn setBackgroundColor:usColorPickerCtrl.colorPicker.lastColor];
    [colorPickerPresentationBtn addTarget:self action:@selector(listen2ColorPickerPresentationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [colorPickerPresentationBtn setTintColor:previousColorPickerColor];
    [colorPickerPresentationBtn setBackgroundColor:previousColorPickerColor];
    
    [self.view addSubview:colorLabel];
    [self.view addSubview:colorPickerPresentationBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)listen2ColorPickerPresentationBtn:(id)sender
{
    [self presentViewController:usColorPickerCtrl animated:YES completion:^{
        NSLog(@"Choose color...");
    }];
}

#pragma mark - USColorPickerControllerDelegate methods

- (void)dismissColorPicker
{
    // user cancelled
    [self dismissViewControllerAnimated:YES completion:^{
        // change back to what we had before
        usColorPickerCtrl.colorPicker.lastPosition = previousColorPickerPosition;
        usColorPickerCtrl.colorPicker.lastColor = previousColorPickerColor;
        [usColorPickerCtrl.colorPicker applyPosition:previousColorPickerPosition andColor:previousColorPickerColor];
    }];
}

- (void)dismissColorPickerAndUseSelectedColor
{
    // saving new values
    previousColorPickerPosition = usColorPickerCtrl.colorPicker.lastPosition;
    previousColorPickerColor = usColorPickerCtrl.colorPicker.lastColor;
    [usColorPickerCtrl.colorPicker applyPositionAndColor];
    
    // applying chosen color to the button
    [colorPickerPresentationBtn setTintColor:usColorPickerCtrl.colorPicker.lastColor]; // set button's color
    [colorPickerPresentationBtn setBackgroundColor:usColorPickerCtrl.colorPicker.lastColor];
    [self dismissViewControllerAnimated:YES completion:^{ // close modal view
        NSLog(@"Using selected color picker color");
    }];
}

@end
