//
//  ChooserViewController.m
//  MonocleMe
//
//  Created by Scott on 11/11/15.
//  Copyright © 2015 Monoclebot LLC. All rights reserved.
//

#import "ChooserViewController.h"
@import Photos;

@interface ChooserViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) CGFloat thumbnailDimension;

@end

@implementation ChooserViewController

int imagesPerRow = 4;
int itemPadding = 1;

- (void)viewDidLoad {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.thumbnailDimension = (screenSize.width - imagesPerRow * itemPadding)/ imagesPerRow;
    [self loadImages];
}

- (void)loadImages {
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    PHAssetCollection *assetCollection = [fetchResult firstObject];
    fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    NSMutableArray *images = [NSMutableArray new];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    CGSize targetSize = CGSizeMake(self.thumbnailDimension * 2, self.thumbnailDimension * 2);
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageManager requestImageForAsset:obj targetSize:targetSize contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [images addObject:result];
        }];
    }];
    self.photos = images;
}

#pragma mark - collection view delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:1];
    [imageView setImage:self.photos[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.thumbnailDimension, self.thumbnailDimension);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return itemPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return itemPadding;
}

@end
