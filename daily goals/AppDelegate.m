//
//  AppDelegate.m
//  daily goals
//
//  Created by Kosturko, Jessica on 2/14/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

/*
 Todo:
 Constants for tags
 On check - save data
 On Navigation - save data
 Play with fonts
 Mess with Contraints
 Save random data at bottom
 Cross out Task
 rewards/ Success
 
 */
#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    myDictionary = [[NSMutableDictionary alloc] init];
    dateSpecObject = [[NSMutableDictionary alloc] init];
    
    [self setCurrentDate];
    [self updateUIdate];
    [self updateDataObjectWithSavedData];
    [self updateUIwithSavedData];
}

- (IBAction)triggerCheckBox:(NSButton *)sender {
    [self markDoneUndone:sender assocTextField:[[[[sender superview] superview] superview] viewWithTag:10]];
}

- (IBAction)textEvent:(NSTextField *)sender {
    NSButton *checkButton = [[[[sender superview] superview] superview] viewWithTag:20];
    NSNumber *check = [NSNumber numberWithBool:checkButton.state];
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
    if ([myDictionary valueForKey:myDate]) {
        for (NSString* key in [myDictionary valueForKey:myDate]) {
            if ([key isEqual: @"text1"]) {
                _text1.stringValue = [[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"value"];
                [[[[[_text1 superview] superview] superview] viewWithTag:20] setState:(BOOL)[[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"isChecked"]];
                [self markDoneUndone:[[[[_text1 superview] superview] superview] viewWithTag:20] assocTextField:_text1];
            } else if ([key isEqual: @"text2"]) {
                _text2.stringValue = [[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"value"];
                 [[[[[_text2 superview] superview] superview] viewWithTag:20] setState:(BOOL)[[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"isChecked"]];
                    [self markDoneUndone:[[[[_text2 superview] superview] superview] viewWithTag:20] assocTextField:_text2];
            } else if ([key isEqual: @"text3"]) {
                _text3.stringValue = [[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"value"];
                 [[[[[_text3 superview] superview] superview] viewWithTag:20] setState:(BOOL)[[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"isChecked"]];
                [self markDoneUndone:[[[[_text3 superview] superview] superview] viewWithTag:20] assocTextField:_text3];
            }
        }
    } else {
        _text1.stringValue = @"";
        _text2.stringValue = @"";
        _text3.stringValue = @"";
        
    }
}

#pragma View: Update UI to have new date
- (void) updateUIdate {
   _dateLabel.stringValue = [self formatDateforUI:NsDateTracker];
}

#pragma Controller: Set myDate to current Date
- (void)setCurrentDate {
    NsDateTracker = [NSDate date];
    myDate = [self formatDateforDataObject:NsDateTracker];
}

#pragma Controller: Set myDate to user initiated Date
- (void)setDate:(NSString *)direction {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = ([direction isEqualToString:@"forward"])? 1:-1;

    NsDateTracker = [calendar dateByAddingComponents: components toDate: NsDateTracker options: 0];
    myDate = [self formatDateforDataObject:NsDateTracker];
}

#pragma Controller: Date Formater - UI Date
-(NSString *)formatDateforUI:(NSDate *)unformattedNSDate {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy"];
    NSString *dateStr = [format stringFromDate:unformattedNSDate];
    
    return dateStr;
}

#pragma Controller: Date Formater - Data Object
-(NSString *)formatDateforDataObject:(NSDate *)unformattedNSDate {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyy-MM-dd"];
    NSString *dateStr = [format stringFromDate:unformattedNSDate];
    return dateStr;
}

#pragma Controller: set the date format
-(NSString *)getDateFormat {
    NSDate *date = [NSDate date];
    return [self formatDateforUI:date];
}

#pragma Controller: Update data Object with saved data (if any)
- (void)updateDataObjectWithSavedData {
    if ([self getDataFromFile])
        myDictionary = [self getDataFromFile];
}

#pragma Controller: Update Dictionary object with new goal information
- (void)updateDataObjectwithNewInfo:(NSTextField *)sender boxNumber:(NSString *)textFieldInc isChecked:(NSNumber *)checkedBool {
    
    //Initiate text object
    textObject = [[NSMutableDictionary alloc] init];

    [textObject setValue:sender.stringValue forKey:@"value"];
    [textObject setValue:checkedBool forKey:@"isChecked"];
    [dateSpecObject setObject:textObject forKey:textFieldInc];
    [myDictionary setObject:dateSpecObject forKey:myDate];

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

- (IBAction)nextDate:(NSButton *)sender {
    [self setDate:@"forward"];
    [self updateUIdate];
    [self updateUIwithSavedData];
}

- (IBAction)prevDate:(NSButton *)sender {
    [self setDate:@"backward"];
    [self updateUIdate];
    [self updateUIwithSavedData];
}
@end
