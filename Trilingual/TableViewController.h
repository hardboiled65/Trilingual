//
//  TableViewController.h
//  Trilingual
//
//  Created by Pale Purple on 2014. 6. 13..
//  Copyright (c) 2014년 Pale Purple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface TableViewController : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
@private
    IBOutlet NSTableView *tableView;
    NSMutableArray *list;
}

- (IBAction)addTableItem:(id)sender;

@end
