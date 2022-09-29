//
//  CardListViewController.swift
//  CreaditCardList
//
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore

class CardListViewController: UITableViewController {
//    var ref: DatabaseReference! //Firebase Realtime Database를 가져올 수 있는 reference
    var db = Firestore.firestore()
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")

        //Firestore database를 사용하기 위해 realtime database를 주석처리
//        ref = Database.database().reference()
//
//        ref.observe(.value) { snapshot in
//        //ref가 .value값을 observe (바라보게)
//        //바라본 다음에는 snapshot이 발생
//            guard let value = snapshot.value as? [String: [String: Any]] else { return }
//            //value는 snapshot의 .value이다. 어떤 형태일 것이냐 - (각자가 만든 데이터 형식에 따라 다르다)
//
//            //json 디코딩
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value)
//                //jsondata는 무슨값일까. JSONSerialization을 통해 json을 받는다
//                //snapshot을 통해 가져온 value가 될 것이다
//                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
//                //어떤 형태일 것이냐. JSONDecoder로 만들어준다. 우리가 만들것은 [String: CreditCard]형태
//                let cardList = Array(cardData.values)
//                //cardList는 array가 될 것이고 Dictionary값이므로 value값만 가져온다
//
//                //가져온 카드리스트를 미리 만들어 놓은 creditCardList에 넣기
//                self.creditCardList = cardList.sorted { $0.rank < $1.rank }
//                //카드의 랭크 기준으로 카드를 정렬을 해준다
//
//                //tableView를 reload해야한다, tableview는 UI의 움직임이고 UI는 메인쓰레드에서 제공되기 때문에 이 클로저 안에서도 메인에서 보도록 지정해야한다 -> 메인쓰레드에 해당 액션을 넣는것
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            } catch let error {
//                print("ERROR JSON parsing \(error.localizedDescription)")
//            }
//        }
        
        //Firestore 읽기
        db.collection("creaditCardList").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
            //snapshot을 통해 documents가 있을 때만 통과
                print("ERROR Firestore fetching document \(String(describing: error))")
                return
            }
            
            self.creditCardList = documents.compactMap { doc -> CreditCard? in
            //documents를 바라본다. compactMap은 nil값을 반환했을 경우 nil값을 배열안에 넣지 않기 위함
            //like optional처리
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                } catch let error {
                    print("ERROR JSON Parsing \(error)")
                    return nil
                }
            }.sorted { $0.rank < $1.rank }
            //해당 배열을 1 ~ 10 랭크순 정렬
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
            
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        //String타입인 cardImageURL을 URL타입으로 타입변환
        cell.cardImageView.kf.setImage(with: imageURL)
        //Kingfisher에서 제공하는 문법
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //상세화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        //Option1 경로를 알 때
//        let cardID = creditCardList[indexPath.row].id
//        ref.child("Item\(cardID)/isSelected").setValue(true)
        //path라는 것은 어떤 경로, 즉 카드아이디
        
        //Option2 경로를 모를 때
//        let cardID = creditCardList[indexPath.row].id
//        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//        //"id"라는 것으로 검색, "id"에 있는 value가 cardID와 같은 객체를 가져오라고 명령, observe로 value를 본다
//        //특정 키의 값이 cardID와 같은 객체를 찾아서 snapshot으로 찍는것, 데이터 읽기과 비슷
//            guard let self = self,
//                  let value = snapshot.value as? [String: [String: Any]],
//                  let key = value.keys.first else { return }
//            //snapshot으로 찍은 value를 다시 추출해서 해당 레퍼런스에 값을 업데이트 즉 쓰기
//            self.ref.child("\(key)/isSelected").setValue(true)
//            //가져온 키에 해당하는 것을 isSelected를 true로 설정
//        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            //Option1 경로를 알 때
//            let cardID = creditCardList[indexPath.row].id
//            ref.child("item\(cardID)").removeValue()
            //"item\(cardID)" 경로에 있는 데이터 전체가 삭제된다

//            //Option2 경로를 모를 때
//            let cardID = creditCardList[indexPath.row].id
//            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//                guard let self = self,
//                      let value = snapshot.value as? [String: [String: Any]],
//                      let key = value.keys.first else { return }
//                //snapshot의 value는 array값으로 전달이 됨
//                self.ref.child(key).removeValue()
//            }
        }
    }
}
