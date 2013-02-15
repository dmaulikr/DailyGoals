//
//  AppDelegate.m
//  daily goals
//
//  Created by Kosturko, Jessica on 2/14/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    myDictionary = [[NSMutableDictionary alloc] init];

    // Insert code here to initialize your application
}

- (IBAction)check1:(NSButton *)sender {
    [self markDoneUndone:sender :_text1];
}

- (IBAction)check2:(NSButton *)sender {
    [self markDoneUndone:sender :_text2];
}
- (IBAction)check3:(NSButton *)sender {
    [self markDoneUndone:sender :_text3];
}

- (IBAction)text1action:(NSTextField *)sender {
    [self updateDataObjectwithNewInfo:sender boxNumber:@"1"];
}

- (IBAction)text2action:(NSTextField *)sender {
        [self updateDataObjectwithNewInfo:sender boxNumber:@"2"];
}

- (IBAction)text3action:(NSTextField *)sender {
        [self updateDataObjectwithNewInfo:sender boxNumber:@"3"];
}

#pragma View: Mark Undone/Done Goal
- (void)markDoneUndone:(NSButton *)checkMark :(NSTextField *)textfield {
    if (checkMark.state == 1) {
        textfield.textColor = [NSColor grayColor];
    }
    else {
        textfield.textColor = [NSColor blackColor];
    }
}


#pragma View: Update Interface with saved Data (init)
- (void)updateUIwithSavedData {
    
}

#pragma Controller: Update data Object with saved data (if any)
- (void)updateDataObjectWithSavedData {
    myDictionary = [self getDataFromFile];
}

#pragma Controller: Update Dictionary object with new goal information
- (void)updateDataObjectwithNewInfo:(NSTextField *)sender boxNumber:(NSString *)stringNumber {

    NSString *myWord = sender.stringValue;
    NSString *theInt = stringNumber;
    NSNumber *value = [myDictionary objectForKey:myWord];
    
    if (value) {
        NSNumber *nextValue = [NSNumber numberWithInt:[value intValue] + 1];
        [myDictionary setObject:nextValue  forKey:myWord];
    }
    else {
        [myDictionary setObject:myWord forKey:theInt];
    }

    //Controller pass info to Model to store and retrieve data
}

#pragma Model: Get Data from File (If it exists)
- (NSMutableDictionary *)getDataFromFile {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    NSMutableDictionary *savedStock = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    return savedStock;
}

#pragma Model:Save Data to text File
- (void)saveDatatoFile {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    [myDictionary writeToFile:filePath atomically:YES];
}


@end
