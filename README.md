# USColorPicker

## ViewController.h

```
@interface ViewController : UIViewController <USColorPickerControllerDelegate> {
    USColorPickerController     *usColorPickerCtrl;
    UIColor                     *previousColorPickerColor;
    CGPoint                     previousColorPickerPosition;

    UIButton					*colorPickerPresentationBtn;
}

@end
```


## ViewController.m

```
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Create the color choosing (modal) view
	usColorPickerCtrl = [[USColorPickerController alloc] initWithNibName:@"USColorPickerController" bundle:nil];
	usColorPickerCtrl.delegate = self;
	[usColorPickerCtrl view]; // preload

	// Button
    colorPickerPresentationBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 260, 30)];
    [colorPickerPresentationBtn setTitle:@"" forState:UIControlStateNormal];
    [colorPickerPresentationBtn setTintColor:usColorPickerCtrl.colorPicker.lastColor];
    [colorPickerPresentationBtn setBackgroundColor:usColorPickerCtrl.colorPicker.lastColor];
    [colorPickerPresentationBtn addTarget:self action:@selector(listen2ColorPickerPresentationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:colorPickerPresentationBtn];
}

- (void)listen2ColorPickerPresentationBtn:(id)sender
{
    [self presentViewController:chooseColorViewCtrl animated:YES completion:^{
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
```