# USColorPicker

*** .h

@interface ViewController : UIViewController <USColorPickerControllerDelegate> {
    USColorPickerController     *usColorPickerCtrl;
    UIColor                     *previousColorPickerColor;
    CGPoint                     previousColorPickerPosition;

    UIButton					*colorPickerPresentationBtn;
}

@end


*** .m

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Create the color choosing (modal) view
	usColorPickerCtrl = [[USColorPickerController alloc] initWithNibName:@"USColorPickerController" bundle:nil];
	usColorPickerCtrl.delegate = self;
	[usColorPickerCtrl view]; // preload

	// Button
    colorPickerPresentationBtn = [[UIButton alloc] initWithFrame:CGRectMake(m, 782, w - m*2, 30)]; //CGRectMake(30, 782, 260, 30)
    [colorPickerPresentationBtn setTitle:@"" forState:UIControlStateNormal];
    [colorPickerPresentationBtn setTintColor:usColorPickerCtrl.colorPicker.lastColor];
    [colorPickerPresentationBtn setBackgroundColor:usColorPickerCtrl.colorPicker.lastColor];
    [colorPickerPresentationBtn addTarget:self action:@selector(listen2ColorBtn:) forControlEvents:UIControlEventTouchUpInside];
    [paramsView addSubview:colorPickerPresentationBtn];
}

- (void)listen2ColorBtn:(id)sender
{
    [self presentViewController:chooseColorViewCtrl animated:YES completion:^{
        NSLog(@"Choose color...");
    }];
    [self unselectPresets];
}

#pragma mark - USColorPickerControllerDelegate methods

- (void)dismissColorPicker
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Just closing color picker");
        usColorPickerCtrl.colorPicker.lastPosition = previousColorPickerPosition;
        usColorPickerCtrl.colorPicker.lastColor = previousColorPickerColor;
        [usColorPickerCtrl.colorPicker applyPosition:previousColorPickerPosition andColor:previousColorPickerColor];
        [self resizeSettingsBackToNormal];
    }];
}

- (void)dismissColorPickerAndUseSelectedColor
{
    [self.delegate setBkgdColor:usColorPickerCtrl.colorPicker.lastColor]; // apply
    previousColorPickerPosition = usColorPickerCtrl.colorPicker.lastPosition;
    previousColorPickerColor = usColorPickerCtrl.colorPicker.lastColor;
    [usColorPickerCtrl.colorPicker applyPositionAndColor];
    [self unselectPresets]; // this param has changed so we should unselect potentially selected presets
    [colorPickerPresentationBtn setTintColor:usColorPickerCtrl.colorPicker.lastColor]; // set button's color
    [colorPickerPresentationBtn setBackgroundColor:usColorPickerCtrl.colorPicker.lastColor];
    [self dismissViewControllerAnimated:YES completion:^{ // close modal view
        NSLog(@"Using selected color picker color");
        [self resizeSettingsBackToNormal];
    }];
}

@end