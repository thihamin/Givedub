//
//  ProjectDetailViewController.m
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "NSObject+SBJson.h"
#import "AsyImageView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ProjectDetailViewController (PrivateMethods)
- (void) addToDetailCellDataWithLabel:(NSString*)aLabel text:(NSString*)aText selectorName:(NSString*)aSelectorName;
- (void) playVideo;
@end

@implementation ProjectDetailViewController

@synthesize mTableView;
@synthesize project;
@synthesize detailsArray;

static NSString *LABEL_KEY = @"kLabelKey";
static NSString *TEXT_KEY = @"kTextKey";
static NSString *SELECTOR_KEY = @"kSelectorKey";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [project release];
    [detailsArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.detailsArray = [NSMutableArray arrayWithCapacity:1];
    
    [self.mTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void) addProject:(Project*) aProject {
    NSLog(@"addProject: %@", aProject.title);
    if (self.detailsArray) {
        [self.detailsArray removeAllObjects];
    }else{
        self.detailsArray = [NSMutableArray arrayWithCapacity:1];
    }
    self.project = aProject;

//    if (self.project.title && ![self.project.title isEqualToString:@""]) {
//        [self addToDetailCellDataWithLabel:@"Title" text:self.project.title selectorName:nil];
//    }
    
    if (self.project.school && ![self.project.school isEqualToString:@""]) {
        [self addToDetailCellDataWithLabel:@"School:" text:self.project.school selectorName:nil];
    }
    
    if (self.project.location && ![self.project.location isEqualToString:@""]) {
        [self addToDetailCellDataWithLabel:@"Location:" text:self.project.location selectorName:nil];
    }
    
    if (self.project.goalAmount && ![self.project.goalAmount isEqualToString:@""]) {
//        NSNumberFormatter * formatter = [[[NSNumberFormatter alloc] init] autorelease];
//        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [self addToDetailCellDataWithLabel:@"Goal:" text:self.project.goalAmount selectorName:nil];
    }
    
    if (self.project.raised && ![self.project.raised isEqualToString:@""]) {
        [self addToDetailCellDataWithLabel:@"Raised:" text:self.project.raised selectorName:nil];
    }else{
        [self addToDetailCellDataWithLabel:@"Raised:" text:@"0.00" selectorName:nil];
    }
    
    if (self.project.donors && ![self.project.donors isEqualToString:@""]) {
        [self addToDetailCellDataWithLabel:@"Donors:" text:self.project.donors selectorName:nil];
    }
    
    if (self.project.closedDate && ![self.project.closedDate isEqualToString:@""]) {
        [self addToDetailCellDataWithLabel:@"Closing:" text:self.project.closedDate selectorName:nil];
    }
    
    if (self.project.videoUrl && ![self.project.videoUrl isEqualToString:@""]) {
        [self addToDetailCellDataWithLabel:@"Video:" text:@"Play" selectorName:@"playVideo"];
    }
    
    self.mTableView.tableHeaderView = nil;
    
    if (self.project.photoUrl && ![self.project.photoUrl isEqualToString:@""]) {
        AsyImageView *imageView = [[AsyImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 200.0)];
        NSURL *url = [NSURL URLWithString:self.project.photoUrl];
        [imageView loadImageFromUrl:url];
        self.mTableView.tableHeaderView = imageView;
    }
    
    
    [self.mTableView reloadData];
    
}


- (void) addToDetailCellDataWithLabel:(NSString*)aLabel text:(NSString*)aText selectorName:(NSString*)aSelectorName{
    NSMutableDictionary *cellDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [cellDict setValue:aLabel forKey:LABEL_KEY];
    [cellDict setValue:aText forKey:TEXT_KEY];
    [cellDict setValue:aSelectorName forKey:SELECTOR_KEY];
    
    [self.detailsArray addObject:cellDict];
    [cellDict release];
}


#pragma mark - 
#pragma mark - LoadProject

//- (void) loadProject{
//    
//    
//}

//- (IBAction)grabURLInBackground:(id)sender
- (void) loadProject
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://givedub.com/ws/project/%d", [self.project.projectId intValue]]];
    NSLog(@"url: %@", [url absoluteString]);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    id jsonObject = [responseString JSONValue];
    if([jsonObject isKindOfClass:[NSDictionary class]]){
        id nodes = [((NSDictionary*)jsonObject) objectForKey:@"nodes"];
        if ([nodes isKindOfClass:[NSArray class]]) {
            NSArray *nodesArray = (NSArray*)nodes;
            if ([nodesArray count] > 0) {
                id node = [nodesArray objectAtIndex:0];
                if ([node isKindOfClass:[NSDictionary class]]) {
                    id nodeObject = [((NSDictionary*)node) objectForKey:@"node"];
                    if ([nodeObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *nodeDict = (NSDictionary*)nodeObject;
                        self.project.raised = [nodeDict objectForKey:@"Raised"];
                        self.project.closedDate = [nodeDict objectForKey:@"Close Date"];
                        self.project.donors = [nodeDict objectForKey:@"Donors"];
                        self.project.photoUrl = [nodeDict objectForKey:@"field_image_fid"];
                        self.project.videoUrl = [nodeDict objectForKey:@"YouTube_URL"];
                    }
                }
            }
        }
    }
    
    [self performSelectorOnMainThread:@selector(addProject:) withObject:self.project waitUntilDone:NO];
    
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}


#pragma mark -

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSLog(@"detailsArray count= %d", [self.detailsArray count]);
        return [self.detailsArray count];        
    }else{
        
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.project.title;
    }else{
        return nil;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        NSMutableDictionary *cellData = [self.detailsArray objectAtIndex:indexPath.row];
        NSString *aLabel = [cellData valueForKey:LABEL_KEY];
        NSString *aText = [cellData valueForKey:TEXT_KEY];
        NSLog(@"label: %@, text: %@", aLabel, aText);
        
        cell.textLabel.text = aLabel;
        cell.detailTextLabel.text = aText;
        if ([cellData valueForKey:SELECTOR_KEY]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"Donate";
        //cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    
    // Configure the cell.
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    NSDictionary *cellDict = [self.detailsArray objectAtIndex:indexPath.row];
    NSString *selectorName = [cellDict objectForKey:SELECTOR_KEY];
    if (selectorName && ![selectorName isEqualToString:@""]) {
        SEL selector = NSSelectorFromString(selectorName);
        [self performSelector:selector];
    }
}


#pragma mark - 
#pragma mark - Video Play

- (void) playVideo{
    NSLog(@"playVideo");
    NSURL *url = [NSURL URLWithString:self.project.videoUrl];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self.navigationController presentMoviePlayerViewControllerAnimated:moviePlayer];
    [moviePlayer release];
}

@end
