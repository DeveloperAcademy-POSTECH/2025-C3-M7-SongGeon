//
//  TaskType.swift
//  MungDo
//
//  Created by 제하맥 on 6/3/25.
//

import SwiftUI

enum TaskType: String, CaseIterable, Identifiable, Hashable {
    case heartworm
    case walk
    case vaccination
    case bath
    case externalParasite
    
    var id: String { rawValue }
    
    //Mark: 태스크 텍스트로
    var displayName: String {
        switch self {
        case .heartworm: return "심장사상충 약 먹이기"
        case .walk: return "산책하기"
        case .vaccination: return "광견병·코로나 예방접종하기"
        case .bath: return "목욕하기"
        case .externalParasite: return "외부기생충 약 먹이기"
        }
    }
    
    //Mark: 태스크 아이콘 이미지
    var displayIcon: Image {
        switch self {
        case .heartworm: return Image("heartwormIcon")
        case .walk: return Image("walkIcon")
        case .vaccination: return Image("vaccinationIcon")
        case .bath: return Image("bathIcon")
        case .externalParasite: return Image("externalParasiteIcon")
        }
    }
    //임시 파일명이므로 나중에 아이콘 이미지 제작 완료 후 수정 필요
    
    //Mark: 권장 태스크 주기 (태스크당 주기)
    var defaultCycle: Int {
        switch self {
        case .heartworm: return 30
        case .vaccination: return 365
        case .bath: return 365
        case .externalParasite: return 365
        case .walk: return 7
        }
    }
    
    //Mark: 권장 태스크 주기 설명
    var defaultCycleDescription: String {
        switch self {
        case .heartworm: return "한 달마다 반복됩니다"
        case .vaccination: return "1년마다 반복됩니다"
        case .bath: return "1년마다 반복됩니다"
        case .externalParasite: return "1년마다 반복됩니다"
        case .walk: return "일주일마다 반복됩니다"
            
        }
    }
}
