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
    [self.monocleButton addTarget:self action:@selector(monocleButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
 
    //circle-thin
    //circle-o
    //dot-circle-o
    //neuter
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

- (void)monocleButtonTouchUpInside:(UIButton *)sender {
    [self.monocleImageView setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
