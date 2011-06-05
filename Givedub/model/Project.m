//
//  Project.m
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Project.h"


@implementation Project

@synthesize projectId;
@synthesize title;
@synthesize location;
@synthesize name;
@synthesize school;
@synthesize goalAmount;
@synthesize raised;
@synthesize donors;
@synthesize closedDate;

@synthesize photoUrl;
@synthesize videoUrl;

- (void)dealloc {
    [projectId release];
    [title release];
    [location release];
    [name release];
    [school release];
    [goalAmount release];
    [raised release];
    [donors release];
    [closedDate release];
    
    [photoUrl release];
    [videoUrl release];
    
    [super dealloc];
}
@end
