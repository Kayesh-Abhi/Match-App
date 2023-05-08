//
//  ViewController.swift
//  MatchApp
//
//  Created by kayesh Abhisheka on 2023-04-25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    let model = CardModel()     // Creating a object fot CardModel class
    var cardsArray = [Card]()   // Declare empty array which can contain Card objects
    
    var timer:Timer?
    var milliseconds:Int = 50 * 1000    //we here multiply to covert sec to millisec
    
    var firstFlippedCardIndex:IndexPath?    // To keep track of the first flipped card
    
    var soundPlayer = SoundManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsArray = model.getCards() // Assign returned Card array from CardModel class's getCards function to declared empty array
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self    //how many items need to display?
        collectionView.delegate = self      //what do i display?
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    // we use this to do sound after view appeared
    override func viewDidAppear(_ animated: Bool) {
        
        //  Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
         
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
            
        //  Decrement the counter
        milliseconds -= 1
        
        //  Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)   //  2 decimal points
        
        //  Stop the timer if it reaches zero
        if (milliseconds == 0) {
            timerLabel.textColor = UIColor.red
            timer?.invalidate() //  invalidate the timer
            
            // TODO:  Check if the user has cleared all the pairs
            checkForGameEnd()   //  When time is up show the alert
        }
        
    }
        
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count  //Return number of cards
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        // Get a cell, here we use as CardCollectionViewCell because we want to return the subclass we created 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        return cell    //Return the cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //  Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        let card = cardsArray[indexPath.row]    //  access the corresponding card from the card array
        
        cardCell?.configureCell(card: card)  // Finish configuring the cell // Passing a card object to this function
        
    }

    
    // Function to run when card is clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //  Check if there's any time remaining. Don't let the user interact if the time is 0
        if milliseconds <= 0 {
            return
        }
            
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell  // cell works as a object here to use CardCollectionViewCell things
        
        if (cell?.card?.isFlipped == false && cell?.card?.isMatched == false) {
            cell?.flipUp()  //  Flip the card up
            
            //  Play sound
            soundPlayer.playSound(effect: .flip)
            
            //  Check if this is the first card that was flipped or the second card
            if (firstFlippedCardIndex == nil) {
                //  This is the first card flipped over
                firstFlippedCardIndex = indexPath
            }
            else {
                //  A second card flipped
                
                //  Run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    //  MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        //  Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        //  Get the two collection view cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //  Compare the two cards
        if (cardOne.imageName == cardTwo.imageName) {
            //  It's a match
            
            //  Play sound
            soundPlayer.playSound(effect: .match)
            
            //  Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //  Was that the last pair?
            checkForGameEnd()   //  Check you matched the all pairs and if so show the alert
            
        }
        else {
            //  It's not a match
            
            //  Play sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back over // this is for the animation
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        firstFlippedCardIndex = nil  // Reset the firstFlippedCardIndex property
    }
    
    
    func checkForGameEnd() {
        
        //  Check if there's any card that is unmatched
        //  Assume the user has won, loop through all the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                //  We've found a card that is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon {
            // User has won, show an alert
            showAlert(title: "Congratulations!", message: "You've won the game!")
            
        }
        else {
            //  User hasn't won yet, check if there's any time left
            if (milliseconds <= 0) {
                showAlert(title: "Time's Up", message: "Sorry, better luck next time!")
            }
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)   //  Create the alert
        let okAction = UIAlertAction(title: "OK", style: .default)  //  Add a button to user to dismiss it
        alert.addAction(okAction)
        present(alert, animated: true)  //  Show the alert
    }

    
    
}

