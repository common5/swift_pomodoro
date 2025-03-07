//
//  PomodoroModel.swift
//  MyPodomoro
//
//  Created by admin on 2023/12/31.
//

import Foundation
import SwiftData

@Model
final class Podomoro{
    var uid:UUID = UUID()
    var task:String
    var totalTime:Int
    var breakTime:Int
    var cycleTimes:Int
    init(task:String, totalTime:Int, breakTime:Int, cycleTimes:Int)
    {
        self.task = task
        self.totalTime = totalTime
        self.breakTime = breakTime
        self.cycleTimes = cycleTimes
    }
    init(uid:String, task:String, totalTime:Int, breakTime:Int, cycleTimes:Int)
    {
        self.uid = UUID(uuidString:uid)!
        self.task = task
        self.totalTime = totalTime
        self.breakTime = breakTime
        self.cycleTimes = cycleTimes
    }
    
}
