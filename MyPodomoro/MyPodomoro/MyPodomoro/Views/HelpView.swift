//
//  HelpView.swift
//  MyPodomoro
//
//  Created by admin on 2023/12/31.
//

import SwiftUI

struct HelpView: View 
{
    @State private var isShowingView = 1

    var body: some View 
    {
        VStack {
            if(isShowingView == 1)
            {
                Help1()
            }
            else if(isShowingView == 2)
            {
                Help2()
            }
            else if(isShowingView == 3)
            {
                Help3()
            }
            else if(isShowingView == 4)
            {
                Help4()
            }
            else if(isShowingView == 5)
            {
                Help5()
            }
            HStack {
                Button("上一页")
                {
                    withAnimation
                    {
                        if(isShowingView > 1)
                        {
                            isShowingView -= 1
                        }
                        else
                        {
                            isShowingView = 5
                        }
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width:150,height:40)
                ) // 圆角框背景
                .padding([.leading],50)
                Spacer()
                Button("下一页")
                {
                    withAnimation 
                    {
                        if(isShowingView < 5)
                        {
                            isShowingView += 1
                        }
                        else
                        {
                            isShowingView = 1
                        }
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width:150,height:40)
                ) // 圆角框背景
                .padding([.trailing],50)
            }
        }
    }
}
struct Help1:View
{
    var body: some View
    {
        VStack(alignment:.leading)
        {
            HStack {
                Text("Q1.如何新建番茄钟")
                    .font(.title)
                    .padding([.top],30)
                    .padding([.bottom], 10)
                Spacer()
            }
        }
        .padding(.leading, 35)
        VStack(alignment:.leading)
        {
            HStack
            {
                Text("A1: 点击右上角'+'即可")
                    .font(.title)
            }
            VStack
            {
                Image("help_add")
                    .padding([.top],10)
                Spacer()
            }
        }
    }
}
struct Help2:View 
{
    var body: some View 
    {
        VStack(alignment:.leading)
        {
            Text("Q2.如何删除番茄钟")
                .font(.title)
                .padding([.top],30)
                .padding([.bottom], 10)
//            Text("A2:")
//                .font(.title2)
            Text("Step1:右上角单击'step'")
                .font(.title2)
            Image("d1")
            Text("Step2:点击左侧'-'")
                .font(.title2)
            Image("d2")
            Spacer()
        }
    }
}
struct Help3:View 
{
    var body: some View {
        VStack(alignment:.leading)
        {
            Text("Q2.如何删除番茄钟")
                .font(.title)
                .padding([.top],30)
                .padding([.bottom], 10)
            Text("Step3:单击'delete'按钮")
                .font(.title2)
            Image("d3")
            Text("Step4:单击'Done'结束")
                .font(.title2)
            Image("d4")
            Spacer()
        }
    }
}
struct Help4:View
{
    var body: some View
    {
        VStack(alignment:.leading)
        {
            Text("Q3.如何修改番茄钟")
                .font(.title)
                .padding([.top],30)
                .padding([.bottom], 10)
            Text("step1:右滑要修改的番茄钟")
                .font(.title2)
            Image("m1")
            Text("step2:单击铅笔图标")
                .font(.title2)
            Image("m2")
            Text("step3:在修改界面进行属性修改")
                .font(.title2)
            Text("step4:修改完点击完成按钮即可")
                .font(.title2)
                .padding([.top],30)
                .padding([.bottom], 10)
            Spacer()
        }
    }
}
struct Help5:View
{
    var body: some View
    {
        VStack(alignment:.leading)
        {
            Text("Q4.如何启动番茄钟")
                .font(.title)
                .padding([.top],30)
                .padding([.bottom], 10)
            Text("step1:单击要启动的番茄钟")
                .font(.title2)
            Image("s1")
            Text("step2:点击开始按钮即可")
                .font(.title2)
            Image("m2")
            Spacer()
        }
    }
}
#Preview {
    HelpView()
}
