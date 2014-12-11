//
//  DMAMainViewController_iPad.m
//  DMAKiosk
//
//  Created by Christopher Luu on 1/2/13.
//  Copyright (c) 2013 LearningTimes. All rights reserved.
//

#import "DMAMainViewController_iPad.h"

#import <AVFoundation/AVFoundation.h>

#if 0
#warning Staging server
static NSString *const DMAMainViewControlleriPadBaseURL = @"http://dma:devsonly@dma.wdslab.com/";
#else
static NSString *const DMAMainViewControlleriPadBaseURL = @"http://friends.dma.org/";
#endif

@implementation DMAMainViewController_iPad

- (void)viewDidLoad
{
	[super viewDidLoad];

	_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	[_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_webView setDelegate:self];
	[_webView setScalesPageToFit:YES];
	[_webView.scrollView setBounces:NO];
	[self.view addSubview:_webView];

	_barReaderView = [[ZBarReaderView alloc] init];
	[_barReaderView setBackgroundColor:[UIColor blackColor]];
	[_barReaderView setReaderDelegate:self];
	[_barReaderView.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
	[_barReaderView.scanner setSymbology:ZBAR_CODE39 config:ZBAR_CFG_ENABLE to:1];
	[_barReaderView setFrame:CGRectMake(130, 425, 508, 225)];
	[_barReaderView setHidden:YES];
	[_barReaderView setAllowsPinchZoom:NO];
	for (AVCaptureDevice *tmpCaptureDevice in [AVCaptureDevice devices])
	{
		if ([tmpCaptureDevice position] == AVCaptureDevicePositionFront)
		{
			[_barReaderView setDevice:tmpCaptureDevice];
			break;
		}
	}
	[self.view addSubview:_barReaderView];

	UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/scanner_guide.png"]];
	[tmpImageView setCenter:CGPointMake(_barReaderView.bounds.size.width / 2.0f, _barReaderView.bounds.size.height / 2.0f)];
	[_barReaderView addSubview:tmpImageView];

#if TARGET_IPHONE_SIMULATOR
	_cameraSimulator = [[ZBarCameraSimulator alloc] initWithViewController:self];
	[_cameraSimulator setReaderView:_barReaderView];
#endif

	_loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[_loadingIndicatorView setCenter:_webView.center];
	[_loadingIndicatorView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
	[_loadingIndicatorView setHidesWhenStopped:YES];
	[self.view addSubview:_loadingIndicatorView];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:DMAMainViewControlleriPadBaseURL]];
    [request addValue:uuid forHTTPHeaderField:@"x-device-uuid"];
    
	[_webView loadRequest:request];
}

#pragma mark -
#pragma mark DMAMainViewController_iPad private functions
- (void)setReaderViewHidden:(BOOL)inHidden
{
	[_barReaderView setHidden:inHidden];
	if (!inHidden)
		[_barReaderView start];
	else
		[_barReaderView stop];
}

#pragma mark -
#pragma mark ZBarReaderView delegate functions
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
	for (ZBarSymbol *tmpSymbol in symbols)
	{
		[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[DMAMainViewControlleriPadBaseURL stringByAppendingFormat:@"?authenticate=true&username=%@", [tmpSymbol data]]]]];
		[self setReaderViewHidden:YES];
		return;
	}
}

#pragma mark -
#pragma mark UIWebView delegate functions
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *tmpURLString = [[request URL] absoluteString];
	if ([tmpURLString isEqualToString:@"dma://showscanner"])
	{
		[self setReaderViewHidden:NO];
		return NO;
	}
	else if ([tmpURLString isEqualToString:@"dma://hidescanner"])
	{
		[self setReaderViewHidden:YES];
		return NO;
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[_loadingIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_loadingIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	DLog(@"%@", error);
	[_loadingIndicatorView stopAnimating];
}

@end
