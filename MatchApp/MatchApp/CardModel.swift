//
//  CardModel.swift
//  MatchApp
//
//  Created by kayesh Abhisheka on 2023-04-27.
//

import Foundation

class CardModel {
    
    //  Function to return Card object array
    func getCards() -> [Card] {
        
        var generatedCards = [Card]()   //  Declare an empty array
        var dupliCheckerArray = [Int]()     // An array to contain only non duplicate values
        
        repeat {
            
            let randomNumber = Int.random(in: 1...13)   // Generate a random number

            if (!dupliCheckerArray.contains(randomNumber)) {
                
                // Insert generated random number to the non duplicated values array
                dupliCheckerArray.append(randomNumber)
                
                // Create two new card objects
                let cardOne = Card()
                let cardTwo = Card()

                // set their image name
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"

                generatedCards += [cardOne, cardTwo]    // Add them to the array
                print("random number: \(randomNumber)")     // Print generated random number
            }
            
        } while (dupliCheckerArray.count < 8)
        
        print("random number array: \(dupliCheckerArray)")    // Print generated random number array
        print(generatedCards)
        
        generatedCards.shuffle()    // Randomize the cards within the array
        
        return generatedCards   // Return the array
    }
}
