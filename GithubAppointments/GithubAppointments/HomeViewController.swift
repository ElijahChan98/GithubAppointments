//
//  HomeViewController.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/23/22.
//

import UIKit
import Network

class HomeViewController: UIViewController {
    @IBOutlet weak var noInternetImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select GitHub User"
        viewModel = HomeViewModel()
        viewModel.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "GithubUserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        viewModel.fetchUsers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNoInternetIcon), name: .NetworkConnectivityDidChange, object: nil)
        ConnectionMonitor.shared.monitorNetworkChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func showNoInternetIcon(_ notification: NSNotification) {
        guard let isConnected = notification.userInfo?["isConnected"] as? (Bool), isConnected == false else {
            viewModel.fetchUsers()
            DispatchQueue.main.async {
                self.noInternetImageView.isHidden = true
            }
            return
        }
        DispatchQueue.main.async {
            self.noInternetImageView.isHidden = false
        }
    }
}

// TODO: with more time, we can add prefetching to enable pagination (display only a limited amount of results from the api, then prefetch the rest based on the api's "page")
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, HomeViewModelDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! GithubUserTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.userNameLabel.text = user.username
        cell.avatarActivityIndicator.startAnimating()
        
        DispatchQueue.global().async {
            if let stringUrl = user.avatarStringUrl, let avatarUrl = URL(string: stringUrl) {
                let task = URLSession.shared.dataTask(with: avatarUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.avatarImageView.image = image
                            cell.avatarActivityIndicator.stopAnimating()
                        }
                    }
                }
                task.resume()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel.users[indexPath.row]
        self.navigationController?.pushViewController(ProfileViewController(user: user), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func onFetchUsersFail() {
        
    }
    
    func onFetchUsersSuccess() {
        self.tableView.reloadData()
    }
}
