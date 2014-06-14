//
//  AppController.m
//  Trilingual
//
//  Created by Pale Purple on 2014. 6. 9..
//  Copyright (c) 2014년 Pale Purple. All rights reserved.
//

#import "AppController.h"
#import <Carbon/Carbon.h>

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
NSArray *splitKeyCombination(NSString *string);
int numToKeyCode(int num);

NSArray *enabledList;

NSUserDefaults *defaults;
NSDictionary *hotKeysDict;
NSMutableDictionary *hotKeysMutableDict;

EventHotKeyRef myHotKeyRef;
EventHotKeyID hotKeyID;
EventTypeSpec eventType;

@implementation AppController{
    NSMutableArray *_tableContents;
}
@synthesize modalSheet = _modalSheet;
// 순서: 목록 보여주기 -> 설정 불러오기 -> 키 등록하기 << 무시

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    //NSLog(@"Hello, world!");
    [self refresh];
    
    // Status Item
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    //[statusItem setTitle:@"temporarytitle"];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"statusicon.png"]];
}
- (void)awakeFromNib {
    
    // table
    /*
    _tableContents = [[NSMutableArray alloc] init];
    NSString *path = @"/Library/Application Support/Apple/iChat Icons/Flags";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *directoryEnum = [fileManager enumeratorAtPath:path];
    
    NSString *file;
    while (file = [directoryEnum nextObject]) {
        NSString *filePath = [path stringByAppendingFormat:@"/%@", file];
        NSDictionary *obj = @{@"image": [[NSImage alloc] initByReferencingFile:filePath], @"name": file};
        NSLog(@"%@", obj);
        [_tableContents addObject:obj];
    }
    [_tableView reloadData];
     */
    //
    
    // User Preference
    [self refreshPreference];
    //
    
    enabledList = (__bridge NSArray*)TISCreateInputSourceList(NULL, FALSE);
    /*
    CFArrayRef tempList = TISCreateInputSourceList(NULL, FALSE);
    TISInputSourceRef testRef = NULL;
    
    CFIndex count = CFArrayGetCount(tempList);
    for (int i = 0; i < count; i++) {
        testRef = (TISInputSourceRef)CFArrayGetValueAtIndex(tempList, i);
        NSLog(@"---%@", testRef);
    }
     */
    
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    InstallApplicationEventHandler(&hotKeyHandler, 1, &eventType, NULL, NULL);
    
    hotKeyID.signature = (OSType)@"key0";
    hotKeyID.id = 0;
    
    /*
    for (NSString *arr in enabledList) {
        //CFArrayRef prf0 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceCategory); // = <<<TISCategoryKeyboardInputSource>>>
        
        //NSArray *pType = (__bridge NSArray *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceType));
        //NSLog(@" PropertyInputSourceType: %@", pType);
        
        //CFArrayRef prf2 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsASCIICapable);
        //CFArrayRef prf3 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsEnableCapable);
        //CFArrayRef prf4 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsSelectCapable);
        //CFArrayRef prf5 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsEnabled);
        //NSLog(@" PropertyInputSourceIsEnabled: %@", prf5);
        //CFArrayRef prf6 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsSelected);
        NSString *pSourceId = (__bridge NSString *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceID));
        CFArrayRef prf8 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyBundleID);
        CFArrayRef prf9 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputModeID);
        NSString *pLocal = (__bridge NSString *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyLocalizedName));
        //CFArrayRef prf11 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceLanguages);
        //NSLog(@" PropertyInputSourceLanguages: %@", prf11);
        //CFArrayRef prf12 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyUnicodeKeyLayoutData); // all keys' data
        //CFArrayRef prf13 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyIconRef); // ??? but ERROR
        CFArrayRef prf14 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyIconImageURL);
        
        NSString *pType = (__bridge NSString *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceType));
        
        if ([pType isEqualToString: @"TISTypeKeyboardLayout"] || [pType isEqualToString:@"TISTypeKeyboardInputMode"]) {
            if ([hotKeysDict objectForKey:pSourceId]) {
                NSLog(@"EXIST");
                
                NSString *hotKey = [hotKeysDict objectForKey:pSourceId];
                int modifierKey;
                
                if ([[splitKeyCombination(hotKey) objectAtIndex:0] isEqualToString:@"control"]) {
                    modifierKey = controlKey;
                } else if ([[splitKeyCombination(hotKey) objectAtIndex:0] isEqualToString:@"option"]) {
                    modifierKey = optionKey;
                }
                
                hotKeyID.id = (int)[enabledList indexOfObject:arr];
                hotKeyID.signature = (OSType)[NSString stringWithFormat:@"%@%d", @"key", hotKeyID.id];
                
                RegisterEventHotKey(numToKeyCode([[splitKeyCombination(hotKey) objectAtIndex:2] intValue]), modifierKey+shiftKey, hotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
                //NSLog(@"numToKeyCode: %d, modifierKey: %d, controlKey: %d, hotKeyID:", numToKeyCode([[splitKeyCombination(hotKey) objectAtIndex:2] intValue]), modifierKey, controlKey);
                
                [list addObject:[[Item alloc] addItemWithValues: pLocal Combination: hotKey SourceID:pSourceId]];
            } else {
                //NSLog(@"NOT EXIST");
                [list addObject:[[Item alloc] addItemWithValues: pLocal Combination: @"" SourceID:pSourceId]];
            }
            [tableView reloadData];
     
            //NSLog(@" PropertyInputSourceID: %@", prf7);
            //NSLog(@" PropertyBundleID: %@", prf8);
            //NSLog(@" PropertyInputModeID: %@", prf9);
            //NSLog(@" PropertyLocalizedName: %@", prf10);
            //NSLog(@" PropertyIconImageURL: %@", prf14);
            //NSLog(@"The Index is: %d", (int)[enabledList indexOfObject:arr]);
        }
    }
     */
    
    /*
    hotKeyID.signature = 'key1';
    hotKeyID.id = 1;
    
    RegisterEventHotKey(0, cmdKey+optionKey, hotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
    
    hotKeyID.signature = 'key2';
    hotKeyID.id = 2;
    RegisterEventHotKey(1, cmdKey+optionKey, hotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
     */
}

