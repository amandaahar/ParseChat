//
//  ChatCell.h
//  ParseChat
//
//  Created by amandahar on 7/10/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

NS_ASSUME_NONNULL_END
