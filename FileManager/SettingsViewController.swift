//
//  SettingsViewController.swift
//  FileManager
//
//  Created by ln on 23.04.2023.
//

import UIKit

let myNotificationKey = "ReloadFiles"

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var passwordSettings = ["Смена пароля"]
    private var sortTypes = ["А -> Я", "Я -> А"]
    
    private var switchViewAZ = UISwitch(frame: .zero)
    private var switchViewZA = UISwitch(frame: .zero)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupView()
    }
    
    private func setupView() {
        
        self.view.addSubview(self.tableView)
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sortTypes.count
        } else if section == 1 {
            return passwordSettings.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = sortTypes[indexPath.row]
                switchViewAZ.setOn(false, animated: true)
                switchViewAZ.tag = indexPath.row // for detect which row switch Changed
                switchViewAZ.addTarget(self, action: #selector(self.switchChangedToAZ), for: .valueChanged)
                cell.accessoryView = switchViewAZ
            } else if indexPath.row == 1 {
                cell.textLabel?.text = sortTypes[indexPath.row]
                switchViewZA.setOn(false, animated: true)
                switchViewZA.tag = indexPath.row
                switchViewZA.addTarget(self, action: #selector(self.switchChangedToZA), for: .valueChanged)
                cell.accessoryView = switchViewZA
            }

        } else if indexPath.section == 1 {
            cell.textLabel?.text = passwordSettings[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
    
            let vc = PasswordChangeViewController()
            vc.modalPresentationStyle = .automatic
            self.present(vc, animated: true)
        }
    }
    
    @objc private func switchChangedToAZ(_ sender : UISwitch!) {
        
        if sender.isOn {
            switchViewZA.isOn = false
            UserDefaults.standard.set("AZ", forKey: "sorting")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sort"), object: nil)
        }
    }
    
    @objc private func switchChangedToZA(_ sender : UISwitch!) {
        if sender.isOn {
            switchViewAZ.isOn = false
            UserDefaults.standard.set("ZA", forKey: "sorting")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sort"), object: nil)
        }
    }
    
}

