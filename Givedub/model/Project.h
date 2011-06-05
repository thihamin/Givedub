//
//  Project.h
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Project : NSObject {
    NSNumber *projectId;
    NSString *title;
    NSString *location;
    NSString *name;
    NSString *school;
    //NSDecimalNumber *goalAmount;  
    NSString *goalAmount;
    NSString *raised;
    NSString *donors;
    NSString *closedDate;
    NSString *photoUrl;
    NSString *videoUrl;
}
@property(nonatomic, retain) NSNumber *projectId;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *school;
//@property(nonatomic, retain) NSDecimalNumber *goalAmount;
@property(nonatomic, copy) NSString *goalAmount;

@property(nonatomic, copy) NSString *raised;
@property(nonatomic, copy) NSString *donors;
@property(nonatomic, copy) NSString *closedDate;

@property(nonatomic, copy) NSString *photoUrl;
@property(nonatomic, copy) NSString *videoUrl;

/*
 "field_image_fid": "http:\/\/givedub.com\/sites\/default\/files\/imagecache\/donation_menu_item_220x165\/science_labwork%281%29.gif",
 "title": "Sample Project Two",
 "By": "Team Admin",
 "body": "Sample project two...",
 "value": "Chicago, IL",
 "Goal Amount": "3000.00",
 "Raised": "360.00",
 "Donors": "3",
 "Close Date": "06\/30\/2011",
 "Days Remaining": "25",
 "YouTube_URL": "http:\/\/www.youtube.com\/watch?v=ty33v7UYYbw"
 */

@end
