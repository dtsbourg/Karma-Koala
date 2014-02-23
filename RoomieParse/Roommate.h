//
//  Roommate.h
//  Roomie
//
//  Created by Dylan Bourgeois on 17/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Roommate : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *imageFile; 
@property (nonatomic) float karma; 
@end
