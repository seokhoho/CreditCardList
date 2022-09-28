//
//  CreditCard.swift
//  CreaditCardList
//
//

import Foundation

//읽을 때는 JSON 디코딩
//쓸 때는 JSON 인코딩
//-> 따라서 코더블

struct CreditCard: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool? //사용자가 선택했을 때 생성
}

struct PromotionDetail: Codable {
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
