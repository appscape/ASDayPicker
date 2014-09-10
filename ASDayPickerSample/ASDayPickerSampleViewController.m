//
// ASDayPicker
// http://github.com/appscape/ASDayPicker
//
// Copyright (c) 2014 appscape. All rights reserved.
//

#import "ASDayPickerSampleViewController.h"

@implementation ASDayPickerSampleViewController

- (void)viewDidLoad {
    // Allow picking from today until 4 weeks from now
    NSDateComponents *fourWeeks = [[NSDateComponents alloc] init];
    fourWeeks.day = 4 * 7;
    NSDate *endDate = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]dateByAddingComponents:fourWeeks toDate:[NSDate date] options:0];
    self.dayPicker.selectedDateBackgroundImage = [UIImage imageNamed:@"selection"];
    [self.dayPicker setStartDate:[NSDate date] endDate:endDate];
    [self.dayPicker addObserver:self forKeyPath:@"selectedDate" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSDate *day = change[NSKeyValueChangeNewKey];
    self.selectedDayLabel.text =  [NSDateFormatter localizedStringFromDate:day dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}
@end
