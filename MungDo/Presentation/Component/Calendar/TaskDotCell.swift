//
//  TaskDotCell.swift
//  MungDo
//
//  Created by 문창재 on 6/4/25.
//

import SwiftUI
import FSCalendar

class TaskDotCell: FSCalendarCell {
    let customDot = UIView()

    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        customDot.backgroundColor = .systemRed
        customDot.layer.cornerRadius = 9
        customDot.isHidden = true
        contentView.addSubview(customDot)
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 원하는 위치에 점 배치 (가운데 아래쪽)
        let size: CGFloat = 18
        customDot.frame = CGRect(
            x: (contentView.bounds.width - size) / 2,
            y: contentView.bounds.height - size - 4,
            width: size,
            height: size
        )
    }

    override func configureAppearance() {
        super.configureAppearance()
        // 매번 갱신되므로 필요시 여기서 색상 설정 가능
    }
}
