//
//  YZWaterfallLayout.h
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

@class YZWaterfallLayout;
@protocol YZWaterfallLayoutDelegate <NSObject>

@required

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(YZWaterfallLayout *)waterfallLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YZWaterfallLayout : UICollectionViewLayout

@property (nonatomic, readonly) NSInteger columnCount;
@property (nonatomic, weak) id<YZWaterfallLayoutDelegate> delegate;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;

@property (nonatomic) UIEdgeInsets sectionInset;

+ (instancetype)layoutWithColumnCount:(NSInteger)count;

@end
