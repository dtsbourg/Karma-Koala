//
//  Task.h
//  Roomie
//
//  Created by Dylan Bourgeois on 17/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, strong) NSString *name; // name of task
@property (nonatomic) float karma; // karma
@property (nonatomic) bool completed;
@property (nonatomic, strong) NSDate *date;

@end
