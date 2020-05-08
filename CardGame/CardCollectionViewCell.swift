//
//  CardCollectionViewCell.swift
//  CardGame
//
//  Created by eyal avisar on 06/05/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var faceImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        self.card = card
        faceImageView.image = UIImage(named: card.imageName)
        
        //reset Cell when reused in collectionView
        if card.isMatched {
            backImageView.alpha = 0
            faceImageView.alpha = 0
            return
        }
        
        if card.isFlipped {
            flipUp(speed: 0)
        }
        else {
            flipDown(speed: 0, delay: 0)
        }
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        UIView.transition(from: backImageView, to: faceImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        card?.isFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.transition(from: self.faceImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        card?.isFlipped = false
    }
    
    func remove() {
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.faceImageView.alpha = 0
        }, completion: nil )
    }
}
