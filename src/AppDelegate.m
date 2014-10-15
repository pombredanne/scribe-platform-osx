#import "AppDelegate.h"

@implementation AppDelegate

@synthesize infoPlist, mainContext;

- (void) applicationDidFinishLaunching: (NSNotification *) n {
  @try {
    [self buildJSContext];
    [self readInfoPlist];
    [self loadMainJS];
  } @catch (NSException *e) {
    NSLog(@"Error occurred during initialization: %@", e);
    exit(1);
  }
}

// populates the {mainContext} ivar with a valid JS runtime context
- (void) buildJSContext {
  JSVirtualMachine *vm = [[JSVirtualMachine new] autorelease];
  self.mainContext = [[[JSContext alloc] initWithVirtualMachine: vm] autorelease];
}

// Attempts to populate the {infoPlist} ivar with the dictionary
// in the Info.plist contained in either the bundle or the current
// working directory.
//
// Raises an NSException when the plist cannot be found or parsed.
- (void) readInfoPlist {
  BOOL isDir;
  NSString *plistPath = [self plistPath];
  NSFileManager *fileManager = [NSFileManager defaultManager];

  if ([fileManager fileExistsAtPath: plistPath isDirectory: &isDir]
       && !isDir) {

    self.infoPlist = [NSDictionary dictionaryWithContentsOfFile: plistPath];

  } else {
    [NSException raise: @"Missing Info.plist" format:
      @"Info.plist file at %@ could not be found.", plistPath, nil
    ];
  }

  if (!self.infoPlist) {
    [NSException raise: @"Invalid Info.plist" format:
      @"Info.plist file at %@ could not be parsed.", plistPath, nil
    ];
  }
}

// Executes the main.js Javascript execution entrypoint
- (void) loadMainJS {
  NSString *jsPath = [self mainJSPath];
  NSError  *err  = nil;

  if (jsPath) {
    NSString *js = [NSString stringWithContentsOfFile: jsPath
                                             encoding: NSUTF8StringEncoding
                                                error: &err];
    if (!err && js) {
      [self.mainContext evaluateScript: js];
    } else {

      [NSException raise: @"Invalid MainJS File" format:
        @"An error occurred trying to read the MainJS File: %@\n\n%@",
        jsPath, err
      ];

    }
  } else {
    [NSException raise: @"Missing MainJS Entrypoint" format:
      @"A Javascript entrypoint must be specified in the %@",
      @"MainJS key in the Info.plist file"
    ];
  }
}

// Returns the path to the Info.plist file for this application or exe
- (NSString *) plistPath {
  return [self pathForResource: @"Info" ofType: @"plist"];
}

// Returns the path to the main.js file that is the program entrypoint.
// This can be specified in Info.plist under the {MainJS} key.
// Defaults to "main.js" in the Bundle or current working directory.
- (NSString *) mainJSPath {
  NSString *fname = nil;
  NSString *ftype = nil;

  if (self.infoPlist) {
    fname = [self.infoPlist objectForKey: @"MainJS"];
    if (fname) {
      ftype = [fname pathExtension];
      fname = [[fname lastPathComponent] stringByDeletingPathExtension];
    }
  }

  if (!fname) fname = @"main";
  if (!ftype) ftype = @"js";

  return [self pathForResource: fname ofType: ftype];
}
// Looks for +filename+ in either the bundle or the current working dir.
- (NSString *) pathForResource: (NSString *)filename
                        ofType: (NSString *)type {
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *plistPath = nil;

  if (bundle) {
    plistPath = [bundle pathForResource: filename ofType: type];
  }

  if (!plistPath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cwd = [fileManager currentDirectoryPath];
    NSMutableString *cwdMutable = [NSMutableString stringWithString: cwd];
    
    if (![cwdMutable hasSuffix: @"/"]) {
      [cwdMutable appendString: @"/"];
    }

    [cwdMutable appendFormat: @"%@.%@", filename, type];
    plistPath = cwdMutable;
  }

  return plistPath;
}

@end
