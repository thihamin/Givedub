//
//  ProjectViewController.m
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProjectViewController.h"
#import "ASIHTTPRequest.h"
#import "NSObject+SBJson.h"
#import "Project.h"

@interface ProjectViewController (PrivateMethods)
- (void) addProjects:(NSMutableArray*)aProjects;
@end

@implementation ProjectViewController

@synthesize projects;
@synthesize mTableView;

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
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadProjects:)];
    self.navigationItem.leftBarButtonItem = refreshButton;
    [refreshButton release];
    
    [self loadProjects:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loadProjects:(id)sender {
    NSLog(@"loadProject");
    NSURL *url = [NSURL URLWithString:@"http://www.givedub.com/ws/projects"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];

}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"responoseString: %@", responseString);

    NSMutableArray *aProjects = [NSMutableArray arrayWithCapacity:1];
    id jsonObject = [responseString JSONValue];
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDict = (NSDictionary*)jsonObject;
        id nodes = [jsonDict objectForKey:@"nodes"];
        if ([nodes isKindOfClass:[NSArray class]]) {
            NSArray *nodesArray = (NSArray*)nodes;
            
            for (id node in nodesArray){
                //NSLog(@"%@", node);
                if ([node isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *nodeDict = (NSDictionary*)node;
                    id nodeObject = [nodeDict objectForKey:@"node"];
                    //NSLog(@"node=%@", node);
                    if ([nodeObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *nodeDict = (NSDictionary*)nodeObject;
                        NSLog(@"name: %@", [nodeDict objectForKey:@"Name"]);
                        NSLog(@"Title: %@", [nodeDict objectForKey:@"Title"]);
                        NSLog(@"Goals: %@", [nodeDict objectForKey:@"GoalAmount"]);
                        
                        Project *project = [[Project alloc] init];
                        project.title = [nodeDict objectForKey:@"Title"];
                        project.location = [nodeDict objectForKey:@"Location"];
                        [aProjects addObject:project];
                        [project release];
                    }
                }
            }
            
        }
    }
    
    [self performSelectorOnMainThread:@selector(addProjects:) withObject:aProjects waitUntilDone:NO];
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}

- (void) addProjects:(NSMutableArray*)aProjects{
    self.projects = aProjects;
    [self.mTableView reloadData];
}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.projects count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Project *project = [self.projects objectAtIndex:indexPath.row];
    cell.textLabel.text = project.title;
    cell.detailTextLabel.text = project.location;
    
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
}


@end
