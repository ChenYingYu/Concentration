//
//  ViewController.swift
//  Concentration
//
//  Created by ChenAlan on 2017/12/17.
//  Copyright © 2017年 ChenAlan. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    lazy var game = Concentration(numberOfPairOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }

    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    // check if the theme is chosen
    var checkChosenTheme = 0
    @IBAction func touchCard(_ sender: UIButton) {
        if checkChosenTheme == 0 {
            chooseThemes(at: 1)
        }
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardBottons")
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9818583131, green: 0.9282233715, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
            
        }
    }
    
    //TODO: Make 6 themes

    var emojiChoices = [String]()
    

    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        print("card.identifier = \(emoji)")
        return emoji[card.identifier] ?? "?"
    }
    
    //TODO: "New Game" button
    @IBAction func startNewGame(_ sender: UIButton) {
        flipCount = 0
        emoji = [Int:String]()
        chooseThemes(at: 1)
        let randomIndex = Int(arc4random_uniform(UInt32(game.cards.count)))
        let shuffleCard = game.cards[0]
        game.cards[0] = game.cards[randomIndex]
        game.cards[randomIndex] = shuffleCard
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            game.indexOfOneAndOnlyFaceUpCard = nil

        }
    }
}

