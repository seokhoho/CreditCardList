//
//  AppDelegate.swift
//  CreaditCardList
//
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        //db선언
        let db = Firestore.firestore()
        
        db.collection("creaditCardList").getDocuments { snapshot, _ in
            guard snapshot?.isEmpty == true else { return }
            //스냅샷이 비어져 있는지 확인
            let batch = db.batch()
            //batch안에 객체를 하나씩 넣을 수 있도록 파일경로(래퍼런스)를 만들어준다
            let card0Ref = db.collection("creaditCardList").document("card0")
            let card1Ref = db.collection("creaditCardList").document("card1")
            let card2Ref = db.collection("creaditCardList").document("card2")
            let card3Ref = db.collection("creaditCardList").document("card3")
            let card4Ref = db.collection("creaditCardList").document("card4")
            let card5Ref = db.collection("creaditCardList").document("card5")
            let card6Ref = db.collection("creaditCardList").document("card6")
            let card7Ref = db.collection("creaditCardList").document("card7")
            let card8Ref = db.collection("creaditCardList").document("card8")
            let card9Ref = db.collection("creaditCardList").document("card9")
            //더이메 있는 경로들을 각각의 경로에 갈 수 있도록 배치에 넣는다
            //setData()함수가 throw함수여서 try,do-catch 문으로 작성한다
            
            do {
                try batch.setData(from: CreditCardDummy.card0, forDocument: card0Ref)
                try batch.setData(from: CreditCardDummy.card1, forDocument: card1Ref)
                try batch.setData(from: CreditCardDummy.card2, forDocument: card2Ref)
                try batch.setData(from: CreditCardDummy.card3, forDocument: card3Ref)
                try batch.setData(from: CreditCardDummy.card4, forDocument: card4Ref)
                try batch.setData(from: CreditCardDummy.card5, forDocument: card5Ref)
                try batch.setData(from: CreditCardDummy.card6, forDocument: card6Ref)
                try batch.setData(from: CreditCardDummy.card7, forDocument: card7Ref)
                try batch.setData(from: CreditCardDummy.card8, forDocument: card8Ref)
                try batch.setData(from: CreditCardDummy.card9, forDocument: card9Ref)
            } catch let error {
                print("ERROR writing card to Firestore \(error.localizedDescription)")
            }
            //batch의 경우 셋팅만 하는 것이 아니라 반드시 commit()까지 해줘야한다
            batch.commit()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

