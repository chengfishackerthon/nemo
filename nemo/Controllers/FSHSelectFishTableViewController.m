//
//  FSHSelectFishTableViewController.m
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHSelectFishTableViewController.h"
#import "FSHFishTableViewCell.h"
#import "FSHWebDetailViewController.h"

static const NSString *kServer = @"http://172.16.1.126:9090";

@interface FSHSelectFishTableViewController ()

@property (nonatomic, strong) NSArray *results;

@end

@implementation FSHSelectFishTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)load
{
    NSString *str = [NSString stringWithFormat:@"%@/query?lat=%f&lon=%f", kServer, self.location.coordinate.latitude, self.location.coordinate.longitude];
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    self.results = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];

    NSLog(@"Your JSON Object: %@ Or Error is: %@", self.results, error);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self load];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)selection
{
    if (!_selection) {
        _selection = [[NSMutableArray alloc] init];
    }
    return _selection;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"FISH";

    FSHFishTableViewCell *cell = (FSHFishTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FSHFishTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    // Configure the cell...
    cell.nameLabel.text = [self.results[indexPath.row] valueForKeyPath:@"Name"];
    cell.speciesLabel.text = [self.results[indexPath.row] valueForKeyPath:@"Species"];

    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSURL *imageURL = [NSURL URLWithString:[self.results[indexPath.row] valueForKeyPath:@"ImageUrl"]];

        NSLog(@"Fetch image URL %@", imageURL);
        NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];

        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.thumbnailImageView.image = [UIImage imageWithData:image];
        });
    });

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    [self.selection addObject:self.results[indexPath.row]];
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"toDetail" sender:indexPath];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        //Detect sender class and act accordingly
        NSIndexPath *indexPath = [sender isKindOfClass:[NSIndexPath class]] ? (NSIndexPath*)sender : [self.tableView indexPathForSelectedRow];
        FSHWebDetailViewController *destViewController = segue.destinationViewController;
        destViewController.selectedItem = [self.results[indexPath.row] valueForKeyPath:@"Name"];
    }
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
