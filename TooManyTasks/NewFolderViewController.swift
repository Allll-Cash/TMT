import Foundation
import UIKit

class NewFolderViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var forthImage: UIImageView!
    @IBOutlet weak var fifthImage: UIImageView!
    var images: [UIImageView]!
    
    let names = ["mappin.and.ellipse", "list.triangle", "sun.min.fill", "diamond.fill", "link"]
    
    let selectedColor: UIColor = .systemGreen
    var selectedName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [firstImage, secondImage, thirdImage, forthImage, fifthImage]
        for image in images {
            image.isUserInteractionEnabled = true
        }
        firstTapped(tapGestureRecognizer: UITapGestureRecognizer())
        firstImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstTapped(tapGestureRecognizer:))))
        secondImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondTapped(tapGestureRecognizer:))))
        thirdImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thirdTapped(tapGestureRecognizer:))))
        forthImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forthTapped(tapGestureRecognizer:))))
        fifthImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fifthTapped(tapGestureRecognizer:))))
    }
    
    func clearAll() {
        for image in images {
            image.backgroundColor = .clear
        }
    }
    
    @objc func firstTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        clearAll()
        selectedName = names[0]
        firstImage.backgroundColor = selectedColor
    }
    
    @objc func secondTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        clearAll()
        selectedName = names[1]
        secondImage.backgroundColor = selectedColor
    }
    
    @objc func thirdTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        clearAll()
        selectedName = names[2]
        thirdImage.backgroundColor = selectedColor
    }
    
    @objc func forthTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        clearAll()
        selectedName = names[3]
        forthImage.backgroundColor = selectedColor
    }
    @objc func fifthTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        clearAll()
        selectedName = names[4]
        fifthImage.backgroundColor = selectedColor
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        let name = nameTextField.text!
        let httpHelper = HttpHelper(url: AppDelegate.url + "folders/")
        httpHelper.request(params: ["name": name, "icon":  selectedName!], method: .POST)
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
