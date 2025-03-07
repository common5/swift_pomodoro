//
//  UsrView.swift
//  MyPodomoro
//
//  Created by admin on 2024/1/1.
//

import SwiftUI

struct UsrView: View {
    var body: some View {
        VStack
        {
            NavigationLink
            {
                
            }
            label: {
                Text("与podomoro云端同步")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .border(Color.black, width:1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width:150,height:40)
                    ) // 圆角框背景
            }
        }
    }
}

#Preview {
    UsrView()
}
