//
//  ViewController.m
//  YZWaterfallLayout
//
//  Created by yanzhen on 2018/1/19.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

#import "ViewController.h"
#import "YZWaterfallCell.h"
#import "YZWaterfallLayout.h"
#import "YZImageObj.h"
#import <UIImageView+WebCache.h>

static NSString *const CellIdentifier = @"YZWaterfallCell";
static NSInteger const ColumnCount = 3;

@interface ViewController ()<UICollectionViewDataSource, YZWaterfallLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<YZImageObj *> *imageObjs;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UICollectionViewFlowLayout
    YZWaterfallLayout *layout = [YZWaterfallLayout layoutWithColumnCount:ColumnCount];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.delegate = self;
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
    NSArray<NSDictionary *> *images = [NSArray arrayWithContentsOfFile:path];
    __block NSMutableArray *imageObjs = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YZImageObj *imageObj = [[YZImageObj alloc] init];
        [imageObj setValuesForKeysWithDictionary:obj];
        [imageObjs addObject:imageObj];
    }];
    _imageObjs = [NSMutableArray arrayWithArray:imageObjs];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"--- %s ---",__func__);
        [_imageObjs removeLastObject];
        [_imageObjs removeLastObject];
        [_imageObjs removeLastObject];
        [_imageObjs removeLastObject];
        [_imageObjs removeLastObject];
        [_imageObjs removeLastObject];
        [self.collectionView reloadData];
    });
}

#pragma mark - collectionView
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(YZWaterfallLayout *)waterfallLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZImageObj *obj = _imageObjs[indexPath.row];
    CGFloat width = (collectionView.bounds.size.width - 10 * (ColumnCount - 1)) / ColumnCount;
    return CGSizeMake(width, obj.h.floatValue / obj.w.floatValue * width);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageObjs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZWaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    YZImageObj *obj = _imageObjs[indexPath.row];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:obj.img] placeholderImage:placeholderImage];
    return cell;
}
@end
