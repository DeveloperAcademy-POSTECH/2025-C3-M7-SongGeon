//
//  TaskCase.swift
//  MungDo
//
//  Created by cheshire on 6/1/25.
//

import Foundation

/// 반려견 관련 비정기적 작업 케이스
enum TaskCase: String, CaseIterable {
    // MARK: - 건강 관리
    case heartwormPrevention = "심장사상충 예방"
    case vaccination = "예방접종"
    case healthCheckup = "건강검진"
    case dentalCare = "치아 관리"
    case fleaTreatment = "진드기/벼룩 치료"
    case deworming = "구충제"
    case bloodTest = "혈액검사"
    
    // MARK: - 미용 관리
    case bathing = "목욕"
    case grooming = "전체 미용"
    case nailTrimming = "발톱 깎기"
    case earCleaning = "귀 청소"
    case toothBrushing = "양치질"
    case furTrimming = "털 다듬기"
    
    // MARK: - 교육 및 훈련
    case basicTraining = "기본 훈련"
    case behaviorCorrection = "행동 교정"
    case socialization = "사회화 훈련"
    case professionalTraining = "전문 훈련"
    
    // MARK: - 특별 관리
    case microchipRegistration = "마이크로칩 등록"
    case insurance = "펫보험 갱신"
    case emergencyPreparation = "응급상황 대비"
    case weightManagement = "체중 관리"
    case specialDiet = "특별 식단"
    
    // MARK: - 계절별 관리
    case summerCare = "여름철 관리"
    case winterCare = "겨울철 관리"
    case heatProtection = "더위 대비"
    case coldProtection = "추위 대비"
}

// MARK: - TaskCase Extensions
extension TaskCase {
    /// 작업의 카테고리
    var category: TaskCategory {
        switch self {
        case .heartwormPrevention, .vaccination, .healthCheckup, .dentalCare, .fleaTreatment, .deworming, .bloodTest:
            return .health
        case .bathing, .grooming, .nailTrimming, .earCleaning, .toothBrushing, .furTrimming:
            return .grooming
        case .basicTraining, .behaviorCorrection, .socialization, .professionalTraining:
            return .training
        case .microchipRegistration, .insurance, .emergencyPreparation, .weightManagement, .specialDiet:
            return .special
        case .summerCare, .winterCare, .heatProtection, .coldProtection:
            return .seasonal
        }
    }
    
    /// 작업의 우선순위
    var priority: TaskPriority {
        switch self {
        case .heartwormPrevention, .vaccination, .healthCheckup, .emergencyPreparation:
            return .high
        case .dentalCare, .fleaTreatment, .deworming, .bloodTest, .microchipRegistration, .insurance:
            return .medium
        case .bathing, .grooming, .nailTrimming, .earCleaning, .toothBrushing, .furTrimming,
             .basicTraining, .behaviorCorrection, .socialization, .professionalTraining,
             .weightManagement, .specialDiet, .summerCare, .winterCare, .heatProtection, .coldProtection:
            return .normal
        }
    }
    
    /// 권장 주기 (일 단위)
    var recommendedInterval: Int {
        switch self {
        case .heartwormPrevention:
            return 30 // 월 1회
        case .vaccination:
            return 365 // 연 1회
        case .healthCheckup:
            return 180 // 6개월마다
        case .dentalCare:
            return 180 // 6개월마다
        case .fleaTreatment, .deworming:
            return 90 // 3개월마다
        case .bloodTest:
            return 365 // 연 1회
        case .bathing:
            return 14 // 2주마다
        case .grooming:
            return 60 // 2개월마다
        case .nailTrimming:
            return 21 // 3주마다
        case .earCleaning:
            return 7 // 주 1회
        case .toothBrushing:
            return 1 // 매일
        case .furTrimming:
            return 45 // 6주마다
        case .basicTraining, .behaviorCorrection, .socialization:
            return 7 // 주 1회
        case .professionalTraining:
            return 30 // 월 1회
        case .microchipRegistration:
            return 3650 // 10년마다
        case .insurance:
            return 365 // 연 1회
        case .emergencyPreparation:
            return 180 // 6개월마다
        case .weightManagement:
            return 30 // 월 1회
        case .specialDiet:
            return 90 // 3개월마다
        case .summerCare, .winterCare:
            return 180 // 계절마다
        case .heatProtection, .coldProtection:
            return 365 // 연 1회
        }
    }
    
    /// 작업 설명
    var description: String {
        switch self {
        case .heartwormPrevention:
            return "심장사상충 예방약 투여"
        case .vaccination:
            return "종합백신 및 광견병 예방접종"
        case .healthCheckup:
            return "수의사 정기 건강검진"
        case .dentalCare:
            return "치아 스케일링 및 구강 관리"
        case .fleaTreatment:
            return "진드기, 벼룩 예방 및 치료"
        case .deworming:
            return "내부 기생충 구충제 투여"
        case .bloodTest:
            return "혈액검사를 통한 건강상태 확인"
        case .bathing:
            return "전신 목욕 및 세정"
        case .grooming:
            return "전체적인 미용 관리"
        case .nailTrimming:
            return "발톱 정리 및 관리"
        case .earCleaning:
            return "귀지 제거 및 귀 청소"
        case .toothBrushing:
            return "치아 및 잇몸 관리"
        case .furTrimming:
            return "털 정리 및 다듬기"
        case .basicTraining:
            return "기본 명령어 훈련"
        case .behaviorCorrection:
            return "문제 행동 교정 훈련"
        case .socialization:
            return "다른 동물 및 사람과의 사회화"
        case .professionalTraining:
            return "전문 훈련사와의 훈련"
        case .microchipRegistration:
            return "마이크로칩 등록 및 정보 업데이트"
        case .insurance:
            return "펫보험 갱신 및 점검"
        case .emergencyPreparation:
            return "응급상황 대비 용품 점검"
        case .weightManagement:
            return "체중 측정 및 관리"
        case .specialDiet:
            return "특별 식단 계획 검토"
        case .summerCare:
            return "여름철 더위 관리"
        case .winterCare:
            return "겨울철 추위 관리"
        case .heatProtection:
            return "고온 환경 보호 대책"
        case .coldProtection:
            return "저온 환경 보호 대책"
        }
    }
}

/// 작업 카테고리
enum TaskCategory: String, CaseIterable {
    case health = "건강 관리"
    case grooming = "미용 관리"
    case training = "교육 및 훈련"
    case special = "특별 관리"
    case seasonal = "계절별 관리"
    
    var icon: String {
        switch self {
        case .health:
            return "heart.fill"
        case .grooming:
            return "scissors"
        case .training:
            return "graduationcap.fill"
        case .special:
            return "star.fill"
        case .seasonal:
            return "thermometer"
        }
    }
}

/// 작업 우선순위
enum TaskPriority: String, CaseIterable {
    case high = "높음"
    case medium = "보통"
    case normal = "일반"
    
    var color: String {
        switch self {
        case .high:
            return "red"
        case .medium:
            return "orange"
        case .normal:
            return "green"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .high:
            return 0
        case .medium:
            return 1
        case .normal:
            return 2
        }
    }
}
