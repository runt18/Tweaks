//
//  _FBTweakColorViewControllerHexDataSource.m
//  FBTweak
//
//  Created by Callum Boddy on 25/02/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "_FBTweakColorViewControllerHexDataSource.h"
#import "_FBTweakTableViewCell.h"
#import "FBTweak.h"

@interface _FBTweakColorViewControllerHexDataSource () <FBTweakObserver>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) FBTweak *tweak;

@end

@implementation _FBTweakColorViewControllerHexDataSource {
  UITableViewCell *_colorSampleCell;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _colorSampleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  }
  return self;
}

- (void)dealloc
{
  [self.tweak removeObserver:self];
}

- (UIColor *)value
{
  return self.color;
}

- (void)setValue:(UIColor *)value
{
  _color = value;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    _colorSampleCell.backgroundColor = self.value;
    return _colorSampleCell;
  }
  return [self hexCell];
}

- (_FBTweakTableViewCell *)hexCell
{
  _FBTweakTableViewCell *hexCell = [[_FBTweakTableViewCell alloc] initWithReuseIdentifier:@"hexCell"];
  self.tweak = [[FBTweak alloc] initWithIdentifier:@"hex"];
  self.tweak.name = @"Hex Value";
  self.tweak.defaultValue = @"FFFFFF";
  self.tweak.currentValue = [self.class colorToHexString:self.color];
  [self.tweak addObserver:self];
  hexCell.tweak = self.tweak;
  return hexCell;
}

- (void)tweakDidChange:(FBTweak *)tweak
{
  UIColor *colorFromHex = [self.class colorFromHexString:tweak.currentValue];
  [self setValue:colorFromHex];
  _colorSampleCell.backgroundColor = colorFromHex;
}

#pragma mark - hex colour converters

+ (NSString *)colorToHexString:(UIColor *)uiColor
{
  CGFloat red,green,blue,alpha;
  [uiColor getRed:&red green:&green blue:&blue alpha:&alpha];
  red = roundf(red*255);
  green = roundf(green*255);
  blue = round(blue*255);
  NSString *hexString  = [NSString stringWithFormat:@"#%02x%02x%02x", ((int)red),((int)green),((int)blue)];
  return hexString.uppercaseString;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
