import Foundation
import UIKit

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.backgroundColor = .white
        }
    }
    @IBOutlet weak var button: UIButton!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        if let task = task {
            titleTextField.text = task.title
            textView.text = task.description
            button.setTitle("Изменить", for: .normal)
            picker.selectRow(Folder.folders.firstIndex(where: { folder in return folder.id == task.folder.id })!, inComponent: 0, animated: false)
        }
        self.picker.reloadAllComponents()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let helper = HttpHelper(url: AppDelegate.url + "tasks/")
        var params: [String: Any] = [:]
        if let task = task {
            params["id"] = task.id
        }
        params["title"] = titleTextField.text!
        params["description"] = textView.text!
        params["folder"] = Folder.folders[picker.selectedRow(inComponent: 0)].id
        helper.request(params: params, method: .POST)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

extension TaskDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Folder.folders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Folder.folders[row].name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    
}
