//
//  Item.h
//  Trilingual
//
//  Created by Pale Purple on 2014. 6. 13..
//  Copyright (c) 2014년 Pale Purple. All rights reserved.
//

//test comment for commit
#import <Foundation/Foundation.h>

@interface Item : NSObject {
@private
    NSString *name;
    NSString *combination;
    NSString *sourceId;
    //int age;
}

- (id)addItemWithValues: (NSString*)sourceName Combination: (NSString*)keyCombination SourceID: (NSString*)inputSourceId;

@property (copy)NSString *name;
@property (copy)NSString *combination;
@property (copy)NSString *sourceId;
//@property int age;

@end
