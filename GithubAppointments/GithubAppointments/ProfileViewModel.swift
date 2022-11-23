//
//  ProfileViewModel.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/24/22.
//

import Foundation

class ProfileViewModel {
    //TODO: Should put this on a constants file if time permits. These time frames should be constant when testing on dev environments, otherwise, on release and staging, time frames should reflect real availability of user
    var timeIntervals = [
        "12:00AM to 01:00AM",
        "1:00AM to 2:00AM",
        "3:00AM to 4:00AM",
        "4:00AM to 5:00AM",
        "5:00AM to 6:00AM",
        "7:00AM to 8:00AM",
        "9:00AM to 10:00AM",
        "11:00AM to 12:00PM",
        "12:00PM to 01:00PM",
        "1:00PM to 2:00PM",
        "3:00PM to 4:00PM",
        "4:00PM to 5:00PM",
        "5:00PM to 6:00PM",
        "7:00PM to 8:00PM",
        "9:00PM to 10:00PM",
        "11:00PM to 12:00PM",
    ]
    var user: GithubUser!
    var delegate: ProfileViewModelDelegate?
    
    init(user: GithubUser) {
        self.user = user
    }
    
    func fetchUserProfile() {
        RequestManager.shared.fetchGithubUserProfile(username: self.user.username ?? "") { [unowned self] success, response in
            if success {
                if let payload = response {
                    if let user: GithubUser = CodableObjectFactory.objectFromPayload(payload) {
                        self.user.followers = user.followers
                        self.user.following = user.following
                        self.user.bio = user.bio
                        self.user.company = user.company
                        self.user.blog = user.blog
                        self.user.repoUrl = user.repoUrl
                        self.user.location = user.location
                        
                        DispatchQueue.main.async {
                            self.delegate?.onFetchUserProfileSuccess()
                        }
                    }
                }
            } else {
                //TODO: Add fail state here
            }
        }
    }
}

protocol ProfileViewModelDelegate {
    func onFetchUserProfileSuccess()
}
