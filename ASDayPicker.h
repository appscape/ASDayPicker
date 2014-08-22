//
// ASDayPicker
// http://github.com/appscape/ASDayPicker
//
// Copyright (c) 2014 appscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDayPicker : UIView

// Represents the currently selected date. KVO observable.
@property (nonatomic, readonly) NSDate *selectedDate;

// Custom titles for weekday names, starting with Monday.
// If not set, weekday names from system language will be used.
@property (nonatomic, strong) NSArray *weekdayTitles;

// Current picker range.
@property (nonatomic, readonly) NSDate *startDate, *endDate;
// Sets the picker range. Supply nil to allow going infinitely into past/future (default).
- (void)setStartDate:(NSDate *)date endDate:(NSDate *)endDate;


#pragma mark - Appearance customization

@property (nonatomic, strong) UIColor *weekdayColor;
@property (nonatomic, strong) UIFont *weekdayFont;

@property (nonatomic, strong) UIColor *dateColor;
@property (nonatomic, strong) UIFont *dateFont;

@property (nonatomic, strong) UIImage *selectedDateBackgroundImage;
@property (nonatomic, strong) UIColor *selectedDateColor;

@end
