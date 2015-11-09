//
//  ViewController.m
//  MonocleMe
//
//  Created by Scott on 11/7/15.
//  Copyright © 2015 Monoclebot LLC. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FontAwesome.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100.f, 100.f, 100.f, 100.f)];
//    [label setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
//    [label setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-github"]];
//    [self.view addSubview:label];
    [self.cameraButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:40]];
    [self.cameraButton setTitle:[NSString fontAwesomeIconStringForEnum:FACameraRetro ] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
