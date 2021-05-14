import Foundation
import UIKit
import CoreData

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var folderImage: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(folderTapped(tapGestureRecognizer:)))
        folderImage.isUserInteractionEnabled = true
        folderImage.addGestureRecognizer(tapGestureRecognizer)
        DispatchQueue.global().async {
            while (true) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                sleep(AppDelegate.updateTime)
            }
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        exit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "folders" {
            let destination = segue.destination as! TaskDetailsViewController
            if segue.identifier == "taskDetails" {
                let cell = sender as! TaskCell
                destination.task = cell.task
                cell.setSelected(false, animated: true)
            }
        }
    }
    
    @objc func folderTapped(tapGestureRecognizer: UITapGestureRecognizer) {
       performSegue(withIdentifier: "folders", sender: self)
    }
    
    func handleDelete(task: Task) {
        let helper = HttpHelper(url: AppDelegate.url + "delete/")
        helper.request(params: ["id": task.id!], method: .POST)
    }
    
    func handleDone(task: Task) {
        let helper = HttpHelper(url: AppDelegate.url + "mark/")
        helper.request(params: ["id": task.id!], method: .POST)
    }
    
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Task.tasks.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let cell = tableCell as! TaskCell
        let task = Task.tasks[indexPath.row]
        cell.im.image = task.icon
        cell.label.text = task.title
        cell.label.textColor = task.done ? .blue : .black
        cell.task = task
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = Task.tasks[indexPath.row]
        let action = UIContextualAction(style: .normal, title: task.done ? "Вернуть" : "Сделано") { [weak self] (action, view, completionHandler) in
            self?.handleDone(task: task)
            completionHandler(true)
        }
        action.backgroundColor = task.done ? .systemGreen : .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = Task.tasks[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            self?.handleDelete(task: task)
            completionHandler(true)
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }


}

extension UIViewController {
    func exit() {
        AppDelegate.token = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Token>(entityName: "Token")
        let systems = try? context.fetch(request)
        let entity = systems![0]
        context.delete(entity)
        try? context.save()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "login")
        self.navigationController?.pushViewController(vc, animated: false)
        var VC = self.navigationController!.viewControllers
        while VC.count != 1 {
            VC.remove(at: 0)
        }
    }
}
