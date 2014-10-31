#import <WebKit/WebKit.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import "ScribeEngine.h"

@interface ScribeWindow: NSWindow <NSWindowDelegate> {
  WebView *webView;
  ScribeEngine *scribeEngine;
  ScribeEngine *parentEngine;
  JSValueRefAndContextRef originalReference;
}

@property (nonatomic, retain) WebView *webView;
@property (nonatomic, retain) ScribeEngine *scribeEngine;
@property (nonatomic, retain) ScribeEngine *parentEngine;
@property (nonatomic, assign) JSValueRefAndContextRef originalReference;

- (id) init;
- (id) initWithFrame: (CGRect) frame;
- (void) buildWebView;
- (void) navigateToURL: (NSString *) url;
- (void) triggerEvent: (NSString *)event;
+ (id) lastInstance;

@end
