//
//  ViewController.m
//  WebViewOCInvokeDemo
//
//  Created by njim3 on 2019/3/15.
//  Copyright © 2019 cnbm. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface ViewController () <WKNavigationDelegate, WKUIDelegate,
WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView* webView;

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview: self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f));
    }];
    
    
    [self setViewAction];
}

- (void)dealloc{
    [self.webView.configuration.userContentController removeAllUserScripts];
}

#pragma mark - View Action
- (void)setViewAction {
    [self loadHtml];
}

- (void)loadHtml {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource: @"test"
                                                         ofType: @"html"];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL fileURLWithPath: htmlPath]];
    
    [self.webView loadRequest: request];
}

#pragma mark - Variables getter
- (WKWebView*)webView {
    if (!_webView) {
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc]
                                                 init];
        
        _webView = [[WKWebView alloc] initWithFrame: CGRectZero
                                      configuration: configuration];
        
        WKUserContentController* userCC = _webView.configuration.userContentController;
        
        [userCC addScriptMessageHandler: self
                                   name: @"jsInvokeOCMethod"];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString: @"jsInvokeOCMethod"]) {
        NSLog(@"MessageBody: %@", message.body);
        
        // async return value
        [self.webView evaluateJavaScript: @"response2JS('Hello return')"
           completionHandler:^(id response, NSError * error) {
               NSLog(@"response: %@, \nerror: %@", response, error);
           }];
    }
}

#pragma mark - WKUIDelegate delegate method
- (void)webView:(WKWebView *)webView
runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
    defaultText:(NSString *)defaultText
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    if (prompt) {
        if ([prompt isEqualToString: @"getCookie"]) {
            completionHandler(@"eba7392f-f754-4a56-9c22-aedf3ffb79d8");
        }
    }
}

@end
