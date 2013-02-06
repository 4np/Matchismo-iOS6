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
    BOOL hasOtherCard = NO;
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[ otherCard ]];
                    hasOtherCard = YES;
                    
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.matchResult = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.matchResult = [NSString stringWithFormat:@"%@ and %@ don't match! %d points penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                    
                    break;
                }
            }

            if (!hasOtherCard) {
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