NSArray *splitKeyCombination(NSString *string) {
    return [string componentsSeparatedByString:@"+"];
}

int numToKeyCode(int num) {
    int result;
    switch (num) {
        case 0:
            result = kVK_ANSI_0;
            break;
        case 1:
            result = kVK_ANSI_1;
            break;
        case 2:
            result = kVK_ANSI_2;
            break;
        case 3:
            result = kVK_ANSI_3;
            break;
        case 4:
            result = kVK_ANSI_4;
            break;
        case 5:
            result = kVK_ANSI_5;
            break;
        case 6:
            result = kVK_ANSI_6;
            break;
        case 7:
            result = kVK_ANSI_7;
            break;
        case 8:
            result = kVK_ANSI_8;
            break;
        case 9:
            result = kVK_ANSI_9;
            break;
        default:
            result = 0;
    }
    return result;
}

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
    EventHotKeyID hkRef;
    GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkRef), NULL, &hkRef);
    //NSLog(@"hkRef.id: %u", (unsigned int)hkRef.id);
    TISSelectInputSource((TISInputSourceRef)CFArrayGetValueAtIndex((CFArrayRef)enabledList, (unsigned int)hkRef.id));
    return noErr;
}

/*
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    //return [list count];
    return [_tableContents count];
}

- (NSView *)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //Item *t = [list objectAtIndex:row];
    NSDictionary *flag = _tableContents[row];
    NSString *identifier = [tableColumn identifier];
    if ([identifier isEqualToString:@"MainCell"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        [cellView.textField setStringValue:flag[@"name"]];
        [cellView.imageView setImage:flag[@"image"]];
        
        return cellView;
    }
    return nil;
    //return [t valueForKey:identifier];
}
 */


















- (id)init {
    self = [super init];
    
    if (self) {
        list = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [list count];
}

- (NSView *)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    Item *t = [list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    return [t valueForKey:identifier];
}

/*
- (IBAction)addTableItem:(id)sender {
    //[list addObject:[[Item alloc] init]];
    [list addObject:[[Item alloc] addItemWithValues: @"hello" Combination: @"world"]];
    [tableView reloadData];
}
 */

- (IBAction)showMainWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}

- (IBAction)callControlModal:(id)sender {
    NSInteger selected = [tableView selectedRow];
    if (selected != -1) {
    ////
    if (!_modalSheet) {
        [[NSBundle mainBundle] loadNibNamed:@"ModalSheet" owner:self topLevelObjects:nil];
    }
    if (![[[list objectAtIndex:selected] combination] isEqualToString:@""]) {
        NSString *modifierForSelectedRow = [splitKeyCombination([[list objectAtIndex:selected] combination]) objectAtIndex:0];
        NSString *numericForSelectedRow = [splitKeyCombination([[list objectAtIndex:selected] combination]) objectAtIndex:2];
    
        if ([modifierForSelectedRow isEqualToString:@"control"]) {
            [_modifierPopup selectItemAtIndex:0];
        } else if ([modifierForSelectedRow isEqualToString:@"option"]) {
            [_modifierPopup selectItemAtIndex:1];
        }
        [_numericPopup selectItemWithTitle:numericForSelectedRow];
    }
    
    [NSApp beginSheet:self.modalSheet
       modalForWindow:[[NSApp delegate] window]
        modalDelegate:self
       didEndSelector:NULL
          contextInfo:NULL];
    ////
    }
}

- (IBAction)cancel:(id)sender {
    [NSApp endSheet:self.modalSheet];
    [self.modalSheet close];
    self.modalSheet = nil;
}

