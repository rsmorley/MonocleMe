//
//  UIColor+UIColor_Branding.m
//  MonocleMe
//
//  Created by Scott on 11/9/15.
//  Copyright © 2015 Monoclebot LLC. All rights reserved.
//

#import "UIColor+Branding.h"

@implementation UIColor (Branding)

+ (UIColor *)brandColorGrey { //#545f67
    return [UIColor colorWithRed:0x43/255.f green:0x5f/255.f blue:0x67/255.f alpha:1];
}

+ (UIColor *)brandColorOrageRed { //#ce4624
    return [UIColor colorWithRed:0xce/255.f green:0x46/255.f blue:0x24/255.f alpha:1];
}

+ (UIColor *)brandColorPastelBlue { //#b6ced8
    return [UIColor colorWithRed:0xb6/255.f green:0xce/255.f blue:0xd8/255.f alpha:1];
}

+ (UIColor *)brandColorSlateBlue { //#567e9d
    return [UIColor colorWithRed:0x56/255.f green:0x7e/255.f blue:0x9d/255.f alpha:1];
}

+ (UIColor *)brandColorWhite { //#f2f2f2
    return [UIColor colorWithRed:0xf2/255.f green:0xf2/255.f blue:0xf2/255.f alpha:1];
}

@end
