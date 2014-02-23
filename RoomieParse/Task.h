//
//  Task.h
//  Roomie
//
//  Created by Dylan Bourgeois on 17/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, strong) NSString *name; 
@property (nonatomic) float karma;
@property (nonatomic) bool completed;
@property (nonatomic, strong) NSDate *date;

@end
