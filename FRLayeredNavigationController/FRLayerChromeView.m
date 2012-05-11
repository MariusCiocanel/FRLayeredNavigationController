/*     This file is part of FRLayeredNavigationController.
 *
 * FRLayeredNavigationController is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * FRLayeredNavigationController is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with FRLayeredNavigationController.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 *  Copyright (c) 2012, Johannes Weiß <weiss@tux4u.de> for factis research GmbH.
 */

#import "FRLayerChromeView.h"

@interface FRLayerChromeView ()

@end

@implementation FRLayerChromeView

-(id)initWithFrame:(CGRect)frame titleView:(UIView *)titleView title:(NSString *)titleText
{
    self = [super initWithFrame:frame];
    if (self) {
        self->_savedGradient = nil;
        self.backgroundColor = [UIColor clearColor];
        
        if (titleView == nil) {
            UILabel *titleLabel = [[UILabel alloc] init];
            
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = titleText;
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:20.5];
            titleLabel.shadowColor = [UIColor whiteColor];
            titleLabel.textColor = [UIColor colorWithRed:111.0f/255.0f
                                                   green:118.0f/255.0f
                                                    blue:126.0f/255.0f
                                                   alpha:1.0f];

            [self addSubview:titleLabel];
        } else {
            [self addSubview:titleView];
        }
    }
    return self;
}

- (void)dealloc {
    CGGradientRelease(self->_savedGradient);
    self->_savedGradient = NULL;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleFrameMax = CGRectMake(5,
                                   0, 
                                   self.bounds.size.width-10,
                                   self.bounds.size.height);
    UIView *titleView = [self.subviews objectAtIndex:0];

    CGSize titleFittingSize = [titleView sizeThatFits:titleFrameMax.size];
    CGRect titleFrame = CGRectMake(MAX((titleFrameMax.size.width - titleFittingSize.width)/2, titleFrameMax.origin.x),
                                   MAX((titleFrameMax.size.height - titleFittingSize.height)/2, titleFrameMax.origin.y),
                                   MIN(titleFittingSize.width, titleFrameMax.size.width),
                                   MIN(titleFittingSize.height, titleFrameMax.size.height));        
    
    titleView.frame = titleFrame;
}

- (CGGradientRef)gradient {
    if (NULL == _savedGradient) {
        CGFloat colors[12] = {
            244.0/255.0, 245.0/255.0, 247.0/255.0, 1.0,
            223.0/255.0, 225.0/255.0, 230.0/255.0, 1.0,
            167.0/244.0, 171.0/255.0, 184.0/255.0, 1.0,
        };
        CGFloat locations[3] = { 0.05f, 0.45f, 0.95f };
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        _savedGradient = CGGradientCreateWithColorComponents(colorSpace,
                                                             colors,
                                                             locations,
                                                             3);
        
        CGColorSpaceRelease(colorSpace);
    }
    
    return _savedGradient;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    [path addClip];
    
    CGPoint start = CGPointMake(CGRectGetMidX(self.bounds), 0);
    CGPoint end = CGPointMake(CGRectGetMidX(self.bounds),
                              CGRectGetMaxY(self.bounds));
    
    CGGradientRef gradient = [self gradient];
    
    CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
}

@end