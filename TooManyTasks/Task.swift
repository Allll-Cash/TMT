import Foundation
import UIKit

class Task {
    var id: Int!
    var title: String!
    var description: String!
    var folder: Folder!
    var done: Bool!
    
    static var tasks: [Task] = []
    
    var icon: UIImage {
        return folder.icon
    }
    
    static func create(data: [String: Any]) -> Task {
        let task = Task()
        task.id = data["id"] as? Int
        task.title = data["title"] as? String
        task.description = data["description"] as? String
        task.done = (data["done"] as! Int) == 1
        task.folder = Folder.create(data: data["folder"] as! [String: Any])
        return task
    }
    
    static func fetchTasks() {
        let helper = HttpHelper(url: AppDelegate.url + "tasks/")
        DispatchQueue.global(qos: .background).async {
            while (true) {
                helper.request(params: [:], method: .GET, onSuccess: {data in
                    tasks = []
                    for entity in data["tasks"] as! [[String: Any]] {
                        tasks.append(Task.create(data: entity))
                    }
                }, onFail: nil)
                sleep(AppDelegate.updateTime)
            }
        }
    }
}
