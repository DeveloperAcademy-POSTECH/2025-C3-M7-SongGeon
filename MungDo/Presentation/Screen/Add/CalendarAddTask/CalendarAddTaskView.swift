//
//  CalendarAddTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI
import SwiftData

struct CalendarAddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let taskType: TaskType
    var onComplete: () -> Void
    @State var selectedDate: Date
    @State private var cycleDays: Int
    @State private var showingCycleOptions = false

    init(taskType: TaskType, onComplete: @escaping () -> Void, selectedDate: Date) {
        self.taskType = taskType
        self.onComplete = onComplete
        self._selectedDate = State(initialValue: selectedDate)
        self._cycleDays = State(initialValue: taskType.defaultCycle)
    }

    // 주기 옵션들
    private let cycleOptions = [
        (1, "매일"),
        (7, "일주일마다"),
        (14, "2주마다"),
        (30, "한 달마다"),
        (90, "3개월마다"),
        (365, "1년마다")
    ]

    var body: some View {
        VStack(spacing: 40) {
            // 제목
            HStack {
                Text("'\(taskType.displayName)' 언제부터 시작할까요?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }

            // 캘린더 view
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 628, height: 403)
                    .background(.white)
                    .cornerRadius(20)

                TestCalendarView(selectedDate: $selectedDate)
                    .aspectRatio(1.6, contentMode: .fit)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .frame(maxWidth: 800)
                Spacer()
            }
            .padding(.top, 50)

            // 반복 주기 설정
//            VStack(spacing: 16) {
//                HStack {
//                    Text("반복 주기")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.black)
//                    Spacer()
//                }
//
//                Button(action: {
//                    showingCycleOptions.toggle()
//                }) {
//                    HStack {
//                        Text(getCycleDisplayText())
//                            .font(.system(size: 16))
//                            .foregroundColor(.black)
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .foregroundColor(.gray)
//                            .rotationEffect(.degrees(showingCycleOptions ? 180 : 0))
//                    }
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.white)
//                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    )
//                }
//
//                if showingCycleOptions {
//                    LazyVStack(spacing: 8) {
//                        ForEach(cycleOptions, id: \.0) { option in
//                            Button(action: {
//                                cycleDays = option.0
//                                showingCycleOptions = false
//                            }) {
//                                HStack {
//                                    Text(option.1)
//                                        .font(.system(size: 16))
//                                        .foregroundColor(.black)
//                                    Spacer()
//                                    if cycleDays == option.0 {
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(Color("ButtonPrimary"))
//                                    }
//                                }
//                                .padding()
//                                .background(Color.white)
//                            }
//                        }
//                    }
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.white)
//                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    )
//                    .animation(.easeInOut(duration: 0.3), value: showingCycleOptions)
//                }
//            }

            Spacer()

            // 완료 버튼
            HStack {
                Spacer()
                Button(action: {
                    saveTaskSchedule()
                    onComplete()
                }) {
                    CustomButtonLabel(title: "완료")
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundPrimary"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 20)
                        .foregroundColor(Color("ButtonSecondary"))
                }
            }
        }
        .toolbarBackground(Color("BackgroundPrimary"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    // MARK: - Helper Methods

    private func getCycleDisplayText() -> String {
        return cycleOptions.first { $0.0 == cycleDays }?.1 ?? "사용자 정의 (\(cycleDays)일마다)"
    }

    private func saveTaskSchedule() {
        let newSchedule = TaskScheduleEntity(taskType: taskType, startDate: selectedDate)
        modelContext.insert(newSchedule)

        do {
            try modelContext.save()
            print("TaskSchedule saved successfully")
        } catch {
            print("Failed to save TaskSchedule: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        CalendarAddTaskView(
            taskType: .walk,
            onComplete: {},
            selectedDate: Date()
        )
    }
    .modelContainer(for: [TaskItemEntity.self, TaskScheduleEntity.self])
}
