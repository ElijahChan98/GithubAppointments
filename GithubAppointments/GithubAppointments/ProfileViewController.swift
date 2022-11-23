//
//  ProfileViewController.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/24/22.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewModelDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var repoUrlLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateSelectionTextField: UITextField!
    @IBOutlet weak var timeSelectionTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var appointmentDetailsStackView: UIStackView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .wheels
        
        return datePicker
    }()
    
    private lazy var timePicker: UIPickerView = {
        let timePicker = UIPickerView(frame: .zero)
        timePicker.dataSource = self
        timePicker.delegate = self
        
        return timePicker
    }()
    
    var viewModel: ProfileViewModel!
    
    init(user: GithubUser) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ProfileViewModel(user: user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func onFetchUserProfileSuccess() {
        self.setupView()
    }
    
    private func setupView() {
        guard let user = viewModel.user else {
            //TODO: add fail state here
            return
        }
        DispatchQueue.global().async {
            if let stringUrl = user.avatarStringUrl, let avatarUrl = URL(string: stringUrl) {
                let task = URLSession.shared.dataTask(with: avatarUrl) { [unowned self] data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.imageActivityIndicator.stopAnimating()
                        }
                    }
                }
                task.resume()
            }
        }
        self.title = user.username
        followersLabel.text = "Followers:\n\(user.followers ?? 0)"
        followingLabel.text = "Following:\n\(user.following ?? 0)"
        bioLabel.text = user.bio ?? "This user has no bio"
        companyLabel.text = "Works at: \(user.company ?? "Unemployed")"
        //TODO: make these urls clickeable
        blogLabel.text = "Blog: \(user.blog ?? "No blog")"
        repoUrlLabel.text = "Repo: \(user.repoUrl ?? "No repo")"
        locationLabel.text = "Location: \(user.location ?? "No address given")"
        
        appointmentDetailsStackView.isHidden = true
        setupDatePicker()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        notesTextField.delegate = self
    }
    
    private func setupDatePicker() {
        dateSelectionTextField.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        dateSelectionTextField.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        timeSelectionTextField.inputView = timePicker
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateSelectionTextField.text = dateFormatter.string(from: sender.date)
        appointmentDetailsStackView.isHidden = false
    }
    
    @objc func datePickerDone() {
        dateSelectionTextField.resignFirstResponder()
    }

    @IBAction func onSetAppointmentButtonClick(_ sender: Any) {
        guard !(nameTextField.text?.isEmpty ?? true),
              !(emailTextField.text?.isEmpty ?? true),
              !(notesTextField.text?.isEmpty ?? true) else {
            Utilities.showGenericOkAlert(title: "Error", message: "Please fill all required fields")
            return
        }
        Utilities.showGenericOkAlert(title: "Success", message: "Appointment booked! An email will be sent to you for confirmation")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.timeIntervals.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.timeIntervals[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = viewModel.timeIntervals[row]
        timeSelectionTextField.text = value
        timeSelectionTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
