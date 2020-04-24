//
//  MemoryCell.swift
//  FindCard
//
//  Created by Chandra Agus on 25/4/20.
//  Copyright © 2020 Chandra Agus Tatianto. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {

    // MARK: - Properties
    @IBOutlet weak var frontImageView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    
    var card: Card? {
        didSet {
            guard let card = card else { return }
            cardNumber.text = String(card.number)
            
            frontImageView.layer.cornerRadius = 5.0
            backImageView.layer.cornerRadius = 5.0
            
            frontImageView.layer.masksToBounds = true
            backImageView.layer.masksToBounds = true
        }
    }
    
    var shown: Bool = false
    
    // MARK: - Methods

    func showCard(_ show: Bool, animted: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        shown = show
        
        if animted {
            if show {
                UIView.transition(
                    from: backImageView,
                    to: frontImageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transition(
                    from: frontImageView,
                    to: backImageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion:  { (finished: Bool) -> () in
                        
                })
            }
        } else {
            if show {
                bringSubview(toFront: frontImageView)
                backImageView.isHidden = true
            } else {
                bringSubview(toFront: backImageView)
                frontImageView.isHidden = true
            }
        }
    }
}


