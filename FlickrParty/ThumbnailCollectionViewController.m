//
//  ThumbnailCollectionViewController.m
//  FlickrParty
//
//  Created by Artak A. Saroyan on 4/29/15.
//  Copyright (c) 2015 Artak A. Saroyan. All rights reserved.
//

#import "ThumbnailCollectionViewController.h"
#import "FlickrKit.h"
#import "ThumbnailCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ImageViewController.h"

@interface ThumbnailCollectionViewController ()
@property (nonatomic, retain) NSArray *photoURLs;
@end

@implementation ThumbnailCollectionViewController

static NSString * const reuseIdentifier = @"FlickrPhotoCell";
static NSString * const flickrSearch = @"Party";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Flickr Party";
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = flickrSearch;
    search.per_page = @"150";
    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                NSMutableArray *photoURLs = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                    NSURL *thumbUrl = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeThumbnail100 fromPhotoDictionary:photoDictionary];
                    NSURL *largeUrl = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeMedium800 fromPhotoDictionary:photoDictionary];
                    NSString *imageTitle = [photoDictionary objectForKey:@"title"];
                    
                    [photoURLs addObject:@[thumbUrl, largeUrl, imageTitle]]; // each element is an array tripple - Thumbnail URL, Original URL, Image Title
                }
                self.photoURLs = [NSArray arrayWithArray:photoURLs];
                [self.collectionView reloadData];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoURLs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSURL *thumbURL = [[self.photoURLs objectAtIndex:indexPath.row] objectAtIndex:0]; // first element of the photos
    UIImageView *thumbView = (UIImageView *)[cell.contentView viewWithTag:100];
    if (!thumbView) {
        thumbView = [[UIImageView alloc] initWithFrame:cell.bounds];
        thumbView.clipsToBounds = YES;
        thumbView.contentMode = UIViewContentModeScaleAspectFill;
        thumbView.backgroundColor = [UIColor whiteColor];
        thumbView.tag = 100;
        [cell.contentView addSubview:thumbView];
    }

    [thumbView sd_setImageWithURL:thumbURL]; // cached loading with SDWebImage framework

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup the viewer controller
    NSURL *photoURL = [[self.photoURLs objectAtIndex:indexPath.row] objectAtIndex:1];
    NSString *imageTitle = [[self.photoURLs objectAtIndex:indexPath.row] objectAtIndex:2];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageViewController *imageViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
    imageViewController.title = imageTitle;
    imageViewController.photoURLs = self.photoURLs;
    imageViewController.photoURL = photoURL;
    imageViewController.currentImageRow = indexPath.row;
    
    [self.navigationController pushViewController:imageViewController animated:YES];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
