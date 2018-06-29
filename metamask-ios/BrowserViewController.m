//
//  FirstViewController.m
//  metamask-ios
//
//  Created by Bruno on 6/26/18.
//  Copyright © 2018 Bruno. All rights reserved.
//

#import "BrowserViewController.h"
#import <Webkit/WKWebViewConfiguration.h>
#import <Webkit/WKUserContentController.h>
#import <Webkit/WKUserScript.h>

@interface BrowserViewController ()
@property (strong, nonatomic) WKWebView *webview;
@property (weak, nonatomic) IBOutlet UIView *webviewWrapper;

@property (weak, nonatomic) IBOutlet UITextField *urlInput;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIView *navigationWrapper;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebview];
    self.progressView.hidden = YES;
    [self setupProgressBar];
    [self navigateTo:@"https://google.com"];
    
    [self.backButton setEnabled:NO];
    [self.forwardButton setEnabled:YES];
    [self.urlInput setDelegate:self];
    [self.urlInput addTarget:self.urlInput
                  action:@selector(resignFirstResponder)
        forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(void) setupWebview {
    
    
     
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    NSString *js = @"";
    //Web3.js
    NSString *web3Bundle = [[NSBundle mainBundle] pathForResource:@"web3" ofType:@"js"];
    NSError *error = nil;
    NSString *web3js = [[NSString alloc] initWithContentsOfFile:web3Bundle encoding:NSUTF8StringEncoding error:&error];
    if(error) { // If error object was instantiated, handle it.
        NSLog(@"ERROR while loading from file: %@", error);
    }

    js = [js stringByAppendingString: web3js];
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:script];
    config.userContentController = userContentController;
    

    self.webview = [[WKWebView alloc] initWithFrame:self.webviewWrapper.frame
                                     configuration:config];
    
    [self.webviewWrapper addSubview:self.webview];
    
    self.webview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* topConstraint=[NSLayoutConstraint constraintWithItem:self.webviewWrapper attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.webview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint* trailingConstraint=[NSLayoutConstraint constraintWithItem:self.webviewWrapper attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.webview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    NSLayoutConstraint* leadingConstraint=[NSLayoutConstraint constraintWithItem:self.webviewWrapper attribute:NSLayoutAttributeLeading   relatedBy:NSLayoutRelationEqual toItem:self.webview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    NSLayoutConstraint* height=[NSLayoutConstraint constraintWithItem:self.webviewWrapper attribute:NSLayoutAttributeHeight   relatedBy:NSLayoutRelationEqual toItem:self.webview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    [self.webviewWrapper addConstraints:@[topConstraint, trailingConstraint, leadingConstraint, height]];
}
-(void) setupProgressBar {
    //add progresbar to navigation bar
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.progressView.tintColor = [UIColor blueColor];
                                                
    [self.navigationWrapper addSubview: self.progressView];
                                                
    CGRect navigationBarBounds = self.navigationWrapper.bounds;
    self.progressView.frame = CGRectMake(0, navigationBarBounds.size.height - 2, navigationBarBounds.size.width, 2);
    
    // add observer for key path
    [self.webview addObserver:self forKeyPath:@"title" options: NSKeyValueObservingOptionNew context:nil];
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options: NSKeyValueObservingOptionNew context:nil];
    
    [self.webview addObserver:self forKeyPath:@"loading" options: NSKeyValueObservingOptionNew context:nil];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"title"]) {
        //self.title = (NSString *)change[@"new"];
    }
    
    if([keyPath isEqualToString:@"loading"]){
        NSLog(@"%@", change);

        BOOL now = [change[NSKeyValueChangeNewKey] boolValue];
        
        if(now){
            [self loadingStarted];
        }else{
            [self loadingFinished];
        }
        
    }
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSNumber *newProgress =(NSNumber *)change[@"new"];
        self.progressView.progress = newProgress.floatValue;
    }

    
}

- (void)loadingStarted {
    if(self.progressView.isHidden){
        self.progressView.hidden = NO;
    }
    self.urlInput.text = self.webview.URL.absoluteString;
    [self updateBackButtonState];
    [self updateForwardButtonState];
}

- (void)loadingFinished {
    if(!self.progressView.isHidden){
        self.progressView.hidden = YES;
    }
}

- (IBAction)onBackButtonTapped:(id)sender {
    [self.webview goBack];
}

- (IBAction)onForwardButtonTapped:(id)sender {
    [self.webview goForward];
}

-(void) updateBackButtonState {
    BOOL enabled = [self.webview canGoBack];
    [self.backButton setEnabled: enabled];
}

-(void) updateForwardButtonState {
    BOOL enabled = [self.webview canGoForward];
    [self.forwardButton setEnabled: enabled];
}

-(void) navigateTo:(NSString *)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webview loadRequest:request];
    self.urlInput.text = url;
    [self loadingStarted];
}

# pragma WKNavigationDelegate methods

- (void)webView:(WKWebView *)webView
didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self loadingFinished];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self loadingFinished];
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"commiting");
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"fail provisional");
}

# pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textViewShouldBeginEditing:");
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textViewDidBeginEditing:");
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textViewShouldEndEditing:");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textViewDidEndEditing:");
    [self navigateTo:textField.text];
}

- (void)textViewDidChange:(UITextField *)textField{
    NSLog(@"textViewDidChange:");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [self.webview removeObserver:self forKeyPath:@"title"];
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"loading"];
    
    //remove progress bar from navigation bar
    [self.progressView removeFromSuperview];
}

@end
