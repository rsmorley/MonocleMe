//
//  MonocleEditorViewController.m
//  MonocleMe
//
//  Created by Scott on 11/9/15.
//  Copyright © 2015 Monoclebot LLC. All rights reserved.
//

#import "MonocleEditorViewController.h"
#import "NSString+FontAwesome.h"
#import "UIColor+Branding.h"

@interface MonocleEditorViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *monocleImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;
@property (weak, nonatomic) IBOutlet UIButton *mirrorButton;
@property (weak, nonatomic) IBOutlet UIButton *monocleButton;

@end

@implementation MonocleEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
   
    if (self.image) {
        [self.imageView setImage:self.image];
    }
}

- (void)setup {
    [self.monocleButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [self.monocleButton setTitle:[NSString fontAwesomeIconStringForEnum:FAneuter] forState:UIControlStateNormal];
    [self.monocleButton setTitleColor:[UIColor brandColorWhite] forState:UIControlStateNormal];
    [self.monocleButton.layer setBorderColor:[[UIColor brandColorWhite] CGColor]];
 
    [self.exportButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [self.exportButton setTitle:[NSString fontAwesomeIconStringForEnum:FAFloppyO] forState:UIControlStateNormal];
    [self.exportButton setTitleColor:[UIColor brandColorWhite] forState:UIControlStateNormal];
    [self.exportButton.layer setBorderColor:[[UIColor brandColorWhite] CGColor]];
    
    [self.mirrorButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [self.mirrorButton setTitle:[NSString fontAwesomeIconStringForEnum:FAArrowsH] forState:UIControlStateNormal];
    [self.mirrorButton setTitleColor:[UIColor brandColorWhite] forState:UIControlStateNormal];
    [self.mirrorButton.layer setBorderColor:[[UIColor brandColorWhite] CGColor]];
    
    [self.closeButton setTitle:[NSString fontAwesomeIconStringForEnum:FATimes] forState:UIControlStateNormal];
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - actions

- (IBAction)closeButtonTouchUpInside:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mirrorButtonTouchUpInside:(UIButton *)sender {
    UIImage *monocleImage = self.monocleImageView.image;
    self.monocleImageView.image = [UIImage imageWithCGImage:monocleImage.CGImage
                        scale:monocleImage.scale
                  orientation:UIImageOrientationUpMirrored];
}

- (IBAction)monocleButtonTouchUpInside:(UIButton *)sender {
    [self.monocleImageView setHidden:NO];
    [self.exportButton setHidden:NO];
    [self.mirrorButton setHidden:NO];
}


- (IBAction)exportButtonTouchUpInside:(UIButton *)sender {
    [self.imageView addSubview:self.monocleImageView];
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, FALSE, 0.0);
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
}

- (IBAction)monocleImagePinched:(UIPinchGestureRecognizer *)sender {
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;
}

- (IBAction)monocleImageRotated:(UIRotationGestureRecognizer *)sender {
    sender.view.transform = CGAffineTransformRotate(sender.view.transform, sender.rotation);
    sender.rotation = 0;
}

- (IBAction)monocleImageDragged:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    [sender.view setCenter:CGPointMake(
                 sender.view.center.x + point.x,
                 sender.view.center.y + point.y)
    ];
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
