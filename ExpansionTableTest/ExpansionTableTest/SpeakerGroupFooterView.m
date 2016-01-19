//
//  SpeakerGroupFooterView.m
//  ExpansionTableTest
//
//  Created by besDigital on 16/1/16.
//  Copyright © 2016年 besniba. All rights reserved.
//

#import "SpeakerGroupFooterView.h"

#define BesColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

@implementation SpeakerGroupFooterView
@synthesize showSpeakerlistBtn;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor =  BesColor(52, 53, 54);
        
        [self besLoadUIView];
    }
    
    return self;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {

    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = BesColor(52, 53, 54);
        
        [self besLoadUIView];
    }
    
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.showSpeakerlistBtn.frame = CGRectMake(0,
                                               0,
                                               CGRectGetWidth(self.frame),
                                               CGRectGetHeight(self.frame));

}

- (void)besLoadUIView {

    self.showSpeakerlistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.showSpeakerlistBtn setBackgroundColor:[UIColor clearColor]];
    [self.showSpeakerlistBtn setBackgroundImage:[self besImageWithColor:BesColor(52, 53, 54)]
                       forState:UIControlStateNormal];
    [self.showSpeakerlistBtn setBackgroundImage:[self besImageWithColor:BesColor(62, 63, 64)]
                       forState:UIControlStateHighlighted];
    
    UIImage *image = [UIImage imageNamed:@"icon-list-arrow-up"];

    [self.showSpeakerlistBtn setImage:image forState:UIControlStateNormal];
    [self.showSpeakerlistBtn.imageView setContentMode:UIViewContentModeCenter];
    [self.showSpeakerlistBtn.imageView setClipsToBounds:NO];

    [self.contentView addSubview:self.showSpeakerlistBtn];
    
}


- (UIImage *)besImageWithColor:(UIColor *)color
{
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
