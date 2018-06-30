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
    
    self.label.hidden = YES;
    
    
    [self.view addSubview:rootView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotEthRate:) name:@"currentEthRate" object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getEthRate:(id)sender {
    self.button.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToJS" object:@{@"action":@"getCurrentEthRate"}];
    
}

-(void)gotEthRate:(NSNotification *)notification{
    NSDictionary *data = notification.object;
    NSNumber *rate = (NSNumber *)data[@"conversionRate"];
    self.label.text = [NSString stringWithFormat:@"ETH PRICE: $%@", rate];
    
    self.label.hidden = NO;
}



@end
