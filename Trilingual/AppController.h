//
//  AppController.h
//  Trilingual
//
//  Created by Pale Purple on 2014. 6. 9..
//  Copyright (c) 2014년 Pale Purple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "Item.h"

@interface AppController : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    //NSMutableArray *_tableContents;
    IBOutlet NSTableView *tableView;
    __weak NSPopUpButton *_modifierPopup;
    __weak NSPopUpButton *_numericPopup;
    
    NSMutableArray *list;
    
    NSStatusItem *statusItem;
    IBOutlet NSMenu *statusMenu;
}

//- (IBAction)addTableItem:(id)sender;
- (IBAction)showMainWindow:(id)sender;
- (IBAction)callControlModal:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)easterEgg:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *modalSheet;
@property (assign) IBOutlet NSWindow *easteregg;
@property (weak) IBOutlet NSPopUpButton *modifierPopup;
@property (weak) IBOutlet NSPopUpButton *numericPopup;
@end
