# USColorPicker

 Looking for this in **Swift 2.0**? It's [there](https://github.com/smallab/SmallColorPickerSwift).

Here under is some sample code for the *View Controller* you wish to launch the **USColorPicker modal view** from:

![alt tag](https://smallab.co/sp-content/files/6/file554384294b7e1.png)

Please note that the USColorPicker classes are provided as used in apps *optimized for the iPhone 5* such as [Pixel is Data](https://pixelisdata.org). Some adaptation might (will) be necessary. User Studio can in no way be held responsible for their malfunction or misuse in your own project.

The code & its assets are distributed under the MIT license *(means it's free, and commercial use is OK ;)*. Enjoy and don't forget to mention US!

## ViewController.h

```objective-c
#import <UIKit/UIKit.h>
#import "USColorPickerController.h"

@interface ViewController : UIViewController <USColorPickerControllerDelegate> {
    USColorPickerController     *usColorPickerCtrl;
    UIColor                     *previousColorPickerColor;
    CGPoint                     previousColorPickerPosition;

    UIButton					*colorPickerPresentationBtn;
}

@end
```


## ViewController.m

```objective-c
#import "ViewController.h"

@interface ViewController ()

@end

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
```
