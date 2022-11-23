//
//  GithubUser.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/23/22.
//

import Foundation
import UIKit

class GithubUser: Codable {
    enum CodingKeys: String, CodingKey {
        case userUrl = "url"
        case avatarStringUrl = "avatar_url"
        case details = "type"
        case id = "id"

        //profile details
        case name = "name"
        case company = "company"
        case blog = "blog"
        case followers = "followers"
        case following = "following"
        case bio = "bio"
        case repoUrl = "repos_url"
        case location = "location"
    }
    
    var userUrl: String?
    var avatarStringUrl: String?
    var details: String?
    var id: Int?
    var username: String?
    var name: String?
    var company: String?
    var blog: String?
    var followers: Int?
    var following: Int?
    var bio: String?
    var repoUrl: String?
    var location: String?
    
    //TODO: for offline mode, we can add a persistence layer to GithubUsers. Every payload can be saved to CoreData after being fetched
}
