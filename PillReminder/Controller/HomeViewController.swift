//
//  ViewController.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 15.08.23.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var medications = [Medication]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
    }
    
    // MARK: - Objc

    @objc func addMedicationButtonPressed() {
        // show addVC
        let addVC = AddViewController()
        addVC.completion = { [weak self] title, amount, date in
            DispatchQueue.main.async {
                let newMedication = Medication(title: title, amount: amount, date: date)
                self?.medications.append(newMedication)
                self?.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
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
        }
    }
    
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "My Medications"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainBlue()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance;
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

