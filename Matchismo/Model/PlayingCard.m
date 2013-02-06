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
    int suitMatches = 0;
    int rankMatches = 0;
    
    // iterate over all other cards and see if rank or suit matches
    for (Card *otherCard in otherCards) {
        // check if this indeed a playing card
        if ([otherCard isKindOfClass:[PlayingCard class]]) {
            PlayingCard *otherPlayingCard = (PlayingCard *)otherCard;
            
            // match suits and ranks
            if ([otherPlayingCard.suit isEqualToString:self.suit]) {
                suitMatches++;
            } else if (otherPlayingCard.rank == self.rank) {
                rankMatches++;
            }
        }
    }
    
    // do we have a complete match?
    if (suitMatches == [otherCards count]) score += suitMatches;
    if (rankMatches == [otherCards count]) score += rankMatches * 4;
    
    return score;
}

@end
