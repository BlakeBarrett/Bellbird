//
//  DetailViewController.swift
//  Bellbird
//
//  Created by Blake Barrett on 3/15/18.
//  Copyright © 2018 Handshake. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var voteControl: UISegmentedControl!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    func configureView() {
        if let item = detailItem,
           let detailLabel = detailDescriptionLabel,
           let creationLabel = creationDateLabel {
            // body/description
            detailLabel.text = item.body ?? ""
            
            // creation date
            if let _ = item.createdAt {
                creationLabel.text = item.created_at
            } else {
                creationLabel.text = ""
            }
            
            // votes
            voteControl.selectedSegmentIndex = -1
            voteControl.isEnabled = item.votes != nil
            if let numVotes = item.votes {
                voteCountLabel.text = String(describing: numVotes)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var detailItem: Alarm? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func onVotesChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // downvote
            BellbirdAPI.instance.downvote(&detailItem) { [weak self] in
                self?.configureView()
            }
            break
        case 1: // upvote
            BellbirdAPI.instance.upvote(&detailItem) { [weak self] in
                self?.configureView()
            }
            break
        default: break // unreachable
        }
    }
}
