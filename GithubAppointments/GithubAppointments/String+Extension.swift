//
//  String+Extension.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/23/22.
//

import Foundation

extension String{
    public func urlString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
