//
//  Key.m
//  Pew
//
//  Created by Sean Kelley on 11/24/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import "Key.h"

@implementation Key

@synthesize status;
@synthesize code;

- (id) init {
    if (self = [super init])
    {
        status = false;
        code = 0;
    }
    return self;
}
@end
