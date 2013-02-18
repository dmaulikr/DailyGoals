//
//  AppDelegate.m
//  daily goals
//
//  Created by Kosturko, Jessica on 2/14/13.
//  Copyright (c) 2013 Kosturko, Jessica. All rights reserved.
//

/*
 Todo:
 Play with fonts
 Mess with Contraints
 Save random data at bottom
 Cross out Task
 rewards/ Success
 
 */

#define _Checked [NSColor grayColor]
#define _UnChecked [NSColor blackColor]
#define _storageFile @"file.txt"
#define _TAG_FOR_TEXTFIELD 10
#define _TAG_FOR_CHECKBOX 20

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
    //[self updateDataObjectwithNewInfoNoParams];
    [self saveAllDataAtOnce];
    [self markDoneUndone:sender assocTextField:[[[[sender superview] superview] superview] viewWithTag:_TAG_FOR_TEXTFIELD]];
}

- (IBAction)textEvent:(NSTextField *)sender {
    NSButton *checkButton = [[[[sender superview] superview] superview] viewWithTag:_TAG_FOR_CHECKBOX];
    NSNumber *check = [NSNumber numberWithBool:checkButton.state];
    [self updateDataObjectwithNewInfo:sender boxNumber:sender.identifier isChecked:check];
}

#pragma View: Mark Undone/Done Goal
- (void)markDoneUndone:(NSButton *)checkMark assocTextField:(NSTextField *)textfield {  
    textfield.textColor = (checkMark.state == 1)? _Checked:_UnChecked;
}

#pragma Controller: From Data Object To View Function to update UI)
- (void)updateUIwithSavedData {
    if ([myDictionary valueForKey:myDate]) {
        for (NSString* key in [myDictionary valueForKey:myDate]) {
            if ([key isEqual: @"text1"]) 
                [self updateUIwithDataObjectData:_text1 checkBox:_check1 key:key];
             else if ([key isEqual: @"text2"]) 
                [self updateUIwithDataObjectData:_text2 checkBox:_check2 key:key];
             else if ([key isEqual: @"text3"]) 
                [self updateUIwithDataObjectData:_text3 checkBox:_check3 key:key];
        }
    } else {
        _text1.stringValue = @"", _text2.stringValue = @"", _text3.stringValue = @"";
    }
}

#pragma View: DataObject to UI
-(void)updateUIwithDataObjectData:(NSTextField *)textfield checkBox:(NSButton *)checkbox  key:(NSString *)key{
    textfield.stringValue = [[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"value"];
    [[[[[textfield superview] superview] superview] viewWithTag:20] setState:(BOOL)[[[myDictionary valueForKey:myDate] valueForKey:key] valueForKey:@"isChecked"]];
    [self markDoneUndone:[[[[textfield superview] superview] superview] viewWithTag:20] assocTextField:textfield];
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
    dateSpecObject = [[NSMutableDictionary alloc] init];
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
  
    textObject = [[NSMutableDictionary alloc] init];

    [textObject setValue:sender.stringValue forKey:@"value"];
    [textObject setValue:checkedBool forKey:@"isChecked"];
    [dateSpecObject setObject:textObject forKey:textFieldInc];
    [myDictionary setObject:dateSpecObject forKey:myDate];
    
    //Controller pass info to Model to store and retrieve data
    [self saveDatatoFile:myDictionary];
}

-(void)saveAllDataAtOnce {
    [self updateDataObjectwithNewInfo:_text1 boxNumber:@"text1" isChecked:[NSNumber numberWithBool:_check1.state]];
    [self updateDataObjectwithNewInfo:_text2 boxNumber:@"text2" isChecked:[NSNumber numberWithBool:_check2.state]];
    [self updateDataObjectwithNewInfo:_text3 boxNumber:@"text3" isChecked:[NSNumber numberWithBool:_check3.state]];
}

#pragma Model: Get Data from File (If it exists)
- (NSMutableDictionary *)getDataFromFile {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:_storageFile];
    NSMutableDictionary *savedStock = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    return savedStock;
}

#pragma Model:Save Data to text File
- (void)saveDatatoFile:(NSMutableDictionary *)dictionaryToSave {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:_storageFile];
    [dictionaryToSave writeToFile:filePath atomically:YES];
}

- (IBAction)nextDate:(NSButton *)sender {
    [self saveAllDataAtOnce];
    [self setDate:@"forward"];
    [self updateUIdate];
    [self updateUIwithSavedData];
}

- (IBAction)prevDate:(NSButton *)sender {
    [self saveAllDataAtOnce];
    [self setDate:@"backward"];
    [self updateUIdate];
    [self updateUIwithSavedData];
}
@end
