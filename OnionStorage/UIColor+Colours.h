// Copyright (C) 2013 by Benjamin Gordon
//
// Permission is hereby granted, free of charge, to any
// person obtaining a copy of this software and
// associated documentation files (the "Software"), to
// deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall
// be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

// Color Scheme Creation Enum
typedef enum
{
    ColorSchemeAnalagous = 0,
    ColorSchemeMonochromatic,
    ColorSchemeTriad,
    ColorSchemeComplementary
	
} ColorScheme;

@interface UIColor (Colours)

// Color Methods
+ (UIColor *)colorFromHexString:(NSString *)hexString;
- (NSString *)hexString;
- (NSArray *)rgbaArray;
- (NSArray *)hsbaArray;

// Generate Color Scheme
- (NSArray *)colorSchemeOfType:(ColorScheme)type;

// System Colors
+ (UIColor *)infoBlueColor;
+ (UIColor *)successColor;
+ (UIColor *)warningColor;
+ (UIColor *)dangerColor;

// Whites
+ (UIColor *)antiqueWhiteColor;
+ (UIColor *)oldLaceColor;
+ (UIColor *)ivoryColor;
+ (UIColor *)seashellColor;
+ (UIColor *)ghostWhiteColor;
+ (UIColor *)snowColor;
+ (UIColor *)linenColor;

// Grays
+ (UIColor *)black25PercentColor;
+ (UIColor *)black50PercentColor;
+ (UIColor *)black75PercentColor;
+ (UIColor *)warmGrayColor;
+ (UIColor *)coolGrayColor;
+ (UIColor *)charcoalColor;

// Blues
+ (UIColor *)tealColor;
+ (UIColor *)steelBlueColor;
+ (UIColor *)robinEggColor;
+ (UIColor *)pastelBlueColor;
+ (UIColor *)turquoiseColor;
+ (UIColor *)skyeBlueColor;
+ (UIColor *)indigoColor;
+ (UIColor *)denimColor;
+ (UIColor *)blueberryColor;
+ (UIColor *)cornflowerColor;
+ (UIColor *)babyBlueColor;
+ (UIColor *)midnightBlueColor;
+ (UIColor *)fadedBlueColor;
+ (UIColor *)icebergColor;
+ (UIColor *)waveColor;

// Greens
+ (UIColor *)emeraldColor;
+ (UIColor *)grassColor;
+ (UIColor *)pastelGreenColor;
+ (UIColor *)seafoamColor;
+ (UIColor *)paleGreenColor;
+ (UIColor *)cactusGreenColor;
+ (UIColor *)chartreuseColor;
+ (UIColor *)hollyGreenColor;
+ (UIColor *)oliveColor;
+ (UIColor *)oliveDrabColor;
+ (UIColor *)moneyGreenColor;
+ (UIColor *)honeydewColor;
+ (UIColor *)limeColor;
+ (UIColor *)cardTableColor;

// Reds
+ (UIColor *)salmonColor;
+ (UIColor *)brickRedColor;
+ (UIColor *)easterPinkColor;
+ (UIColor *)grapefruitColor;
+ (UIColor *)pinkColor;
+ (UIColor *)indianRedColor;
+ (UIColor *)strawberryColor;
+ (UIColor *)coralColor;
+ (UIColor *)maroonColor;
+ (UIColor *)watermelonColor;
+ (UIColor *)tomatoColor;
+ (UIColor *)pinkLipstickColor;
+ (UIColor *)paleRoseColor;
+ (UIColor *)crimsonColor;

// Purples
+ (UIColor *)eggplantColor;
+ (UIColor *)pastelPurpleColor;
+ (UIColor *)palePurpleColor;
+ (UIColor *)coolPurpleColor;
+ (UIColor *)violetColor;
+ (UIColor *)plumColor;
+ (UIColor *)lavenderColor;
+ (UIColor *)raspberryColor;
+ (UIColor *)fuschiaColor;
+ (UIColor *)grapeColor;
+ (UIColor *)periwinkleColor;
+ (UIColor *)orchidColor;

// Yellows
+ (UIColor *)goldenrodColor;
+ (UIColor *)yellowGreenColor;
+ (UIColor *)bananaColor;
+ (UIColor *)mustardColor;
+ (UIColor *)buttermilkColor;
+ (UIColor *)goldColor;
+ (UIColor *)creamColor;
+ (UIColor *)lightCreamColor;
+ (UIColor *)wheatColor;
+ (UIColor *)beigeColor;

// Oranges
+ (UIColor *)peachColor;
+ (UIColor *)burntOrangeColor;
+ (UIColor *)pastelOrangeColor;
+ (UIColor *)cantaloupeColor;
+ (UIColor *)carrotColor;
+ (UIColor *)mandarinColor;

// Browns
+ (UIColor *)chiliPowderColor;
+ (UIColor *)burntSiennaColor;
+ (UIColor *)chocolateColor;
+ (UIColor *)coffeeColor;
+ (UIColor *)cinnamonColor;
+ (UIColor *)almonColor;
+ (UIColor *)eggshellColor;
+ (UIColor *)sandColor;
+ (UIColor *)mudColor;
+ (UIColor *)siennaColor;
+ (UIColor *)dustColor;

@end
