//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 2/6/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score; // private read/write
@property (readwrite, nonatomic) NSString *matchResult; // idem
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (id)init {
    // invalid, you should call the designated initializer
    return nil;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        self.score = 0;
        
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            // got a card?
            if (card) {
                // yes, set it
                self.cards[i] = card;
            } else {
                // no! count is larger than the number
                // of cards in the deck
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            // build an array of cards to match with
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                }
            }
            
            // do we need to match?
            if ((self.isTwoCardGame && [otherCards count] == 1) || (!self.isTwoCardGame && [otherCards count] ==2)) {
                // calculate the match score
                int matchScore = [card match:otherCards];
                
                NSMutableString *feedback = [[NSMutableString alloc] init];
                
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    
                    card.unplayable = YES;
                    [feedback appendFormat:@"Matched %@", card.contents];
                    
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;

                        if ([otherCard isEqual:[otherCards lastObject]]) {
                            [feedback appendFormat:@" and %@", otherCard.contents];
                        } else {
                            [feedback appendFormat:@", %@", otherCard.contents];
                        }
                    }
                    
                    [feedback appendFormat:@" for %d points", matchScore * MATCH_BONUS];
                } else {
                    self.score -= MISMATCH_PENALTY * [otherCards count];
                    
                    [feedback appendString:card.contents];
                    
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                        
                        if ([otherCard isEqual:[otherCards lastObject]]) {
                            [feedback appendFormat:@" and %@", otherCard.contents];
                        } else {
                            [feedback appendFormat:@", %@", otherCard.contents];
                        }
                    }

                    [feedback appendFormat:@"don't match! %d points penalty!", MISMATCH_PENALTY * [otherCards count]];
                }
                
                self.matchResult = feedback;
            } else {
                self.matchResult = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            
            // discourage constant flipping
            self.score -= FLIP_COST;
        } else {
            self.matchResult = @"";
        }

        // flip the card
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
