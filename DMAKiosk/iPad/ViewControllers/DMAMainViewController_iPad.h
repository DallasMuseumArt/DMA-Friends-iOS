//
//  DMAMainViewController_iPad.h
//  DMAKiosk
//
//  Created by Christopher Luu on 1/2/13.
//  Copyright (c) 2013 LearningTimes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZBarReaderView.h"

#if TARGET_IPHONE_SIMULATOR
#import "ZBarCameraSimulator.h"
#endif

@interface DMAMainViewController_iPad : UIViewController <UIWebViewDelegate, ZBarReaderViewDelegate>
{
#if TARGET_IPHONE_SIMULATOR
	ZBarCameraSimulator *_cameraSimulator;
#endif

	UIWebView *_webView;
	UIActivityIndicatorView *_loadingIndicatorView;
	ZBarReaderView *_barReaderView;
}

@end
