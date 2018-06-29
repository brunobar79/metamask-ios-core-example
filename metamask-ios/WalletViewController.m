//
//  SecondViewController.m
//  metamask-ios
//
//  Created by Bruno on 6/26/18.
//  Copyright © 2018 Bruno. All rights reserved.
//

#import "WalletViewController.h"
#import <React/RCTRootView.h>

@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.hidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
    
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                moduleName: @"MetamaskApp"
                         initialProperties: @{}
                             launchOptions: nil];
    rootView.hidden = YES;
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
