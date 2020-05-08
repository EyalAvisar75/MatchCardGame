//
//  ViewController.swift
//  CardGame
//
//  Created by eyal avisar on 06/05/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds = 10 * 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsArray = model.getCards()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
    }

    //MARK - Timer Methods
    @objc func timerFired() {
        milliseconds -= 1
        
        let seconds:Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Time Remaining %.2f", seconds)
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            checkForGameEnd()
        }
    }
    
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let card = cardsArray[indexPath.row]
        let cardCell = cell as? CardCollectionViewCell as CardCollectionViewCell?
        cardCell?.configureCell(card: card)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            cell?.flipUp()
            
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                checkForMatch(indexPath)
            }
        }
    }
    
//MARK - Game Logic Methods
    func checkForMatch(_ secondFlippedCardIndex:IndexPath){
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        let cardCellOne = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardCellTwo = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        if cardOne.imageName == cardTwo.imageName {
            cardOne.isMatched = true
            cardTwo.isMatched = true
            cardCellOne?.remove()
            cardCellTwo?.remove()
            
            checkForGameEnd()
        }
        else {
            cardCellOne?.flipDown()
            cardCellTwo?.flipDown()
        }
        firstFlippedCardIndex = nil
    }

    func checkForGameEnd(){
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                hasWon = false
                break
            }
        }
        
        if hasWon {
            showAlert(title: "Congratulation", message: "You won the game!")
        }
        else {
            if milliseconds <= 0 {
                showAlert(title: "Time's up", message: "Better luck next time!")
            }
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


