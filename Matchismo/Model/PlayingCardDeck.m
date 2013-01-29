//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 1/29/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (id)init {
    self = [super init];
    
    if (self) {
        // fill the deck with all cards (e.g. 4 suits * 13 ranks = 52 possible playing cards)
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank=1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                
                // add the card to the top of the deck
                [self addCard:card atTop:YES];
            }
        }
    }
    
    return self;
}

@end
