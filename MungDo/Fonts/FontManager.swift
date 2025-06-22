//
//  FontManager.swift
//  MungDo
//
//  Created by 제하맥 on 6/22/25.
//

import UIKit

class FontManager {
    /// 커스텀 폰트들을 등록하는 메인 함수
    static func registerCustomFonts() {
        let fontNames = ["SUIT-Bold", "SUIT-Medium"]
        
        for fontName in fontNames {
            registerFont(fontName: fontName)
        }
    }
    
    /// 개별 폰트를 등록하는 함수
    private static func registerFont(fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
            print("❌ \(fontName).ttf 파일을 찾을 수 없습니다")
            return
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("❌ \(fontName) 데이터 프로바이더 생성 실패")
            return
        }
        
        guard let font = CGFont(fontDataProvider) else {
            print("❌ \(fontName) CGFont 생성 실패")
            return
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if success {
            print("✅ \(fontName) 폰트 등록 성공!")
            
            if let postScriptName = font.postScriptName {
                print("   📝 PostScript 이름: \(postScriptName)")
            }
        } else {
            if let error = error?.takeRetainedValue() {
                print("❌ \(fontName) 폰트 등록 실패: \(CFErrorCopyDescription(error))")
            }
        }
    }
}
