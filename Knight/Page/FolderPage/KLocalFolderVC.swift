//
//  KLocalFolderVC.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/5.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import UIKit

class KLocalFolderVC: KBaseVC
{
    var subpaths = [String]()
    var files = [String]()
    var folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    lazy var tableView: KTableView = {
        let table = KTableView(style: .plain, vc: self)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(path: URL) {
        super.init(nibName: nil, bundle: nil)
        folderPath = path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var contents = [String]()
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: folderPath.path)
        } catch {
        }
        title = folderPath.lastPathComponent
        subpaths.append("..")
        var isDirectory: ObjCBool = false
        for name in contents {
            let fullName = folderPath.appendingPathComponent(name)
            FileManager.default.fileExists(atPath: fullName.path, isDirectory: &isDirectory)
            if isDirectory.boolValue {
                subpaths.append(name)
            } else {
                files.append(name)
            }
        }

        view.addSubview(tableView)        
    }
}

extension KLocalFolderVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return subpaths.count
        case 1:
            return files.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "play")
        if nil == cell {
            cell = UITableViewCell(style: .default, reuseIdentifier: "play")
        }
        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = "[\(subpaths[indexPath.row])]"
            cell?.accessoryType = .disclosureIndicator
        case 1:
            cell?.textLabel?.text = files[indexPath.row]
            cell?.accessoryType = .none
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let path = folderPath.appendingPathComponent(subpaths[indexPath.row])
            navigationController?.pushViewController(KLocalFolderVC(path: path), animated: true)
        case 1:
            let fullPath = folderPath.appendingPathComponent(files[indexPath.row])
            KMoviePlayVC.presntFromeVC(vc: self, title: files[indexPath.row], url: URL(fileURLWithPath: fullPath.path)) {
                
            }
        default:
            break
        }
    }
}
