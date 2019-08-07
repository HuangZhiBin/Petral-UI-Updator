//
//  HzbViewController.m
//  Petral-UI-Updator
//
//  Created by huangzhibin on 08/07/2019.
//  Copyright (c) 2019 huangzhibin. All rights reserved.
//

#import "HzbViewController.h"
#import <Petral_UI_Updator/PetralHttpManager.h>

@interface HzbViewController ()

@end

@implementation HzbViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[PetralHttpManager sharedInstance] startServer:@"/Users/huangzhibin327/Desktop/Petral-UI-Updator/"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
