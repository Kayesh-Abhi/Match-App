//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by kayesh Abhisheka on 2023-04-27.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card: Card) {
        
        self.card = card    //  Keep track of the card this cell represents
        
        frontImageView.image = UIImage(named: card.imageName)   //  Set the front image view to the image that represents the card
        
        //  Reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        
        if (card.isMatched == true) {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if (card.isFlipped ==  true) {
            flipUp(speed: 0)    //  Show the front image view
        }
        else {
            flipDown(speed: 0, delay: 0)  //  Show the back image view
        }
    }
    
    
    //  if the time interval is not specifically given its 0.3 as default
    func flipUp(speed: TimeInterval = 0.3) {
        
        //  Flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft])
        card?.isFlipped = true  //  Set the status of the card
    }
    
    
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        
        //  This displatchQue is used to slow down flipDown animation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            //  Flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft])
        }
        card?.isFlipped = false    //  Set the status of the card
    }
    
    
    
    func remove() {
        
        //  Make the image view invisible
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: { self.frontImageView.alpha = 0 })
    }
    
}

