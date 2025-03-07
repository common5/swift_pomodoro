//
//  MyStepper.swift
//  MyPodomoro
//
//  Created by admin on 2023/12/31.
//

import SwiftUI

struct MyStepper: View {
    // 定义一个状态变量来存储选中的数字
    let width:CGFloat
    let height:CGFloat
    let range:ClosedRange<Int>
    let initNum:Int
    @Binding var selectedNumber:Int
    var body:some View{
        // 创建一个滚动选择器
        Picker(selection: $selectedNumber, label: Text("选择一个数字")) {
            // 为每个数字创建一个视图
            ForEach(Array(range), id:\.self) { number in
                Text("\(number)")
                    .scaleEffect(scaleValue(for: number))
                    .opacity(opacityValue(for: number))
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(width: width, height: height) // 限制滚动选择器的高度
        .clipped()
        .onAppear {
            // 初始化时选择中间的值
            selectedNumber = initNum
        }
    }
    // 根据数字与选中数字的距离计算缩放值
    func scaleValue(for number: Int) -> CGFloat {
        let diff = CGFloat(abs(selectedNumber - number))
        return max(1 - diff / 20, 0.5)
    }
    
    // 根据数字与选中数字的距离计算透明度
    func opacityValue(for number: Int) -> Double {
        let diff = abs(selectedNumber - number)
        return max(1 - Double(diff) / 20, 0.1)
    }
    
    func getNumber()->Int{
        return selectedNumber
    }
}


