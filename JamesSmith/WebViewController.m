//
//  WebViewController.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "WebViewController.h"

// Models
#import "BingSearchResult.h"
#import "OvershareKit.h"

// Views
#import "NJKWebViewProgressView.h"

// Other
#import "PanInteractiveTransitionController.h"
#import "PushBackTransition.h"
#import "NJKWebViewProgress.h"

@interface WebViewController ()
<
UIWebViewDelegate,
NJKWebViewProgressDelegate
>
// Views
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, strong) NJKWebViewProgressView *progressView;
@property(nonatomic, strong) NJKWebViewProgress *progressProxy;
@end

@implementation WebViewController

#pragma mark - Lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.forwardButton.enabled = NO;
    
// Setup web view
    self.progressProxy = [NJKWebViewProgress new];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 17.5f, self.view.bounds.size.width, 2.5f)];
    self.progressView.progressBarView.backgroundColor = [UIColor colorWithRed:0.00f green:(122.0/255.0) blue:1.00f alpha:1.00f];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.searchResult.url];
    [self.webView loadRequest:request];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view addSubview:self.progressView];
}

#pragma mark - IBActions
- (IBAction)shareButtonPressed:(id)sender {
    OSKShareableContent *content = [OSKShareableContent contentFromURL:self.searchResult.url];
    [[OSKPresentationManager sharedInstance] presentActivitySheetForContent:content presentingViewController:self options:nil];
}

- (IBAction)backButtonPressed:(__unused id)sender {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)refreshButtonPressed:(id)sender {
    [self.webView reload];
}

#pragma mark - WebView Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView {
    self.refreshButton.enabled = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.refreshButton.enabled = YES;
    
    if ([self.webView canGoForward]) {
        self.forwardButton.enabled = YES;
    }
    else {
        self.forwardButton.enabled = NO;
    }
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error: %@,\nStatus Code:%ld", error, (long)error.code);
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
