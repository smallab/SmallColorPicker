//
//  USColorPickerController.m
//  USColorPicker
//
//  Created by Matthieu Savary on 26/07/13.
//  Copyright (c) 2013 User Studio. All rights reserved.
//

#import "USColorPickerController.h"

@interface USColorPickerController ()

@end

@implementation USColorPickerController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // init values
    unsigned int h = [[UIScreen mainScreen] bounds].size.height; // self.view.frame.size.height;
    unsigned int w = [[UIScreen mainScreen] bounds].size.width; // self.view.frame.size.width; //320;
    unsigned int m = (int) (0.06875 * w); // = 22;
    if (h > 568)
        h = 568;
    
    // self view
    self.view.frame = CGRectMake(0, 0, w, h);

    // creating the color picker (UIView)
    self.colorPicker = [[ColorPickerView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.colorPicker];
    [self.view bringSubviewToFront:self.colorPicker];

    // self is delegate of color picker
    self.colorPicker.delegate = self;
    
    // colors
    UIColor *c = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.colorPicker.lastColor = c;
    self.colorPicker.lastPosition = CGPointMake(160, 0);
    
    // create palette img view
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 1.0); // force scale of 1
    [[UIImage imageNamed:@"uscolorpicker-palette"] drawInRect:CGRectMake(0.0, 0.0, w, h)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    paletteImgView = [[UIImageView alloc] initWithImage:img];
    paletteImgView.frame = self.view.frame;
    paletteImgView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:paletteImgView];
    [self.view sendSubviewToBack:paletteImgView];
    
    // set color picker's palette ref + frame
    self.colorPicker.colorPickerPalette = paletteImgView;
    self.colorPicker.frame = self.view.frame;
    
    // create cursor and add as subview of colorPicker
    self.colorPicker.colorPickerCursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uscolorpicker-cursor"]];
    [self.colorPicker addSubview:self.colorPicker.colorPickerCursor];
    [self.colorPicker bringSubviewToFront:self.colorPicker.colorPickerCursor];

    // apply values
    [self.colorPicker applyPositionAndColor];
    
    // btns view
    btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - m*3, w, m*3)];
    btnsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnsView];
    [self.view bringSubviewToFront:btnsView];
    
    // Adds a shadow to btns view
    CALayer *layer1 = btnsView.layer;
    layer1.shadowOffset = CGSizeMake(1, 1);
    layer1.shadowColor = [[UIColor blackColor] CGColor];
    layer1.shadowRadius = 22;
    layer1.shadowOpacity = 0.33334;
    layer1.shadowPath = [[UIBezierPath bezierPathWithRect:layer1.bounds] CGPath];
    
    // set select button action & props
    selectChosenColorBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectChosenColorBtn.frame = CGRectMake(w*0.5 - m*1.5, 0, m*3, m*3);
    [selectChosenColorBtn addTarget:self.delegate action:@selector(dismissColorPickerAndUseSelectedColor) forControlEvents:UIControlEventTouchUpInside];
    [selectChosenColorBtn setBackgroundColor:[UIColor clearColor]];
    [selectChosenColorBtn setTitle:@"✔︎" forState:UIControlStateNormal];
    selectChosenColorBtn.titleLabel.font = [UIFont fontWithName:@"userstudio" size:64];
    [selectChosenColorBtn setTitleColor:[UIColor colorWithWhite:0.2392 alpha:1.0] forState:UIControlStateNormal];
    [selectChosenColorBtn setTitleColor:[UIColor colorWithWhite:0.6667 alpha:1.0] forState:UIControlStateHighlighted];
    [btnsView addSubview:selectChosenColorBtn];
    
    // set cancel button action & props
    cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(0, 0, m*3, m*3);
    [cancelBtn addTarget:self.delegate action:@selector(dismissColorPicker) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [cancelBtn setTitle:@"✘" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"userstudio" size:42];
    [cancelBtn setTitleColor:[UIColor colorWithWhite:0.2392 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithWhite:0.6667 alpha:1.0] forState:UIControlStateHighlighted];
    [btnsView addSubview:cancelBtn];
    
    // hiding status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    // cursor init
    [self.colorPicker applyPositionAndColor];

    // start with showing the UI
    [self showUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - USColorPickerImageViewDelegate methods

- (void)hideUI
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self->btnsView.frame = CGRectMake(0, self.view.frame.size.height, self->btnsView.frame.size.width, self->btnsView.frame.size.height);
                     }
                     completion:^(BOOL finished){
//                         [self.btnsView setHidden:YES];
                     }];
}

- (void)showUI
{
//    [self.btnsView setHidden:NO];
    [UIView animateWithDuration:0.25 delay:0.15 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self->btnsView.frame = CGRectMake(0, self.view.frame.size.height - self->btnsView.frame.size.height, self->btnsView.frame.size.width, self->btnsView.frame.size.height);
                     }
                     completion:^(BOOL finished){

                     }];
}

@end
