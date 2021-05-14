import Foundation
import UIKit

class Folder {
    var id: Int!
    var name: String!
    var owner: String!
    var icon: UIImage!
    
    static var folders: [Folder] = []
    
    static func create(data: [String: Any]) -> Folder {
        let folder = Folder()
        folder.id = data["id"] as? Int
        folder.name = data["name"] as? String
        folder.owner = data["owner"] as? String
        folder.icon = UIImage(systemName: data["icon"] as! String)
        return folder
    }
    
    static func fetchFolders() {
        let helper = HttpHelper(url: AppDelegate.url + "folders/")
        DispatchQueue.global(qos: .background).async {
            while (true) {
                helper.request(params: [:], method: .GET, onSuccess: {data in
                    folders = []
                    for entity in data["folders"] as! [[String: Any]] {
                        folders.append(Folder.create(data: entity))
                    }
                }, onFail: nil)
                sleep(AppDelegate.updateTime)
            }
        }
    }
}
