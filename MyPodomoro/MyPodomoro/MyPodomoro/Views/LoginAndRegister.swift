//
//  LoginAndRegister.swift
//  MyPodomoro
//
//  Created by admin on 2023/12/31.
//

import SwiftUI
import SwiftData
struct USER:View {
    @State var account = ""
    @State var user_id:Int64?
    @State var registerResponse:RegisterResponse?
    var body: some View {
        if(user_id == nil)
        {
            LoginView(account:$account,user_id:$user_id, registerResponse:$registerResponse)
        }
        else
        {
            isLoginView(account:$account, user_id:$user_id)
        }
    }
}
struct isLoginView:View
{
    @Environment(\.modelContext) private var modelContext
    @Binding var account:String
    @Binding var user_id:Int64?
//    @State private var pswd:String=""
    @State private var info:String=""
    @Query private var podos: [Podomoro]
//    @State VAR info = ""
    let session = URLSession.shared
    let urlLogin = URL(string:"http://43.142.90.90/api/resource/synchronize")!
    var body: some View {
        VStack
        {
            HStack {
                Spacer()
                Image("tomato")
                    .resizable()
                .frame(width:360,height:360)
                Spacer()
            }
            HStack {
                Spacer()
                TextField("", text:$info)
                Spacer()
            }
            HStack
            {
                Spacer()
                VStack(alignment:.center)
                {
                    Text("你好！")
                        .font(.largeTitle)
                }
                Spacer()
            
            }
//            .padding([.leading], 120)
//            .padding([.trailing], 20)
//            HStack {
//                Spacer()
//                Text("密码：")
//                    .font(.largeTitle)
//                SecureField("请输入密码", text:$pswd)
//                    .font(.largeTitle)
//                    .disabled(true)
//                Spacer()
//            }
//            .padding([.leading], 40)
//            .padding([.trailing], 20)
            HStack {
                Spacer()
                VStack{
                    Button("同步到云端")
                    {
                        Task
                        {
                            await sendPushRequest(user_id:user_id!, podos:podos)
                        }
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width:240,height:40)
                    )

                    Button("从云端同步")
                    {
                        Task
                        {
                            let ret = await sendPullRequest(user_id:user_id!)
                            if(ret == nil)
                            {
                                info = "系统错误！！"
                            }
                            else
                            {
                                for i in 0..<podos.count
                                {
                                    modelContext.delete(podos[i])
                                }
                                for i in 0..<ret!.value!.count
                                {
                                    let tmp = ret!.value![i]
                                     let podo = Podomoro(
                                     uid:tmp.configure_id,
                                     task:tmp.task,
                                     totalTime:tmp.totalTime,
                                     breakTime:tmp.breakTime,
                                     cycleTimes:tmp.cycleTimes
                                    )
                                    addPodo(podo:podo)
                                }
//                                ForEach(ret!.value!, id:\.configure_id)
//                                {
//                                    tmp in
//                                    let podo = Podomoro(
//                                        uid:tmp.configure_id,
//                                        task:tmp.task,
//                                        totalTime:tmp.totalTime,
//                                        breakTime:tmp.breakTime,
//                                        cycleTimes:tmp.cycleTimes
//                                    )
//                                    addPodo(podo:podo)
//                                }
                            }
                        }
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width:240,height:40)
                    )
                    .padding([.top], 5)
                }
                Spacer()
                
                
            }.padding([.top],15)
            
        }
        .background(.white)
    }
    private func addPodo(podo:Podomoro) {
        modelContext.insert(podo)
    }
}

struct LoginView: View {
    @Binding var account:String
//    @Binding var isLogin:Bool
    @Binding var user_id:Int64?
    @State var pswd:String=""
    @State private var info:String=""
    @Binding var registerResponse:RegisterResponse?
    let session = URLSession.shared
    let urlLogin = URL(string:"http://43.142.90.90/api/user/login")!
    let urlRegister = URL(string:"http://43.142.90.90/api/user/Register")!
    var body: some View {
        VStack(alignment:.leading)
        {
            HStack {
                Spacer()
                Image("tomato")
                    .resizable()
                .frame(width:360,height:360)
                Spacer()
            }
            HStack {
                Spacer()
                TextField("", text:$info)
                Spacer()
            }
            HStack
            {
                Spacer()
                Text("账号：")
                    .font(.largeTitle)
                TextField("请输入账号", text:$account)
                    .font(.largeTitle)
                Spacer()
            
            }
            .padding([.leading], 40)
            .padding([.trailing], 20)
            HStack {
                Spacer()
                Text("密码：")
                    .font(.largeTitle)
                SecureField("请输入密码", text:$pswd)
                    .font(.largeTitle)
                Spacer()
            }
            .padding([.leading], 40)
            .padding([.trailing], 20)
            HStack {
                Spacer()
                Button("登录")
                {
                    withAnimation{
                        Task{
                            user_id = await sendLoginRequest(account:account,password:pswd)
                            print(user_id)
                            info = user_id == nil ? "登录失败":"登录成功"
                        }
                        
                        print(user_id)
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width:120,height:40)
                )
                Spacer()
                Button("注册")
                {
                    withAnimation{
                        Task{
                            registerResponse = await sendRegisterRequest(account:account,password:pswd)
                            let tmp = registerResponse?.message
                            info = tmp == nil ? "":tmp!
                            user_id = registerResponse?.value
                        }
                        
                        print(user_id)
                        print(1)
//                        info = user_id == nil ? "YES":"NO"
//                        print(user_id)
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width:120,height:40)
                )
//                Button("注册")
//                {
//                    withAnimation
//                    {
//                        Task{
//                            user_id = await sendLoginRequest(account:account,password:pswd)
//                        }
////                        Task {
////                            registerResponse = await sendRegisterRequest(account:account, password: pswd)
////                        }
//                    }
//                }
//                .font(.largeTitle)
//                .foregroundColor(.white)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.blue)
//                        .frame(width:120,height:40)
//                )
                Spacer()
            }.padding([.top],15)
            
        }
        .background(.white)
    }
}

struct logPreview:PreviewProvider{
    @State var account:String=""
    @State var pswd:String=""
    
    static var previews:some View{
        USER()
    }
}
