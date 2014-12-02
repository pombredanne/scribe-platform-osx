#import <WebKit/WebKit.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import "ScribeEngine.h"

@interface ScribeWindow: NSWindow <NSWindowDelegate> {
  NSInteger parentWindowIndex;
}

@property (nonatomic, retain) WebView *webView;
@property (nonatomic, retain) ScribeEngine *scribeEngine;
@property (nonatomic, retain) ScribeEngine *parentEngine;

- (id) init;
- (id) initWithFrame: (NSRect) frame;
- (void) buildWebView;
- (void) navigateToURL: (NSString *) url;
- (void) triggerEvent: (NSString *)event;
- (BOOL) confirm: (NSString *) msg;
+ (id) lastInstance;

@end
