#import "UnitTest.h"
#import "TestHelpers.h"
#import "ScribeWindow.h"

TEST_SUITE(LocalStorageTests)

TEST(LocalStorageIsPersisted)
  NSApplication *app = [NSApplication sharedApplication];

  ScribeWindow *win = [ScribeWindow new];
  WebScriptObject *script = [win.webView windowScriptObject];
  [script evaluateWebScript: @"localStorage.x = '1';"];
  [win release];
  win = nil;

  win = [ScribeWindow new];
  script = [win.webView windowScriptObject];
  id one = [script evaluateWebScript: @"localStorage.x"];

  [win release];
  win = nil;

  AssertObjEqual([one toNumber], [NSNumber numberWithInt: 1]);
END_TEST

END_TEST_SUITE