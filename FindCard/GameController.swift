//
//  GameController.swift
//  FindCard
//
//  Created by Chandra Agus on 25/4/20.
//  Copyright © 2020 Chandra Agus Tatianto. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var lblSteps: UILabel!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    let game = MemoryGame()
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        
        APIClient.shared.getCards { (cardsArray, error) in
            if let _ = error {
                // show alert
            }
            
            self.cards = cardsArray!
            self.setupNewGame()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func setupNewGame() {
        cards = game.newGame(cardsArray: self.cards)
        collectionView.reloadData()
        self.lblSteps.text = "0"
    }
    
    func resetGame() {
        game.restartGame()
        setupNewGame()
    }
    
    @IBAction func onStartGame(_ sender: Any) {
        collectionView.isHidden = false
        playButton.isHidden = true
        restartButton.isHidden = false
        
    }
    @IBAction func onRestartGame(_ sender: Any) {
        resetGame()
    }
    
    
}

// MARK: - CollectionView Delegate Methods
extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.showCard(false, animted: false)
        
        guard let card = game.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.shown { return }
        game.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated:true)
        self.lblSteps.text = String(game.steps)
    }
}

// MARK: - MemoryGameProtocol Methods
extension GameController: MemoryGameProtocol {
    
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    
    func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(true, animted: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(false, animted: true)
        }
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        
        let alertController = UIAlertController(
            title: defaultAlertTitle,
            message: defaultAlertMessage,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] (action) in
           self?.collectionView.isHidden = false
           self?.resetGame()
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) { }
        
       
    }
}

extension GameController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
