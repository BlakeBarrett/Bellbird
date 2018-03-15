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
        guard let item = detailItem else { return }
        switch sender.selectedSegmentIndex {
        case 0: // downvote
            BellbirdAPI.instance.downvote(item)
            break
        case 1: // upvote
            BellbirdAPI.instance.upvote(item)
            break
        default: break // unreachable
        }
    }
}
