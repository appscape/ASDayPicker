//
// ASDayPicker
// http://github.com/appscape/ASDayPicker
//
// Copyright (c) 2014 appscape. All rights reserved.
//

#import "ASDayPicker.h"

static const CGFloat kHorizontalInset = 6.0f;
static const CGFloat kWeekdayLabelHeight = 20.0f;

@interface ASDayPicker()<UIScrollViewDelegate> {
    NSCalendar *_calendar;

    NSArray *_weekdayTitles;
    NSMutableArray *_weekdayLayers;

    UIScrollView *_daysScrollView;

    CGFloat _dx, _dh;
    CGFloat _scrollStartOffsetX;

    NSMutableArray *_days;
    UIButton *_lastSelectedButton;
}
@property (nonatomic, strong) NSDate *selectedDate;
@end

@implementation ASDayPicker

- (void)setup {
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    _daysScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _daysScrollView.showsHorizontalScrollIndicator = NO;
    _daysScrollView.pagingEnabled = YES;
    _daysScrollView.delegate = self;

    [self addSubview:_daysScrollView];

    _weekdayLayers = [NSMutableArray array];
    for (NSUInteger i = 0;i<7;i++) {
        CATextLayer *l = [CATextLayer layer];
        l.contentsScale = [UIScreen mainScreen].scale;
        l.foregroundColor = [UIColor blackColor].CGColor;
        l.fontSize = 12.0;
        l.alignmentMode = kCAAlignmentCenter;
        [_weekdayLayers addObject:l];
        [self.layer addSublayer:l];
    }

    _selectedDate = [self dateWithoutTimeFromDate:[NSDate date]];

    // Get weekday titles from current calendar + locale:
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]];

    NSMutableArray *wds = [NSMutableArray array];
    for (NSString *s in df.shortWeekdaySymbols) {
        [wds addObject:[s substringWithRange:NSMakeRange(0, 1)]];
    }

    // ..finally, normalize so monday is at index 0
    self.weekdayTitles = [[wds subarrayWithRange:NSMakeRange(1, 6)]
                          arrayByAddingObjectsFromArray:[wds subarrayWithRange:NSMakeRange(0,1)]];

    self.selectedDateBackgroundImage = [ASDayPicker imageWithColor:self.tintColor];
    self.selectedDateColor = [UIColor whiteColor];
    self.dateColor = [UIColor blackColor];
    self.dateFont = [UIFont systemFontOfSize:17.0f];
    self.weekdayColor = [UIColor blackColor];
}

- (void)setWeekdayColor:(UIColor *)weekdayColor {
    for (CATextLayer *l in _weekdayLayers) {
        l.foregroundColor = weekdayColor.CGColor;
    }
    _weekdayColor = weekdayColor;
}

- (void)setWeekdayTitles:(NSArray *)weekdayTitles {
    NSParameterAssert(weekdayTitles.count == 7);
    _weekdayTitles = weekdayTitles;
    for (int i=0;i<7;i++) {
        ((CATextLayer*)_weekdayLayers[i]).string = _weekdayTitles[i];
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    _dh = self.frame.size.height - kWeekdayLabelHeight;
    _daysScrollView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);

    _dx = (self.frame.size.width - (2 * kHorizontalInset)) / 7.0f;
    for (NSUInteger i=0;i<7;i++) {
        CALayer *l = _weekdayLayers[i];
        l.frame = CGRectMake(kHorizontalInset + _dx * i, 0, _dx, kWeekdayLabelHeight);
    }

    [self recenter];
}

