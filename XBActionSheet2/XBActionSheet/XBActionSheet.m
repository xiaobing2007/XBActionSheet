//
//  XBActionSheet.m
//  XBActionSheet
//
//  Created by aimee on 16/8/29.
//  Copyright © 2016年 libing. All rights reserved.
//
#define kNormalCellH 55
#define kLRBMargin 15
#define kAnimationTime 0.3
#define kNormalCol [UIColor colorWithRed:48 / 255.0 green:131 / 255.0 blue:251 /255.0 alpha:1]
#import "XBActionSheet.h"
#import <Masonry.h>

@interface XBCellModel : NSObject
/** text */
@property (nonatomic, copy) NSString *text;
/** textColor */
@property (nonatomic, strong)UIColor *textColor;
/** textFont */
@property (nonatomic, strong)UIFont *textFont;
/** backGroundColor */
@property (nonatomic, strong)UIColor *backGroundColor;
/** userInteractionEnabled */
@property (nonatomic, assign) BOOL userInteractionEnabled;

@end
@implementation XBCellModel

+ (instancetype)ModelWithText:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)textFont backGroundColor:(UIColor *)backGroundColor userInteractionEnabled:(BOOL)userInteractionEnabled
{
    XBCellModel *model = [XBCellModel new];
    model.text = text;
    model.textColor = textColor;
    model.textFont = textFont;
    model.backGroundColor = backGroundColor;
    model.userInteractionEnabled = userInteractionEnabled;
    return model;
}
@end

@interface XBActionCell : UITableViewCell
/** 按钮 */
@property (nonatomic, weak) UILabel *otherTitle_L;
/** 分割线 */
@property (nonatomic, weak)UIView *devide;
/** 模型 */
@property (nonatomic, strong)XBCellModel *cellModel;
@end
@implementation XBActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //中间描述文字
        UILabel *otherTitle_L = [[UILabel alloc] init];
        otherTitle_L.textAlignment  = NSTextAlignmentCenter;
        otherTitle_L.textColor = kNormalCol;
        self.otherTitle_L = otherTitle_L;
        [self.contentView addSubview:otherTitle_L];
        
        //分割线
        UIView *devide = [[UIView alloc] init];
        self.devide = devide;
        devide.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:devide];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.otherTitle_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@(kNormalCellH - 0.5));
    }];
    [self.devide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
}

- (void)setCellModel:(XBCellModel *)cellModel
{
    _cellModel = cellModel;
    self.otherTitle_L.text = cellModel.text;
    self.otherTitle_L.font = cellModel.textFont;
    self.otherTitle_L.textColor = cellModel.textColor;
    self.otherTitle_L.backgroundColor = cellModel.backGroundColor;
    self.userInteractionEnabled = cellModel.userInteractionEnabled;
}
@end

@interface XBActionSheet()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_otherBtnTitles;
    NSString *_title;
    NSString *_cancelBtn; //取消字符串
    NSString *_destructiveBtn; //删除字符串
    UIView *_coverView; //阴影
}
/** 回调block */
@property (nonatomic, copy) void (^clickIndex)(NSUInteger index);
/** 取消按钮 */
@property (nonatomic, weak)UIButton *cancel_B;
/** tableview */
@property (nonatomic, weak)UITableView *tableView;
/** 模型数组 */
@property (nonatomic, strong)NSMutableArray *cellDatas;
@end
@implementation XBActionSheet
#pragma mark - LazyLoad
- (NSMutableArray *)cellDatas
{
    if (!_cellDatas) {
        _cellDatas = [[NSMutableArray alloc] initWithCapacity:_otherBtnTitles.count];
        for (int i = 0; i < _otherBtnTitles.count; i++) {
            XBCellModel *model = [XBCellModel ModelWithText:_otherBtnTitles[i] textColor:kNormalCol textFont:nil backGroundColor:nil userInteractionEnabled:YES];
            if (_title.length) {
                if (i == 0) {
                    model.textColor = [UIColor grayColor];
                    model.userInteractionEnabled = NO;
                }
                if (_destructiveBtn.length) {
                    if (i == 1) {
                        model.textColor = [UIColor redColor];
                    }
                }
            }else{
                if (_destructiveBtn.length) {
                    if (i == 0) {
                        model.textColor = [UIColor redColor];
                    }
                }
            }
            [_cellDatas addObject:model];
        }
        
    }
    return _cellDatas;
}


- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelBtn
       destructiveButtonTitle:(NSString *)destructiveBtn
            otherButtonTitles:(NSArray *)otherButtonTitles
               clickIndexBack:(void (^)(NSUInteger index))clickIndex
{
    self.clickIndex = clickIndex;
    _cancelBtn = cancelBtn ? cancelBtn : @"取消";
    _destructiveBtn = destructiveBtn;
    _title = title;
    
    if (destructiveBtn.length) {
        _otherBtnTitles = [NSMutableArray arrayWithArray:otherButtonTitles];
        [_otherBtnTitles insertObject:destructiveBtn atIndex:0];
    }else{
        _otherBtnTitles = [NSMutableArray arrayWithArray:otherButtonTitles];
    }
    if (title.length) {
        [_otherBtnTitles insertObject:title atIndex:0];
    }
    
    [self cellDatas];
    
    if (self = [super initWithFrame:CGRectMake(kLRBMargin, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 2 * kLRBMargin , (_otherBtnTitles.count + 1) * kNormalCellH + kLRBMargin)]) {
        
        UIButton *cancleB = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancel_B = cancleB;
        [self addSubview:cancleB];
        cancleB.layer.cornerRadius = 10;
        [cancleB setTitle:_cancelBtn forState:UIControlStateNormal];
        cancleB.backgroundColor = [UIColor whiteColor];
        [cancleB addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [cancleB setTitleColor:kNormalCol forState:UIControlStateNormal];
        [cancleB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@kNormalCellH);
        }];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView = tableView;
        [tableView registerClass:[XBActionCell class] forCellReuseIdentifier:@"identify"];
        tableView.layer.cornerRadius = 10;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollEnabled = NO;
        [self addSubview:tableView];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = kNormalCellH;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(kNormalCellH * _otherBtnTitles.count));
        }];
    }
    
    return self;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBActionCell *cell = [[XBActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
    cell.cellModel = self.cellDatas[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hide];
    
    if (self.clickIndex) {
        if (_title.length > 0) {
            self.clickIndex(indexPath.row - 1);
        }else{
            self.clickIndex(indexPath.row);
        }
    }
}

#pragma mark - 自定义方法
- (void)show
{
    
    CGRect rect = self.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - ((_otherBtnTitles.count + 1) * kNormalCellH + 2 * kLRBMargin);
    
    _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [UIColor grayColor];
    _coverView.alpha = 0;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_coverView addGestureRecognizer:tapGes];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        _coverView.alpha = 0.5;
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide
{
    CGRect rect = CGRectMake(kLRBMargin, [UIScreen mainScreen].bounds.size.height + 30, [UIScreen mainScreen].bounds.size.width - 2 * kLRBMargin , (_otherBtnTitles.count + 1) * kNormalCellH + kLRBMargin);
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        _coverView.alpha = 0;
        self.frame = rect;
    } completion:^(BOOL finished) {
        [_coverView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIButton *)getCancelBtn
{
    return self.cancel_B;
}
- (void)setTitleStringFont:(UIFont *)font color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor
{
    if (_title.length <= 0) return;
    XBCellModel *model = self.cellDatas[0];
    model.textFont = font;
    model.textColor = color;
    model.backGroundColor = backGroundColor;
    
}
- (void)setDestructiveStringFont:(UIFont *)font color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor
{
    if (_destructiveBtn.length <= 0) return;
    XBCellModel *model;
    if (_title.length) {
        model = self.cellDatas[1];
    }else{
        model = self.cellDatas[0];
    }
    model.textFont = font;
    model.textColor = color;
    model.backGroundColor = backGroundColor;
    
}
- (void)setOtherButtonTitlesStringFont:(UIFont *)font color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor
{
    for (int i = 0; i < self.cellDatas.count; i++) {
        if (_title.length && _destructiveBtn.length) {
            if (i > 1) {
                XBCellModel *model = self.cellDatas[i];
                model.textFont = font;
                model.textColor = color;
                model.backGroundColor = backGroundColor;
            }
        }else if ((_title.length > 0 && _destructiveBtn.length <= 0) || (_title.length <= 0 && _destructiveBtn.length > 0) ){
            if (i > 0) {
                XBCellModel *model = self.cellDatas[i];
                model.textFont = font;
                model.textColor = color;
                model.backGroundColor = backGroundColor;
            }
            
        }else{
            XBCellModel *model = self.cellDatas[i];
            model.textFont = font;
            model.textColor = color;
            model.backGroundColor = backGroundColor;
        }
    }
}

@end
