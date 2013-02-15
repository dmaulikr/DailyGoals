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
    dateSpecObject = [[NSMutableDictionary alloc] init]; //probShould go somewhere else
    myDate = @"20130215";
    
    [self updateDataObjectWithSavedData];
    [self updateUIwithSavedData];
}

- (IBAction)triggerCheckBox:(NSButton *)sender {
    [self markDoneUndone:sender assocTextField:[[[[sender superview] superview] superview] viewWithTag:10] ];
}

- (IBAction)textEvent:(NSTextField *)sender {
    
    NSButton *checkButton = [[[[sender superview] superview] superview] viewWithTag:20];
    NSInteger check = checkButton.state;
    [self updateDataObjectwithNewInfo:sender boxNumber:sender.identifier isChecked:check];
}

#pragma View: Mark Undone/Done Goal
- (void)markDoneUndone:(NSButton *)checkMark assocTextField:(NSTextField *)textfield {
    if (checkMark.state == 1) {
        textfield.textColor = [NSColor grayColor];
    }
    else {
        textfield.textColor = [NSColor blackColor];
    }
}

#pragma View: Update Interface with saved Data (init)
- (void)updateUIwithSavedData {
    if ([myDictionary valueForKey:myDate])
    {
        for (NSString* key in [myDictionary valueForKey:myDate]) {
            if ([key isEqual: @"text1"]) {
                _text1.stringValue = [[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"value"];
            } else if ([key isEqual: @"text2"]) {
                _text2.stringValue = [[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"value"];
            } else if ([key isEqual: @"text3"]) {
                _text3.stringValue = [[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"value"];
            }

        }

    }
    
}

#pragma Controller: Update data Object with saved data (if any)
- (void)updateDataObjectWithSavedData {
    
    if ([self getDataFromFile])
    {
        myDictionary = [self getDataFromFile];
    }
}

#pragma Controller: Update Dictionary object with new goal information
- (void)updateDataObjectwithNewInfo:(NSTextField *)sender boxNumber:(NSString *)stringNumber isChecked:(long)checkedBool {
    NSString *textFieldInc = stringNumber;
    NSString *dateExists = [myDictionary valueForKey:myDate];
    
    if (!dateExists) {
        [myDictionary setObject:dateSpecObject forKey:myDate];
    }
    
    textObject = [[NSMutableDictionary alloc] init];

    [textObject setValue:sender.stringValue forKey:@"value"];
    [textObject setValue:@"true" forKey:@"isChecked"];
    [dateSpecObject setObject:textObject forKey:textFieldInc];
    
    //Controller pass info to Model to store and retrieve data
    [self saveDatatoFile:myDictionary];
}

#pragma Model: Get Data from File (If it exists)
- (NSMutableDictionary *)getDataFromFile {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    NSMutableDictionary *savedStock = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    return savedStock;
}

#pragma Model:Save Data to text File
- (void)saveDatatoFile:(NSMutableDictionary *)dictionaryToSave {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    [dictionaryToSave writeToFile:filePath atomically:YES];
}


@end
