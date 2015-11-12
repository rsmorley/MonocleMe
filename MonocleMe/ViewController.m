//
//  ViewController.m
//  MonocleMe
//
//  Created by Scott on 11/7/15.
//  Copyright © 2015 Monoclebot LLC. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FontAwesome.h"
#import "UIColor+Branding.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self.cameraButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [self.cameraButton setTitle:[NSString fontAwesomeIconStringForEnum:FACameraRetro ] forState:UIControlStateNormal];
    [self.cameraButton.layer setBorderColor:[[UIColor brandColorWhite] CGColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
