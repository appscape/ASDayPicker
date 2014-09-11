//
// ASDayPicker
// http://github.com/appscape/ASDayPicker
//
// Copyright (c) 2014 appscape. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ASDayPicker : UIView

// Represents the currently selected date. KVO observable.
@property (nonatomic, strong) NSDate *selectedDate;

// Custom titles for weekday names, starting with Monday.
// If not set, weekday names from system language with length 1 will be used.
// See also +weekdayTitlesWithLocaleIdentifier:length:uppercase:
@property (nonatomic, strong) NSArray *weekdayTitles;

// Current picker range.
@property (nonatomic, readonly) NSDate *startDate, *endDate;
// Sets the picker range. Supply nil to allow going infinitely into past/future (default).
- (void)setStartDate:(NSDate *)date endDate:(NSDate *)endDate;

// The weekday of currently selected date. 0-monday.
@property (nonatomic, readonly) NSUInteger selectedWeekday;

#pragma mark - Appearance customization

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, strong) UIColor *weekdayTextColor;
@property (nonatomic, strong) UIFont *weekdayFont;

@property (nonatomic, strong) UIColor *selectedWeekdayTextColor;

@property (nonatomic, strong) UIColor *dateTextColor;
@property (nonatomic, strong) UIFont *dateFont;

// Color of the date which is out of range set in setStartDate:endDate:
@property (nonatomic, strong) UIColor *outOfRangeDateTextColor;

@property (nonatomic, strong) UIImage *selectedDateBackgroundImage;

// This will generate a rectangular background in specified color to be used
// for selected dates.
@property (nonatomic, strong) UIColor *selectedDateBackgroundColor;

// If set, the selectedDataBackgroundImage/Color will be rendered in the rectangle for the whole day
// (incl. weekday name). If not set (default), background will be applied only to the date part (a button itself).
@property (nonatomic, assign) BOOL selectedDateBackgroundExtendsToTop;

@property (nonatomic, strong) UIColor *selectedDateTextColor;

#pragma mark - Helpers

// Returns weekday names truncated to specified length.
// Supply nil for localeIdentifier to use the system language.
+ (NSArray*)weekdayTitlesWithLocaleIdentifier:(NSString*)localeIdentifier length:(NSUInteger)length uppercase:(BOOL)uppercase;

@end
