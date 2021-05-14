import Foundation
import UIKit
import CoreData

class VerifyCodeViewController: UIViewController {
    
    var email: String!
    
    @IBOutlet weak var titleTextField: UILabel!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        titleTextField.text = "Код был отправлен на почту " + email
    }
    
    @IBAction func repeatButtonPressed(_ sender: Any) {
        let helper = HttpHelper(url: AppDelegate.url + "auth/")
        helper.delegate = self
        helper.request(params: ["email": email!], method: .GET)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func valueChanged(_ sender: Any) {
        if codeTextField.text?.count == 5 {
            let helper = HttpHelper(url: AppDelegate.url + "auth/")
            helper.request(params: ["email": email!, "code": codeTextField.text ?? ""], method: .POST, onSuccess: { data in
                if data["success"] as! Bool {
                    AppDelegate.token = data["token"] as? String
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "Token", in: context)!
                    let newSystem = Token(entity: entity, insertInto: context)
                    newSystem.token = AppDelegate.token
                    try? context.save()
                    let navController = self.navigationController!
                    self.performSegue(withIdentifier: "main", sender: self)
                    for _ in 0..<2 { navController.viewControllers.remove(at: 0) }
                } else {
                    self.alert(title: "Некорректный код", message: "Проверьте код на почте и введите его еще раз")
                }
            }) {
                self.serverConnectionAlert()
            }
        }
    }
}

extension VerifyCodeViewController: HttpHelperDelegate {
    func onSuccess(data: [String : Any]) {
        alert(title: "Код успешно отправлен", message: "Проверьте почтовый ящик")
    }
    
    func onFail() {
        serverConnectionAlert()
    }
    
    func onFinish() {
        
    }
    
    
}

extension UIViewController {
    func alert(title: String, message: String) {
        let alert = UIAlertAction(title: "Ок", style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func serverConnectionAlert() {
        alert(title: "Не удалось подключиться к серверу", message: "Проверьте подключение к интернету")
    }
}
