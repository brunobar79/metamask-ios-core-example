//
//  WalletViewController.m
//  metamask-ios
//
//  Created by Bruno on 6/26/18.
//  Copyright © 2018 Bruno. All rights reserved.
//

#import "WalletViewController.h"
#import "ReactNativeViewController.h"

@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.hidden = YES;
    
    ReactNativeViewController *js = [[ReactNativeViewController alloc] init];
    [js initialize];
    
    [self addChildViewController:js];
    
    //Listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotEthRate:) name:@"currentEthRate" object:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Actions

- (IBAction)getEthRate:(id)sender {
    self.button.hidden = YES;
    self.label.hidden = NO;
    self.label.text = @"loading...";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToJS" object:@{@"action":@"getCurrentEthRate"}];
}

-(void)gotEthRate:(NSNotification *)notification{
    NSDictionary *data = notification.object;
    NSNumber *rate = (NSNumber *)data[@"conversionRate"];
    self.label.text = [NSString stringWithFormat:@"ETH PRICE: $%@", rate];
}



@end
