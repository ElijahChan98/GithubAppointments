//
//  GithubUserTableViewCell.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/23/22.
//

import UIKit

class GithubUserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
