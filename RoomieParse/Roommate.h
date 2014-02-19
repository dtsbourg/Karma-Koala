//
//  Roommate.h
//  Roomie
//
//  Created by Dylan Bourgeois on 17/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Roommate : NSObject
@property (nonatomic, strong) NSString *firstName; // name of recipe
@property (nonatomic, strong) NSString *lastName; // preparation time
@property (nonatomic, strong) NSString *imageFile; // image filename of recipe
@property (nonatomic) float karma; 
@end
