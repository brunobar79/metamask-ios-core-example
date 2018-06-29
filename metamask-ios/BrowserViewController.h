//
//  FirstViewController.h
//  metamask-ios
//
//  Created by Bruno on 6/26/18.
//  Copyright © 2018 Bruno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
#import <Webkit/WKNavigationDelegate.h>

@interface BrowserViewController : UIViewController<WKNavigationDelegate, UITextFieldDelegate>


@end

