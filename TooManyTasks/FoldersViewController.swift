import Foundation
import UIKit

class FoldersViewController: UIViewController {
    
    @IBOutlet weak var tasksImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var paused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tasksTapped(tapGestureRecognizer:)))
        tasksImage.isUserInteractionEnabled = true
        tasksImage.addGestureRecognizer(tapGestureRecognizer)
        collectionView.delegate = self
        collectionView.dataSource = self
        DispatchQueue.global().async {
            while (true) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                sleep(AppDelegate.updateTime)
            }
        }
    }
    
    @objc func tasksTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        paused = true
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func exitPressed(_ sender: Any) {
        exit()
    }
    
}

extension FoldersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Folder.folders.count
        print(count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCell
        cell.text.text = Folder.folders[indexPath.item].name
        cell.im.image = Folder.folders[indexPath.item].icon
        return cell
    }
    
    
}

extension FoldersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (CGFloat(self.view.window?.frame.size.width ?? 1000) - 160) / 2
        print(width)
        return CGSize(width: width * 1.2, height: width / 1.2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(20), left: CGFloat(40), bottom: CGFloat(20), right: CGFloat(40))
    }

}
