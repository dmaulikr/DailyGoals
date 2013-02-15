//
//  AppDelegate.h
//  daily goals
//
//  Created by Kosturko, Jessica on 2/14/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableDictionary *myDictionary;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)check1:(NSButton *)sender;
- (IBAction)check2:(NSButton *)sender;
- (IBAction)check3:(NSButton *)sender;

@property (weak) IBOutlet NSTextField *text1;
@property (weak) IBOutlet NSTextField *text2;
@property (weak) IBOutlet NSTextField *text3;

- (IBAction)text1action:(NSTextField *)sender;
- (IBAction)text2action:(NSTextField *)sender;
- (IBAction)text3action:(NSTextField *)sender;

@end
