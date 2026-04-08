import SVProgressHUD
import UIKit

class FaqVC: BaseVC {

    @IBOutlet weak var lblPageTitle: UILabel!
    
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var tvList: UITableView!
    
    var faqList:[ModelFAQ] = []
    var faqExpend:[Bool] = []
    var faqCategoryList:[ModelFAQCategory] = []
    var selectedCategory = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        loadFAQCategoryList() // category and item
        loadFAQList(-1)
    }
    
    private func initVC() {
        cvCategory.register(UINib(nibName: "cvc_faq", bundle: nil), forCellWithReuseIdentifier: "FaqCVC")

        tvList.register(UINib(nibName: "tvc_faq", bundle: nil), forCellReuseIdentifier: "FaqTVC")
    }
    
    //
    // MARK: - ACTION
    //

    @IBAction func onUpdateVersion(_ sender: Any) {
    }
}

//
// MARK: - RestApi
//
extension FaqVC: BaseRestApi {
    func loadFAQList(_ catId:Int) {
        LoadingDialog.show()
        Rest.getFAQList(faqItemId: catId, success: { [weak self] (result) -> Void in
            LoadingDialog.dismiss()
            let faqList = result as! ModelFAQList
            self?.faqList.removeAll()
            for faq in faqList.list {
                self?.faqList.append(faq)
                self?.faqExpend.append(false)
            }
            
            self?.tvList.reloadData()

        }) { (_, err) -> Void in
            LoadingDialog.dismiss()
            self.view.showToast(err)
        }
    }

    func loadFAQCategoryList() {
        LoadingDialog.show()
        Rest.getFAQCategoryList(success: { [weak self] (result) -> Void in
            LoadingDialog.dismiss()
            
            let faqList = result as! ModelFAQCateList
            
            self?.faqCategoryList.removeAll()
            self?.faqCategoryList.append(ModelFAQCategory())
            
            self?.faqCategoryList.append(contentsOf: faqList.list)
            self?.cvCategory.reloadData()
            
            //self?.loadFAQList(-1)

        }, failure: { (_, err) -> Void in
            LoadingDialog.dismiss()
            self.view.showToast(err)
        })
    }
}

//
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//

extension FaqVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return faqCategoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaqCVC", for: indexPath) as! FaqCVC
        let index = indexPath.row
        cell.setData(text: faqCategoryList[index].name, isSelect: selectedCategory == indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCategory != indexPath.row {
            let oldIndexPath = IndexPath(item: selectedCategory, section: 0)
            selectedCategory = indexPath.row
            collectionView.reloadItems(at: [oldIndexPath, indexPath])
            
            loadFAQList(faqCategoryList[selectedCategory].faq_id)
        }
    }
}

//
// MARK: - UITableViewDataSource, UITableViewDelegate
//
extension FaqVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTVC", for: indexPath) as! FaqTVC
        let index = indexPath.row
        cell.setData(data: faqList[index], isExpand: faqExpend[index])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        faqExpend[indexPath.row] = !faqExpend[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
