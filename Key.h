//
//  Key.h
//  Pew
//
//  Created by Sean Kelley on 11/24/13.
//  Copyright (c) 2013 Sean Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Key : NSObject

@property (nonatomic, assign) int code;
@property (nonatomic, assign) bool status;

- (id) init;

@end
