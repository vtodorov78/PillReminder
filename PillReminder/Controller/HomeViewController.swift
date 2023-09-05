//
//  ViewController.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 15.08.23.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var medications = [Medication]()
    
    let bannerView: BannerView = {
        let view = BannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(bannerView)
        bannerView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 15, paddingRight: 20, width: view.frame.width - 40, height: view.frame.height / 10)
    }
    
    // MARK: - Objc
    
    @objc func addMedicationButtonPressed() {
        // show addVC
        let addVC = AddViewController()
        
        addVC.completion = { [weak self] title, amount, date in
            
            let newMedication = Medication(title: title, amount: amount, date: date)
            self?.medications.append(newMedication)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        DispatchQueue.main.async {
            addVC.titleField.becomeFirstResponder()
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    
    @objc func putCheckmark(sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! MedicationCell
        
        if sender.isSelected {
            sender.isSelected = false
            cell.medication.isMarked = false
        } else {
            sender.isSelected = true
            cell.medication.isMarked = true
            
            animateNotificationBanner(view: bannerView, banner: showSuccessNotificationBanner)
        }
        
        // delete taken medication
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.medications.remove(at: sender.tag)
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Helper Functionsz
    
    
    func showSuccessNotificationBanner() {
        bannerView.label.text = "Medication is taken."
        bannerView.backgroundColor = .systemGreen
    }
    
    func showDeleteNotificationBanner() {
        bannerView.label.text = "Medication is deleted."
        bannerView.backgroundColor = .systemRed
    }
    
    func animateNotificationBanner(view: UIView, banner: () -> Void) {
        banner()
        
        UIView.animate(withDuration: 2.0, delay: 0.3, options: .curveEaseIn) {
            view.alpha = 1.0
            view.alpha = 0.0
        }
    }
    
    func configureViewComponents() {
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "My Medications"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainBlue()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMedicationButtonPressed))
        
        tableView.register(MedicationCell.self, forCellReuseIdentifier: MedicationCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
    }
}


extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicationCell.reuseIdentifier, for: indexPath) as? MedicationCell else { return UITableViewCell() }
        let medication = medications[indexPath.row]
        cell.medication = medication
        cell.checkmarkButton.addTarget(self, action: #selector(putCheckmark), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = InfoViewController()
        infoVC.delegate = self
        infoVC.modalPresentationStyle = .automatic
        infoVC.medicationTitle = medications[indexPath.row].title
        infoVC.medicationDosage = medications[indexPath.row].amount
        infoVC.medicationDate = medications[indexPath.row].date
        self.present(infoVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            medications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            animateNotificationBanner(view: bannerView, banner: showDeleteNotificationBanner)
        }
    }
}

extension HomeViewController: InfoViewDelegate {
    
    func takeMedication() {
        let indexPath = tableView.indexPathForSelectedRow
        medications.remove(at: indexPath!.row)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        animateNotificationBanner(view: bannerView, banner: showSuccessNotificationBanner)
    }
    
    func deleteMedication() {
        let indexPath = tableView.indexPathForSelectedRow
        medications.remove(at: indexPath!.row)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        animateNotificationBanner(view: bannerView, banner: showDeleteNotificationBanner)
    }
    
}
