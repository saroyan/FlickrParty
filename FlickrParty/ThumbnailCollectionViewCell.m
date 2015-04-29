//
//  ThumbnailCollectionViewCell.m
//  FlickrParty
//
//  Created by Artak A. Saroyan on 4/29/15.
//  Copyright (c) 2015 Artak A. Saroyan. All rights reserved.
//

#import "ThumbnailCollectionViewCell.h"


@interface ThumbnailCollectionViewCell ()
@property (nonatomic, strong) UIImageView *thumbView;
@end

@implementation ThumbnailCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)setThumbURL:(NSURL *)thumbURL
{
    _thumbURL = thumbURL;
    if (_thumbURL) {
    }

}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _thumbView.image = nil;
}

@end
