//
//  TableViewController.m
//  Trilingual
//
//  Created by Pale Purple on 2014. 6. 13..
//  Copyright (c) 2014년 Pale Purple. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController {
}

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

- (IBAction)addTableItem:(id)sender {
    //[list addObject:[[Item alloc] init]];
    [list addObject:[[Item alloc] addItemWithValues: @"hello" Combination: @"world" SourceID:@"!!"]];
    [tableView reloadData];
}

- (void)dealloc {
}

@end
