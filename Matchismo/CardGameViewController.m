//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 1/29/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic) PlayingCardDeck *deckOfCards;
@end

@implementation CardGameViewController

- (void)viewDidLoad {
    if (!self.deckOfCards) self.deckOfCards = [[PlayingCardDeck alloc] init];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    // are there cards in the deck?
    if (self.deckOfCards.numberOfCardsInDeck > 0) {
        // yes, are we flipping over to show the front of the card?
        if (!sender.isSelected) {
            // yes, draw a card from the top of the deck
            Card *card = [self.deckOfCards drawCardFromTop];
            [sender setTitle:card.contents forState:UIControlStateSelected];
        }
        
        sender.selected = !sender.isSelected;
        self.flipCount++;
    } else {
        // no, show a warning
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"No more cards"
                                                          message:@"This is the last card, there are no more cards left in the deck"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:@"Restack Deck", nil];
        [warning show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Restack Deck"]) {
        // restack the deck by re-initializing the deck
        self.deckOfCards = [[PlayingCardDeck alloc] init];
    }
}

@end
