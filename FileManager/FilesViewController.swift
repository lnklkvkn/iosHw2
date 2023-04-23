//
//  ViewController.swift
//  FileManager
//
//  Created by ln on 10.04.2023.
//

import UIKit
import PhotosUI
import Photos

class FilesViewController: UIViewController,  UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, PHPickerViewControllerDelegate {
    
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    private var files : [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path)
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupView()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFile))
    }

    @objc func addNewFile(){
        
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 10
        let vc = PHPickerViewController(configuration: configuration)
        vc.delegate = self
        present(vc, animated: true)
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
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        let group = DispatchGroup()
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    group.leave()
                }
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                let manager = FileManager.default
                let documentsUrl = self.getDocumentsUrl()
                let imageName = UUID().uuidString
                let imagePath = documentsUrl?.appending(path: imageName + ".jpg")
                let data = image.jpegData(compressionQuality: 1.0)
                manager.createFile(atPath: (imagePath?.path())!, contents: data)
            }
        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    func getDocumentsUrl() -> URL? {
        let manager = FileManager.default
        do {
            return try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            print(error)
            return nil
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return "Documents"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + ".   " + self.files[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            let manager = FileManager.default
            let files = self.files
            let pathForDel = self.path + "/" + files[indexPath.row]
            let group = DispatchGroup()
            group.enter()
            do {
                try manager.removeItem(at: URL(fileURLWithPath: pathForDel))
            } catch {
                print(error.localizedDescription)
            }
            group.leave()
            group.notify(queue: .main) {
                tableView.reloadData()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            complete(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
               configuration.performsFirstActionWithFullSwipe = true
               return configuration
    }
    
}

class TableViewCell: UITableViewCell { }
