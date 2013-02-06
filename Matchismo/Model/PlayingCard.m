//
//  PlayingCard.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 1/29/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit; // we need to @synthesize manually because we provide both
                          // the setter AND the getter (new in iOS 6)

- (NSString *)contents {
    return [[PlayingCard validRanks][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits {
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?"; // ternary conditional expression
}

+ (NSArray *)validRanks {
    // Renamed it to validRanks to be more consistent with validSuits (the
    // lecture slides use 'rankStrings' instead)
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
    return [PlayingCard validRanks].count-1;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

// overloaded method
- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    // iterate over othercards and calculate score
    // if we do no match, score will always be zero
    for (PlayingCard *otherCard in otherCards) {
        if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        } else if (otherCard.rank == self.rank) {
            score += 4;
        } else {
            // no match
            score = 0;
            break;
        }
    }
    
    return score;
}

@end
