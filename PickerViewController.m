//
//  PickerViewController.m
//  MonocleMe
//
//  Created by Scott on 11/9/15.
//  Copyright © 2015 Monoclebot LLC. All rights reserved.
//

#import "PickerViewController.h"
#import "NSString+FontAwesome.h"
#import "UIColor+Branding.h"

@interface PickerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *monocleImageView;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;
@property (weak, nonatomic) IBOutlet UIButton *mirrorButton;
@property (weak, nonatomic) IBOutlet UIButton *monocleButton;

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

- (void)setup {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 40)];
    [cameraButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [cameraButton setTitle:[NSString fontAwesomeIconStringForEnum:FACameraRetro ] forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor brandColorOrageRed] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [picker.view addSubview:cameraButton];
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"image picker");
    }];
    
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
}

#pragma mark - image picker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = pickedImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"picker dismissed");
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - actions

- (void)cameraButtonTouchUpInside:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{
                NSLog(@"camera");
            }];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Camera Available" message:@"this device does not have a camera" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
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
