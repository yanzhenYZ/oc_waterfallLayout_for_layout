//
//  YZWaterfallLayout.h
//
//  Created by yanzhen.
//

#import "YZWaterfallLayout.h"

@interface YZWaterfallLayout ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *maxYDict;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@end

@implementation YZWaterfallLayout
+(instancetype)layoutWithColumnCount:(NSInteger)count
{
    return [[self alloc] initWithColumnCount:count];
}

- (instancetype)initWithColumnCount:(NSInteger)count
{
    self = [super init];
    if (self) {
        _maxYDict = [NSMutableDictionary dictionaryWithCapacity:count];
        _attributesArray = [NSMutableArray array];
        _columnCount = count;
    }
    return self;
}

#pragma mark - UICollectionViewLayout
-(void)prepareLayout
{
    [super prepareLayout];
    for (int i = 0; i < self.columnCount; i++) {
        self.maxYDict[@(i)] = @(self.sectionInset.top);
    }
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    [self.attributesArray removeAllObjects];
    //save attributes
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //for real
//    CGFloat itemWidth = (collectionViewWidth - _sectionInset.left - _sectionInset.right - (_columnCount - 1) * _minimumLineSpacing) / _columnCount;
    
    CGSize itemSize = CGSizeMake(0, 0);
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
        itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [_maxYDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (self.maxYDict[minIndex].floatValue > obj.floatValue) {
            minIndex = key;
        }
    }];
    //根据最短列的列数计算item的x值
    CGFloat itemX = _sectionInset.left + (self.minimumLineSpacing + itemSize.width) * minIndex.integerValue;
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = self.maxYDict[minIndex].floatValue + self.minimumInteritemSpacing;
    attributes.frame = CGRectMake(itemX, itemY, itemSize.width, itemSize.height);
    self.maxYDict[minIndex] = @(CGRectGetMaxY(attributes.frame));
    return attributes;
}

- (CGSize)collectionViewContentSize {
    __block NSNumber *maxIndex = @0;
    [_maxYDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([self.maxYDict[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    return CGSizeMake(0, self.maxYDict[maxIndex].floatValue + self.sectionInset.bottom);
}

//返回rect范围内item的attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attributesArray;
}
@end
