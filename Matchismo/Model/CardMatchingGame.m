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
// while the match results are shown in the view, it is in fact something
// the model keeps track of. Therefore it belongs in the Model, for the
// controler to use.
@property (readwrite, nonatomic) NSString *matchResult; // idem
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

// define constants
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

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
            //if ((self.isTwoCardGame && [otherCards count] == 1) || (!self.isTwoCardGame && [otherCards count] == 2)) {
            if ([otherCards count] == 1) {
                // calculate the match score
                int matchScore = [card match:otherCards];
                
                // build user feedback
                NSMutableString *feedback = [[NSMutableString alloc] init];
                
                // did we have a match score? 
                if (matchScore) {
                    // increase our score
                    self.score += matchScore * MATCH_BONUS;
                    
                    // set the card to unplayable
                    card.unplayable = YES;
                    
                    // work on the feedback
                    [feedback appendFormat:@"Matched %@", card.contents];
                    
                    // iterate over the cards (that matched)
                    for (Card *otherCard in otherCards) {
                        // set it to unplayable
                        otherCard.unplayable = YES;

                        // work on the feedback
                        if ([otherCard isEqual:[otherCards lastObject]]) {
                            [feedback appendFormat:@" and %@", otherCard.contents];
                        } else {
                            [feedback appendFormat:@", %@", otherCard.contents];
                        }
                    }
                    
                    // work on the feedback some more...
                    [feedback appendFormat:@" for %d points", matchScore * MATCH_BONUS];
                } else {
                    // no match, get a penalty
                    self.score -= MISMATCH_PENALTY * [otherCards count];
                    
                    // work on feedback
                    [feedback appendString:card.contents];
                    
                    // iterate over the cards (that didn't match)
                    for (Card *otherCard in otherCards) {
                        // turn them face down
                        otherCard.faceUp = NO;
                        
                        // work on the feedback
                        if ([otherCard isEqual:[otherCards lastObject]]) {
                            [feedback appendFormat:@" and %@", otherCard.contents];
                        } else {
                            [feedback appendFormat:@", %@", otherCard.contents];
                        }
                    }
                    
                    // work on the feedback some more...
                    [feedback appendFormat:@"don't match! %d points penalty!", MISMATCH_PENALTY * [otherCards count]];
                }
                
                // and store the feedback for the controller to use
                self.matchResult = feedback;
            } else {
                self.matchResult = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            
            // discourage constant flipping by substracting a score cost
            self.score -= FLIP_COST;
        } else {
            // as we're not matching, we don't need feedback
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
