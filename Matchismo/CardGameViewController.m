//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 1/29/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSwitch;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    // lazy instantiation
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];

        // set the game mode
        self.game.twoCardGame = ([self.gameModeSwitch selectedSegmentIndex] == 0);
    }
    
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI { 
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        // set the back image of the card
        [cardButton setTitle:@"" forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"playingCardBack.png"] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"playingCardFront.png"] forState:UIControlStateSelected];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"playingCardFront.png"] forState:UIControlStateSelected|UIControlStateDisabled];

        
        // set the title of the card
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable) ? 0.3 : 1;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.matchResultLabel.text = self.game.matchResult;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.gameModeSwitch.enabled = FALSE;
}

- (IBAction)deal:(id)sender {
    // ask to confirm re-dealing
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Re-deal"
                                                      message:@"Are you sure you want to re-deal the deck and start over?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [warning show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        // reset the cards
        self.game = nil;
        self.flipCount = 0;
        [self updateUI];
        self.gameModeSwitch.enabled = TRUE;
    }
}

- (IBAction)gameModeChanged:(UISegmentedControl *)sender {
    self.game.twoCardGame = ([sender selectedSegmentIndex] == 0);
    
    // feedback to the user
    UIAlertView *feedback = [[UIAlertView alloc] initWithTitle:@"Game mode changed"
                                                       message:[NSString stringWithFormat:@"You now need to match %d cards", (self.game.isTwoCardGame) ? 2 : 3]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [feedback show];
}


@end
