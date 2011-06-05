//
//  Project.m
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Project.h"


@implementation Project

@synthesize title;
@synthesize location;

- (void)dealloc {

    [title release];
    [location release];
    
    [super dealloc];
}
@end
