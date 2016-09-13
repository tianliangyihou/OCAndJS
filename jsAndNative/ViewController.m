//
//  ViewController.m
//  jsAndNative
//
//  Created by llb on 16/9/13.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic,weak)UIWebView *webView;

@end

@implementation ViewController

- (UIWebView *)webView{
    if (!_webView) {
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self test2];

}

- (void)test2 {
    [self webView];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.bounces = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"main" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest:requst];
}



- (void)test1 {
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"main.js"];
    
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    JSContext * ctt = [[JSContext alloc] init];
    [ctt evaluateScript:testScript];
    NSNumber *m = @(10);
    NSNumber *n = @(456);
    
    JSValue *function = [ctt objectForKeyedSubscript:@"addtest"];
    JSValue *result = [function callWithArguments:@[n,m]];
    NSNumber *number = [result toNumber];
    NSLog(@"~%@~",number);

}

-  (void)webViewDidFinishLoad:(UIWebView *)webView {

    JSContext *jsctt = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSValue *function = [jsctt objectForKeyedSubscript:@"test"];
    [function callWithArguments:nil];
    jsctt[@"Wxpayment"] = ^(NSString *title,BOOL number) {
        NSLog(@"~~~%@~~~%d~~~",title,number);
    };
    jsctt[@"hello"] = ^() {
                NSArray *args = [JSContext currentArguments];
        for ( JSValue *value in args) {
            NSLog(@"!!%@!!",value);
        }
    };
 
}


@end
