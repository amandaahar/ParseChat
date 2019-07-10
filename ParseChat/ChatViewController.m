//
//  ChatViewController.m
//  ParseChat
//
//  Created by amandahar on 7/10/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchMessages) userInfo:nil repeats:true];
}

- (IBAction)onSendTap:(id)sender {
    // Create message
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2019"];
    
    // Store text
    NSLog(@"%@", self.textField.text);
    chatMessage[@"text"] = self.textField.text;
    chatMessage[@"user"] = [PFUser currentUser];
    
    // Save message
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    
    // Clear text field
    self.textField.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) fetchMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2019"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if (messages != nil) {
            self.messages = messages;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    PFObject *chatMessage = self.messages[indexPath.row];
    PFUser *user = chatMessage[@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.userLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.userLabel.text = @"🤖";
    }
    cell.messageLabel.text = chatMessage[@"text"];
    
    
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

@end
