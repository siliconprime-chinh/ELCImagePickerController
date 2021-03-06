//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCConsole.h"
#import "ELCOverlayImageView.h"
#import "UIImage+Color.h"

@interface ELCAssetCell ()

@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;
@property (nonatomic, strong) NSMutableArray *statusViewArray;

@end

@implementation ELCAssetCell

//Using auto synthesizers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;
        
        NSMutableArray *statusViewArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.statusViewArray = statusViewArray;
        
        self.alignmentLeft = YES;
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (ELCOverlayImageView *view in _overlayViewArray) {
        [view removeFromSuperview];
	}
    for (UIButton *button in _statusViewArray) {
        [button removeFromSuperview];
    }
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
    UIImage *overlayImage = nil;
    for (int i = 0; i < [_rowAssets count]; ++i) {

        ELCAsset *asset = [_rowAssets objectAtIndex:i];

        if (i < [_imageViewArray count]) {
            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
            [_imageViewArray addObject:imageView];
        }
        
        if (i < [_overlayViewArray count]) {
            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = asset.selected ? NO : YES;
//            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
        } else {
            if (overlayImage == nil) {
//                overlayImage = [UIImage imageNamed:@"icon_photo_choice"];
                overlayImage = [UIImage imageWithColor:COLOR_RGBA(255,255,255,0.2)];
            }
            ELCOverlayImageView *overlayView = [[ELCOverlayImageView alloc] initWithImage:overlayImage];
            [_overlayViewArray addObject:overlayView];
            overlayView.hidden = asset.selected ? NO : YES;
//            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
        }
        if (i < [_statusViewArray count]) {
            UIButton *statusBUtton = [_statusViewArray objectAtIndex:i];
            statusBUtton.selected = asset.selected ? YES : NO;
//            statusBUtton.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
        } else {
//            if (statusBUtton == nil) {
//                overlayImage = [UIImage imageNamed:@"icon_photo_choice"];
//            }
            UIButton *statusBUtton = [[UIButton alloc] init];
            [_statusViewArray addObject:statusBUtton];
            statusBUtton.tag = i;
            [statusBUtton addTarget:self action:@selector(statusButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [statusBUtton setImage:[UIImage imageNamed:@"icon_photo_choice_nomal"] forState:UIControlStateNormal];
            [statusBUtton setImage:[UIImage imageNamed:@"icon_photo_choice"] forState:UIControlStateSelected];
            statusBUtton.selected = asset.selected ? YES : NO;
        }
    }
}

- (void)statusButtonPress:(UIButton *)sender {
    NSInteger i = sender.tag;
    ELCAsset *asset = [_rowAssets objectAtIndex:i];
    asset.selected = !asset.selected;
    ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
    overlayView.hidden = !asset.selected; //替换图片之后打开
    sender.selected = asset.selected;
    if (asset.selected) {
        asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
        [overlayView setIndex:asset.index+1];
        [[ELCConsole mainConsole] addIndex:asset.index];
    }
    else
    {
        int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
        [[ELCConsole mainConsole] removeIndex:lastElement];
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    NSInteger cellWidth = ([UIScreen mainScreen].bounds.size.width - 5) / 4 - 5;
    CGPoint point = [tapRecognizer locationInView:self];
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * cellWidth + (c - 1) * 4;
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = 5;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startX, 2, cellWidth, cellWidth);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
//            ELCAsset *asset = [_rowAssets objectAtIndex:i];
//            asset.selected = !asset.selected;
//            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
//            overlayView.hidden = !asset.selected;
//            if (asset.selected) {
//                asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
////                [overlayView setIndex:asset.index+1];
//                [[ELCConsole mainConsole] addIndex:asset.index];
//            }
//            else
//            {
//                int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
//                [[ELCConsole mainConsole] removeIndex:lastElement];
//            }
            
            [self.cellSelectDelegate cellSelectedOncellIndex:self.tag index:i];
            
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 5;
    }
}

- (void)layoutSubviews
{
    NSInteger cellWidth = ([UIScreen mainScreen].bounds.size.width - 5) / 4 - 5;

    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * cellWidth + (c - 1) * 4;
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = 5;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startX, 2, cellWidth, cellWidth);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];
        
        ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
        [overlayView setFrame:frame];
        [self addSubview:overlayView];
        
        UIButton *statusBUtton = [_statusViewArray objectAtIndex:i];
        CGRect statusFrame = CGRectMake(frame.origin.x + cellWidth - 36, frame.origin.y, 36, 36);
        statusBUtton.frame = statusFrame;
        [self addSubview:statusBUtton];
        
		frame.origin.x = frame.origin.x + frame.size.width + 5;
	}
}


@end
