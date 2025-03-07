//
//  PodoRunningView.swift
//  MyPodomoro
//
//  Created by admin on 2023/12/31.
//

import SwiftUI
import UserNotifications
import AVFoundation

struct PodoRunningView: View {
    // 番茄钟的工作时间和休息时间（以秒为单位）
    var workDuration: TimeInterval
    var breakDuration: TimeInterval
    var cycles:Int

    // 当前计时器的剩余时间和总时间
    @State private var timeRemaining: TimeInterval
    @State private var totalTime: TimeInterval
    @State private var cycleTimes: Int

    // 是否在工作模式
    @State private var isWorkMode = true

    // 计时器
    @State private var timer: Timer?

    // 铃声播放器
    @State private var audioPlayer: AVAudioPlayer?

    init(cycles:Int,workDuration:TimeInterval, breakDuration:TimeInterval) {
        self.cycles = cycles
        self.workDuration = workDuration * 60
        self.breakDuration = breakDuration * 60
        _timeRemaining = State(initialValue: self.workDuration)
        _totalTime = State(initialValue: self.workDuration)
        _cycleTimes = State(initialValue: self.cycles)
    }

    var body: some View {
        VStack {
            Text(isWorkMode ? "工作时间" : "休息时间")
                .font(.largeTitle)

            // 环形进度条
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.timeRemaining / self.totalTime, 1.0)))
                .stroke(isWorkMode ? Color.blue : Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(Angle(degrees: 270.0))
                .frame(width: 200, height: 200)

            // 显示剩余时间
            Text(timeString(from: self.timeRemaining))
                .font(.title)

            // 开始/停止按钮
            Button(action: {
                if self.timer == nil {
                    self.startTimer()
                } else {
                    self.stopTimer()
                }
            }) {
                Text(timer == nil ? "开始" : "停止")
            }
            
            Text("剩余\(cycleTimes)轮")
        }
        .onAppear(perform: setupAudioPlayer)
    }

    private func startTimer() {
        if(cycleTimes == 0)
        {
            cycleTimes += cycles
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.switchMode()
                self.playSound()
                self.sendNotification()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func switchMode() {
        isWorkMode.toggle()
        if(isWorkMode)
        {
            cycleTimes -= 1
        }
        timeRemaining = isWorkMode ? workDuration : breakDuration
        totalTime = timeRemaining
        if(cycleTimes > 0){
            startTimer()
        }
    }

    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func setupAudioPlayer() {
        if let path = Bundle.main.path(forResource: "sound", ofType: "mp3") {
            let url = URL(fileURLWithPath:path)
            try? audioPlayer = AVAudioPlayer(contentsOf: url)
        }
    }

    private func playSound() {
        audioPlayer?.play()
    }

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = isWorkMode ? "休息时间!" : "工作时间!"
        content.body = isWorkMode ? "现在是休息时间。" : "现在是工作时间。"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}



//#Preview {
//    PodoRunningView()
//}
