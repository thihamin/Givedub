//
//  Project.h
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Project : NSObject {
    NSString *title;
    NSString *location;
    
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *location;

@end
