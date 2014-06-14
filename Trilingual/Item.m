//
//  Item.m
//  Trilingual
//
//  Created by Pale Purple on 2014. 6. 13..
//  Copyright (c) 2014년 Pale Purple. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize name;
@synthesize combination;
@synthesize sourceId;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here
        name = @"name";
        combination = @"key combination";
    }
    
    return self;
}

- (id)addItemWithValues: (NSString*)sourceName Combination: (NSString*)keyCombination SourceID:(NSString *)inputSourceId{
    name = sourceName;
    combination = keyCombination;
    sourceId = inputSourceId;
    
    return self;
}

@end
