//
//  HomeViewModel.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/23/22.
//

import Foundation

class HomeViewModel {
    var delegate: HomeViewModelDelegate?
    var users: [GithubUser] = []
    
    //TODO: for offline mode, we can first check if users exist from our persistence layer (CoreData). Otherwise, fetch from API
    func fetchUsers() {
        RequestManager.shared.fetchGithubUsers { success, response in
            if success {
                if let payloads = response?["payloads"] as? [[String: Any]] {
                    for payload in payloads {
                        if let user: GithubUser = CodableObjectFactory.objectFromPayload(payload) {
                            user.username = user.userUrl?.replacingOccurrences(of: "\(Constants.GITHUB_BASE_URL)\(Constants.GITHUB_USERS)/", with: "")
                            self.users.append(user)
                            DispatchQueue.main.async {
                                self.delegate?.onFetchUsersSuccess()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate?.onFetchUsersFail()
                }
            }
        }
    }
}

protocol HomeViewModelDelegate {
    func onFetchUsersSuccess()
    func onFetchUsersFail()
}
