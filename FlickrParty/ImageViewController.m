//
//  ImageViewController.m
//  FlickrParty
//
//  Created by Artak A. Saroyan on 4/29/15.
//  Copyright (c) 2015 Artak A. Saroyan. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+WebCache.h"

@interface ImageViewController () {
    NSInteger previousSelectedRow; // needed to deselect the cell
}
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, weak) IBOutlet UICollectionView *thumbCollectionView;
@end

@implementation ImageViewController
static NSString * const reuseIdentifier = @"ThumbCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Register cell classes
    [self.thumbCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.photoView sd_setImageWithURL:self.photoURL];
    
    previousSelectedRow = self.currentImageRow;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self positionThumbsCollectionView];
}

- (void)positionThumbsCollectionView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentImageRow inSection:0];
    
    // scrolling here does work
    [self.thumbCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.thumbCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self lowlightSelectedCell:[self.thumbCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousSelectedRow inSection:0]]];
    [self highlightSelectedCell:[self.thumbCollectionView cellForItemAtIndexPath:indexPath]];
    previousSelectedRow = self.currentImageRow;
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

#pragma mark thumbnailCollectionView methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.photoURLs count];
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
    
    // configure selection highlight
    if (self.currentImageRow == indexPath.row) {
        thumbView.layer.borderWidth = 1.0;
        thumbView.layer.borderColor = [[UIColor yellowColor] CGColor];
    } else {
        thumbView.layer.borderWidth = 0.0;
        thumbView.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    [thumbView sd_setImageWithURL:thumbURL]; // cached loading with SDWebImage framework
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    self.currentImageRow = indexPath.row;
    self.photoURL = [[self.photoURLs objectAtIndex:indexPath.row] objectAtIndex:1];
    [self.photoView sd_setImageWithURL:self.photoURL];
    self.title = [[self.photoURLs objectAtIndex:indexPath.row] objectAtIndex:2];
    [self positionThumbsCollectionView];
}

#pragma mark image taps/swipes handling
- (IBAction)imageTap:(id)sender
{
    if (self.thumbCollectionView.alpha == 0) {
        [self fadeInThumbs];
    } else {
        [self fadeOutThumbs];
    }
}

- (void)fadeInThumbs
{
    [self.thumbCollectionView setAlpha:0];
    [UILabel beginAnimations:NULL context:nil];
    [UILabel setAnimationDuration:0.5];
    [self.thumbCollectionView setAlpha:1];
    [UILabel commitAnimations ];
}

- (void)fadeOutThumbs
{
    [UILabel beginAnimations:NULL context:nil];
    [UILabel setAnimationDuration:0.5];
    [self.thumbCollectionView setAlpha:0];
    [UILabel commitAnimations];
}

- (IBAction)swipeRight:(id)sender
{
    if (self.currentImageRow > 0) {
        self.currentImageRow --;
    }
    
    self.photoURL = [[self.photoURLs objectAtIndex:self.currentImageRow] objectAtIndex:1];
    [self.photoView sd_setImageWithURL:self.photoURL];
    self.title = [[self.photoURLs objectAtIndex:self.currentImageRow] objectAtIndex:2];

    [self positionThumbsCollectionView];
}

- (IBAction)swipeLeft:(id)sender
{
    if (self.currentImageRow < [self.photoURLs count] - 1) {
        self.currentImageRow ++;
    }
    
    self.photoURL = [[self.photoURLs objectAtIndex:self.currentImageRow] objectAtIndex:1];
    [self.photoView sd_setImageWithURL:self.photoURL];
    self.title = [[self.photoURLs objectAtIndex:self.currentImageRow] objectAtIndex:2];
    
    [self positionThumbsCollectionView];
}

- (void)highlightSelectedCell:(UICollectionViewCell *)cell
{
    UIImageView *thumbView = (UIImageView *)[cell.contentView viewWithTag:100];
    thumbView.layer.borderWidth = 1.0;
    thumbView.layer.borderColor = [[UIColor yellowColor] CGColor];
}

- (void)lowlightSelectedCell:(UICollectionViewCell *)cell
{
    UIImageView *thumbView = (UIImageView *)[cell.contentView viewWithTag:100];
    thumbView.layer.borderWidth = 0.0;
    thumbView.layer.borderColor = [[UIColor clearColor] CGColor];
}

@end
