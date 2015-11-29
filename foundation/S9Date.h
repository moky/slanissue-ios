//
//  S9Date.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-30.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SlanissueToolkit)

/**
 *  @return year number (2015, ...)
 */
- (NSUInteger) year;

/**
 *  @return month number (1 - 12)
 *      1 : January
 *      2 : February
 *      3 : March
 *      4 : April
 *      5 : May
 *      6 : June
 *      7 : July
 *      8 : August
 *      9 : September
 *     10 : October
 *     11 : November
 *     12 : December
 */
- (NSUInteger) month;

/**
 *  @return day number (1 - 31)
 */
- (NSUInteger) day;

/**
 *  @return hour number (0 - 23)
 */
- (NSUInteger) hour;

/**
 *  @return minute number (0 - 59)
 */
- (NSUInteger) minute;

/**
 *  @return second number (0 - 59)
 */
- (NSUInteger) second;

/**
 *  @return weekday number (0 - 6)
 *      0 : Sunday
 *      1 : Monday
 *      2 : Tuerday
 *      3 : Wednesday
 *      4 : Thursday
 *      5 : Friday
 *      6 : Saturday
 */
- (NSUInteger) weekday;

#pragma mark Formated String

- (NSString *) stringWithFormat:(NSString *)format; // "yyyy-MM-dd HH:mm:ss"

- (NSString *) humanReadableString;

@end