//
//  ChooserViewController.m
//  MonocleMe
//
//  Created by Scott on 11/11/15.
//  Copyright © 2015 Monoclebot LLC. All rights reserved.
//

#import "ChooserViewController.h"
#import "MonocleEditorViewController.h"
#import "NSString+FontAwesome.h"
@import Photos;

@interface ChooserViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *thumbnailImages;
@property (nonatomic, strong) NSArray *imageAssets;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic) CGFloat thumbnailDimension;

@end

@implementation ChooserViewController

int imagesPerRow = 4;
int itemPadding = 1;

- (void)viewDidLoad {
    [self setup];
}

- (void)setup {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.thumbnailDimension = (screenSize.width - imagesPerRow * itemPadding)/ imagesPerRow;
    [self loadImages];
   
    [self.cameraButton setTitle:[NSString fontAwesomeIconStringForEnum:FACameraRetro] forState:UIControlStateNormal];
}

- (void)loadImages {
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    PHAssetCollection *assetCollection = [fetchResult firstObject];
    fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *assets = [NSMutableArray new];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    CGSize targetSize = CGSizeMake(self.thumbnailDimension * 2, self.thumbnailDimension * 2);
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageManager requestImageForAsset:obj targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                [images addObject:result];
                [assets addObject:obj];
            }
        }];
    }];
    self.imageAssets = assets;
    self.thumbnailImages = images;
}

#pragma mark - collection view delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.thumbnailImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:1];
    [imageView setImage:self.thumbnailImages[indexPath.row]];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.imageAssets[indexPath.row];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageManager *imageManager = [[PHImageManager alloc] init];
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                self.selectedImage = result;
                [self performSegueWithIdentifier:@"showEditor" sender:self];
            }
        }];
}

#pragma mark - image picker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.selectedImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"showEditor" sender:self];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MonocleEditorViewController class]]) {
        MonocleEditorViewController *monocleVC = (MonocleEditorViewController *)segue.destinationViewController;
        monocleVC.image = self.selectedImage;
    }
    
}

#pragma mark - actions

- (IBAction)cameraButtonTouchUpInside:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"camera");
        }];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Camera Available" message:@"this device does not have a camera" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
