import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var httpHelper = HttpHelper(url: AppDelegate.url + "auth/")
    
    @IBOutlet weak var activity: UIActivityIndicatorView! {
        didSet {
            activity.isHidden = true
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.layer.borderColor = UIColor(red: CGFloat(55) / 255, green: CGFloat(78) / 255, blue: CGFloat(42) / 255, alpha: 1.0).cgColor
            emailTextField.layer.cornerRadius = CGFloat(5)
            emailTextField.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = CGFloat(20)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        activity.isHidden = false
        self.view.endEditing(true)
        httpHelper.request(params: ["email": emailTextField.text ?? ""], method: RequestMethod.GET)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        httpHelper.delegate = self
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.backgroundColor = .green
        if let _ = AppDelegate.token {
            performSegue(withIdentifier: "skip", sender: self)
            self.navigationController?.viewControllers.remove(at: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "skip" {
            let destVC = segue.destination as! VerifyCodeViewController
            destVC.email = emailTextField.text
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension LoginViewController: HttpHelperDelegate {
    func onFail() {
        let alert = UIAlertAction(title: "Ок", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Не удалось подключиться к серверу", message: "Проверьте подключение к интернету", preferredStyle: .alert)
        alertController.addAction(alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onSuccess(data: [String: Any]) {
        performSegue(withIdentifier: "verify", sender: self)
    }
    
    func onFinish() {
        activity.isHidden = true
    }
    
    
}