- (IBAction)done:(id)sender {
    NSString *newModifier = [[[[[_modifierPopup selectedItem] title] componentsSeparatedByString:@" + "] objectAtIndex:0] lowercaseString];
    NSString *newNumeric = [[_numericPopup selectedItem] title];
    NSString *newCombination = [NSString stringWithFormat:@"%@+shift+%@", newModifier, newNumeric];
    NSString *sourceId = [[list objectAtIndex:[tableView selectedRow]] sourceId];
    
    if ([newNumeric isEqualToString:@""]) {
        [hotKeysMutableDict removeObjectForKey:sourceId];
    } else {
        [hotKeysMutableDict setValue:newCombination forKey:sourceId];
    }
    [defaults setObject:hotKeysMutableDict forKey:@"HotKeysDictionary"];
    [defaults synchronize];
    
    [self refreshPreference];
    [self refresh];
    
    [NSApp endSheet:self.modalSheet];
    [self.modalSheet close];
    self.modalSheet = nil;
}

- (IBAction)quit {
    [NSApp terminate:nil];
}

- (IBAction)easterEgg:(id)sender {
    [self.easteregg makeKeyAndOrderFront:nil];
}

- (void)refresh {
    [list removeAllObjects];
    for (NSString *arr in enabledList) {
        //CFArrayRef prf0 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceCategory); // = <<<TISCategoryKeyboardInputSource>>>
        
        //NSArray *pType = (__bridge NSArray *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceType));
        //NSLog(@" PropertyInputSourceType: %@", pType);
        
        //CFArrayRef prf2 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsASCIICapable);
        //CFArrayRef prf3 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsEnableCapable);
        //CFArrayRef prf4 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsSelectCapable);
        //CFArrayRef prf5 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsEnabled);
        //NSLog(@" PropertyInputSourceIsEnabled: %@", prf5);
        //CFArrayRef prf6 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceIsSelected);
        NSString *pSourceId = (__bridge NSString *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceID));
        CFArrayRef prf8 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyBundleID);
        CFArrayRef prf9 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputModeID);
        NSString *pLocal = (__bridge NSString *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyLocalizedName));
        //CFArrayRef prf11 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceLanguages);
        //NSLog(@" PropertyInputSourceLanguages: %@", prf11);
        //CFArrayRef prf12 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyUnicodeKeyLayoutData); // all keys' data
        //CFArrayRef prf13 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyIconRef); // ??? but ERROR
        CFArrayRef prf14 = TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyIconImageURL);
        
        NSString *pType = (__bridge NSString *)(TISGetInputSourceProperty((__bridge TISInputSourceRef)(arr), kTISPropertyInputSourceType));
        
        if ([pType isEqualToString: @"TISTypeKeyboardLayout"] || [pType isEqualToString:@"TISTypeKeyboardInputMode"]) {
            if ([hotKeysDict objectForKey:pSourceId]) {
                //NSLog(@"EXIST");
                
                NSString *hotKey = [hotKeysDict objectForKey:pSourceId];
                int modifierKey;
                
                if ([[splitKeyCombination(hotKey) objectAtIndex:0] isEqualToString:@"control"]) {
                    modifierKey = controlKey;
                } else if ([[splitKeyCombination(hotKey) objectAtIndex:0] isEqualToString:@"option"]) {
                    modifierKey = optionKey;
                }
                
                hotKeyID.id = (int)[enabledList indexOfObject:arr];
                hotKeyID.signature = (OSType)[NSString stringWithFormat:@"%@%d", @"key", hotKeyID.id];
                
                RegisterEventHotKey(numToKeyCode([[splitKeyCombination(hotKey) objectAtIndex:2] intValue]), modifierKey+shiftKey, hotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
                //NSLog(@"numToKeyCode: %d, modifierKey: %d, controlKey: %d, hotKeyID:", numToKeyCode([[splitKeyCombination(hotKey) objectAtIndex:2] intValue]), modifierKey, controlKey);
                
                [list addObject:[[Item alloc] addItemWithValues: pLocal Combination: hotKey SourceID:pSourceId]];
            } else {
                //NSLog(@"NOT EXIST");
                [list addObject:[[Item alloc] addItemWithValues: pLocal Combination: @"" SourceID:pSourceId]];
            }
            [tableView reloadData];
            
            //NSLog(@" PropertyInputSourceID: %@", prf7);
            //NSLog(@" PropertyBundleID: %@", prf8);
            //NSLog(@" PropertyInputModeID: %@", prf9);
            //NSLog(@" PropertyLocalizedName: %@", prf10);
            //NSLog(@" PropertyIconImageURL: %@", prf14);
            //NSLog(@"The Index is: %d", (int)[enabledList indexOfObject:arr]);
        }
    }
}

- (void)refreshPreference {
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"TestStringOption"];
    
    hotKeysDict = [defaults dictionaryForKey:@"HotKeysDictionary"];
    hotKeysMutableDict = [NSMutableDictionary dictionaryWithDictionary:[hotKeysDict mutableCopy]];
    //[hotKeysMutableDict setValue:@"control+shift+1" forKey:@"com.apple.keylayout.US"];
    //NSLog(@"%@", hotKeysDict);
    //[defaults setObject:hotKeysMutableDict forKey:@"HotKeysDictionary"];
    //[defaults synchronize];
}

- (void)dealloc {
}

@end
