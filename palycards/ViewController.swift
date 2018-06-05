//
//  ViewController.swift
//  palycards
//
//  Created by Arpit Singh on 11/02/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var deck = playingcarddeck()
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playcardviewchang.faceup = !playcardviewchang.faceup
        default:
            break
        }
    
    }
    
    @IBOutlet weak var playcardviewchang: playingcardview!{didSet{
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextcard))
        swipe.direction = [.left,.right]
        playcardviewchang.addGestureRecognizer(swipe)
        let pinch = UIPinchGestureRecognizer(target: playcardviewchang, action: #selector
            (playcardviewchang.adjustface(byhandling:)))
        playcardviewchang.addGestureRecognizer(pinch)
        }
    }

        @objc func nextcard()
    { if let card = deck.draw(){
        playcardviewchang.rank = card.rank.order
        playcardviewchang.suit = card.suit.rawValue
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

