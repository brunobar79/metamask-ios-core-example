//
//  ReactNativeViewController.h
//  metamask-ios
//
//  Created by Bruno on 6/26/18.
//  Copyright © 2018 Bruno. All rights reserved.
//

#import "ReactNativeViewController.h"
#import <React/RCTRootView.h>

@interface ReactNativeViewController ()

@end

@implementation ReactNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialize {
    // Do any additional setup after loading the view, typically from a nib.
    BOOL REACT_DEV_MODE = NO;
    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    
    
    if(REACT_DEV_MODE){
        jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
    }
    
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                moduleName: @"MetamaskApp"
                         initialProperties: @{}
                             launchOptions: nil];
    rootView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView setBackgroundColor:[UIColor clearColor]];
    rootView.hidden = YES;
    self.view = rootView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
