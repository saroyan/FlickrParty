//
//  ImageViewController.h
//  FlickrParty
//
//  Created by Artak A. Saroyan on 4/29/15.
//  Copyright (c) 2015 Artak A. Saroyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSArray *photoURLs;
@property (nonatomic, assign) NSInteger currentImageRow;
@end
