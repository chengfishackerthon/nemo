//
//  FSHFishTableViewCell.h
//  nemo
//
//  Created by t on 6/15/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSHFishTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *speciesLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