- (UIButton*)buttonForDay:(NSDate*)day index:(NSUInteger)index {
    UIButton *b = [[UIButton alloc] init];
    [b setTitleColor:self.dateColor forState:UIControlStateNormal];
    [b setTitleColor:self.selectedDateColor forState:UIControlStateSelected];
    [b setBackgroundImage:self.selectedDateBackgroundImage forState:UIControlStateSelected];
    [b.titleLabel setFont:self.dateFont];

    b.selected = [day isEqualToDate:_selectedDate];
    b.tag = index;

    b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    b.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    NSDateComponents *components = [_calendar components:NSDayCalendarUnit fromDate:day];
    [b setTitle:[NSString stringWithFormat:@"%ld", (long)components.day] forState:UIControlStateNormal];

    [b addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    return b;
}

- (void)dayButtonPressed:(UIButton*)sender {
    _lastSelectedButton.selected = NO;
    sender.selected = YES;
    _lastSelectedButton = sender;
    self.selectedDate = _days[sender.tag];
}

- (void)recenter {
    for (UIView *v in _daysScrollView.subviews) {
        [v removeFromSuperview];
    }

    _days = [NSMutableArray array];

    NSInteger fromIndex = -1;
    NSInteger toIndex = 1;

    if (_startDate) {
        NSDateComponents *weeks = [[NSDateComponents alloc] init];
        weeks.week = -1;
        NSDate *prevDate = [_calendar dateByAddingComponents:weeks toDate:_selectedDate options:0];
        if ([prevDate compare:_startDate] == NSOrderedAscending) {
            fromIndex = 0;
        }

    }
    
    if (_endDate) {
        NSDateComponents *weeks = [[NSDateComponents alloc] init];
        weeks.week = 1;
        NSDate *nextDate = [_calendar dateByAddingComponents:weeks toDate:_selectedDate options:0];
        if ([nextDate compare:_endDate] == NSOrderedDescending) {
            toIndex = 0;
        }
    }

    for (NSInteger i=fromIndex;i<=toIndex;i++) {
        NSArray *days = [self daysForWeekAtIndex:i];
        for (NSUInteger j=0;j<days.count;j++) {
            UIButton *b = [self buttonForDay:days[j] index:_days.count];
            [_days addObject:days[j]];
            b.frame = CGRectMake(kHorizontalInset+(i-fromIndex)*self.frame.size.width+j*_dx,kWeekdayLabelHeight,_dx,_dh);
            if (b.selected) {
                _lastSelectedButton = b;
            }
            [_daysScrollView addSubview:b];
        }
    }

    NSInteger pages = (toIndex - fromIndex) + 1;

    _daysScrollView.contentSize = CGSizeMake(pages * self.frame.size.width, self.frame.size.height);

    _daysScrollView.contentOffset = CGPointMake(fromIndex != 0 ? self.frame.size.width : 0, 0);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger dir = 0;
    CGFloat dx = scrollView.contentOffset.x - _scrollStartOffsetX;
    if (dx > 0) {
        dir = 1;
    } else if (dx < 0 ){
        dir = -1;
    }

    if (dir != 0) {
        NSDateComponents *weeks = [[NSDateComponents alloc] init];
        weeks.week = dir;
        self.selectedDate = [_calendar dateByAddingComponents:weeks toDate:_selectedDate options:0];
        [self recenter];
    }

    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _scrollStartOffsetX = scrollView.contentOffset.x;
}

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSParameterAssert(!startDate || !endDate || [endDate compare:startDate] != NSOrderedAscending);
    _startDate = [self dateWithoutTimeFromDate:startDate];
    _endDate = [self dateWithoutTimeFromDate:endDate];
    [self setNeedsLayout];
}

// i=0: week containing _selectedDate, i=-1: week before, i=1 week after etc.
- (NSArray*)daysForWeekAtIndex:(NSInteger)i {
    NSDateComponents *weeks = [[NSDateComponents alloc] init];
    weeks.week = i;

    NSDate *d = [_calendar dateByAddingComponents:weeks toDate:_selectedDate options:0];

    NSDateComponents *components = [_calendar components:NSWeekdayCalendarUnit fromDate:d];
    NSInteger before = components.weekday - 2;
    if (before < 0) before = 7 + before;
    NSInteger after = 6 - before;

    NSMutableArray *result = [NSMutableArray array];

    for (NSUInteger i = before;i>0;i--) {
        NSDateComponents *days = [[NSDateComponents alloc] init];
        days.day = -1 * i;
        [result addObject:[_calendar dateByAddingComponents:days toDate:d options:0]];
    }

    [result addObject:d];

    for (NSUInteger i = 0;i<after;i++) {
        NSDateComponents *days = [[NSDateComponents alloc] init];
        days.day = i+1;
        [result addObject:[_calendar dateByAddingComponents:days toDate:d options:0]];
    }

    return result;
}

#pragma mark - Helpers

- (NSDate*)dateWithoutTimeFromDate:(NSDate*)date {
    NSDateComponents* components = [_calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    return [_calendar dateFromComponents:components];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
