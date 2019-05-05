//
//  KHistoryModel.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/6.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

class KHistoryItem: NSObject, NSCoding
{
    var title: String!
    var url: URL!
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        title = aDecoder.decodeObject(forKey: "title") as? String
        url = aDecoder.decodeObject(forKey: "url") as? URL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "url")
        aCoder.encode(title, forKey: "title")
    }
    
}

class KHistoryModel
{
    lazy var plistPath: String = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
        return path.appendingPathComponent("Knight_History.plist").path
    }()
    
    lazy var listArray: [KHistoryItem] = {
        if let list = NSKeyedUnarchiver.unarchiveObject(withFile: plistPath) as? [KHistoryItem] {
            return list
        } else {
            return [KHistoryItem]()
        }
    }()
    
    static let shared = KHistoryModel()
    
    func remove(index: Int) {
        listArray.remove(at: index)
        NSKeyedArchiver.archiveRootObject(listArray, toFile: plistPath)
    }
    
    func add(item: KHistoryItem) {
        var findIndex = -1
        for (index, enumItem) in listArray.enumerated() {
            if item.url == enumItem.url {
                findIndex = index
                break
            }
        }
        
        if findIndex != -1 {
            listArray.remove(at: findIndex)
        }
        
        listArray.insert(item, at: 0)
        NSKeyedArchiver.archiveRootObject(listArray, toFile: plistPath)
    }
}
