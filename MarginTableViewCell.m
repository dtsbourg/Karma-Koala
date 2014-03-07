//
//  MarginTableViewCell.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 07/03/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "MarginTableViewCell.h"

@implementation MarginTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLabel setFrame:CGRectMake(0, 0, 220, 20)];
}

@end
