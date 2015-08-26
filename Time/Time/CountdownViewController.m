//
//  CountdownViewController.m
//  Time
//
//  Created by Kaisha Jones on 8/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "CountdownViewController.h"
#import "CountdownObject.h"
@interface CountdownViewController () {
    
    int afterRemainder;
    int remainder;
    NSTimeInterval countDownInterval;
    
}

@property (weak, nonatomic) IBOutlet UIDatePicker *CountdownPickerView;
@property (weak, nonatomic) IBOutlet UILabel *CountdownTimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *CountdownStartButton;
@property (weak, nonatomic) IBOutlet UIButton *CountdownPauseButton;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isInitialStart;

@property (nonatomic) BOOL isResumed;

@property (nonatomic) NSTimer *timer;
@property NSTimeInterval currentNumber;

@property (nonatomic)NSMutableArray *hoursArray;
@property (nonatomic)NSMutableArray *minutesArray;
@property (nonatomic)NSDateComponents *NSCalendar;
@property (nonatomic)NSDateComponents *NSHourUnitCalendar;
@property (nonatomic)UIPickerView *countDownDuration;



@end

@implementation CountdownViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.CountdownPickerView.datePickerMode = UIDatePickerModeCountDownTimer;

    self.isStart = YES;
    self.isResumed = YES;
    [self.CountdownPickerView setDate:self.countdownInfo.dateInSeconds];
    self.CountdownTimerLabel.hidden = YES;
    self.CountdownPickerView.hidden = NO;
}
    
- (void) updateCountDown {
    afterRemainder --;
    
    int hours = (int)(afterRemainder/(60*60));
    int mins = (int)(((int)afterRemainder/60) - (hours * 60));
    int secs = (int)(((int)afterRemainder - (60 *mins) - (60 * hours * 60)));
    NSString *timeDisplay = [[NSString alloc] initWithFormat:@"%02u : %02u : %02u", hours, mins, secs];
    
    self.CountdownTimerLabel.text = timeDisplay;
}


//start tapped and stop tapped
- (IBAction)CountdownStartButtonTapped:(id)sender {
    if (self.isStart) {
        countDownInterval = (NSTimeInterval)_CountdownPickerView.countDownDuration;
        remainder = countDownInterval;
        afterRemainder = countDownInterval - remainder%60;
        
        
        //change the text in start button to cancel and enable the pause button
        [self.CountdownStartButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.CountdownStartButton setTitleColor: [UIColor redColor] forState:UIControlStateNormal];
        self.CountdownPauseButton.enabled = YES;
        
        //change the value of the bool isStart bc we're at stop now
        self.isStart = NO;
        
        //create a timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDown) userInfo:nil repeats:YES];
        
        afterRemainder++;
        
        [self updateCountDown];
        
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.CountdownPickerView setHidden:YES];
        [self.CountdownTimerLabel setHidden:NO];

    }
    
    else {
        
        [self.CountdownStartButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.CountdownStartButton setTitleColor: [UIColor greenColor] forState:UIControlStateNormal];
        
        [self.CountdownPickerView setHidden: NO];
        [self.CountdownTimerLabel setHidden: YES];
        self.CountdownPauseButton.enabled = NO;
        [self.timer invalidate];
        
        self.isStart = YES;
        
    }
    
}

- (IBAction)pausedTapped:(UIButton *)sender {
    
    if (self.isResumed) {
        
        self.isResumed = NO;
        [self.timer invalidate];
        [self.CountdownPauseButton setTitle:@"Resume" forState:UIControlStateNormal];
    } else {
        self.isResumed = YES;
        
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateCountDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.CountdownPauseButton setTitle:@"Pause" forState:UIControlStateNormal];

    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
