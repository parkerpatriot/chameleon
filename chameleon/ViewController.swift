//
//  ViewController.swift
//  chameleon
//
//  Created by James Parker on 4/26/20.
//  Copyright © 2020 blackargyle. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var generateWord: UIButton!
    @IBOutlet weak var secretWord: UILabel!
    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var numPlayerLabel: UILabel!
    @IBOutlet weak var restartGame: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var gameStackView: UIStackView!
    @IBOutlet weak var gameNavStack: UIStackView!
    @IBOutlet weak var playerNumStack: UIStackView!
    
    var numPlayers = 1;
    var word = "";
    var playerWords = Array<String>()
    var dictionary = Array<String>()
    
    func enableGame() {
        startGame.isEnabled = false
        restartGame.isEnabled = false
        generateWord.isEnabled = true
        showButton.isEnabled = false
        nextButton.isEnabled = false
    }
    
    func resetGame() {
        numPlayers = 1;
        word = ""
        currentPlayerLabel.text = "   "
        playerWords.removeAll()
        enableGame()
        startGame.isHidden = false
        generateWord.isHidden = false
        gameNavStack.isHidden = true
        playerNumStack.isHidden = false
    }
    
    func updateViews() {
        secretWord.text = word
        numPlayerLabel.text = String(numPlayers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageView.loadGif(asset: "chameleon")
        resetGame()
        updateViews()
        guard let asset = NSDataAsset.init(name: "wordlist") else {
            fatalError("Missing data asset: wordlist")
        }

        let data = asset.data
        let wordsString = String(bytes: data, encoding: .ascii)
        dictionary = wordsString!.components(separatedBy: .newlines)
    }
    @IBAction func generateRandomWord(_ sender: Any) {
        word = dictionary.randomElement()!;
        updateViews();
        startGame.isEnabled = true;
    }
    
    @IBAction func incPlayer(_ sender: Any) {
        numPlayers += 1;
        numPlayerLabel.text = String(numPlayers);
    }
    
    @IBAction func decPlayer(_ sender: Any) {
        numPlayers -= 1;
        if (numPlayers < 1) { numPlayers = 1 }
        numPlayerLabel.text = String(numPlayers);
    }
    
    func initPlayerWords() {
        playerWords = [String](repeating: word, count: numPlayers);
        let cham = Int.random(in: 0..<numPlayers);
        playerWords[cham] = "You're the Chameleon!";
    }
    
    @IBAction func startTheGame(_ sender: Any) {
        initPlayerWords()
        secretWord.text = "   "
        currentPlayerLabel.text = "Player #1"
        generateWord.isEnabled = false
        showButton.isEnabled = true
        nextButton.isEnabled = true
        startGame.isHidden = true
        generateWord.isHidden = true
        restartGame.isEnabled = true
        gameNavStack.isHidden = false
        playerNumStack.isHidden = true
    }
    
    @IBAction func revealSecret(_ sender: Any) {
        secretWord.text = playerWords.popLast();
        showButton.isEnabled = false
    }
    
    @IBAction func passPlayer(_ sender: Any) {
        showButton.isEnabled = true
        if (playerWords.count > 0){
            currentPlayerLabel.text = "Player #" + String(numPlayers-playerWords.count + 1)
        } else {
            showButton.isEnabled = false
            nextButton.isEnabled = false
        }
        secretWord.text = "   "
    }

    @IBAction func restartGame(_ sender: Any) {
        resetGame()
        updateViews()
    }
}

