import SwiftUI
import SwiftData
struct PodoConfigurationView: View {
    var isNew:Bool
    var uid:UUID?
    @FocusState private var isFocused:Bool
    @State var taskName:String=""
    @State var selectedTotalTime:Int=30
    @State var selectedRestTime:Int=5
    @State var selectedCycleNum:Int=4
    @State private var maxLength:Int = 12
    // 添加模型上下文，用于访问本地数据库
    @Environment(\.modelContext) private var modelContext
    // 添加此变量，用于点击完成按钮后，返回原界面
    @Environment(\.presentationMode) var presentationMode
    // 查询所有podo
    @Query private var podos: [Podomoro]
    var body: some View {
        ZStack {
            VStack(alignment:.leading){
                HStack {
                    Label(
                        title:{
                            Text("任务：")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        }, 
                        icon:{
                            Image("tasks")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 35,height: 35)
                        }
                    )
                    TextField("待办事项", text: Binding(
                        get: 
                            {
                                self.taskName
                            },
                        set: 
                            {
                                newValue in
                            // 直接使用count属性来计算字符长度
                                if newValue.count > maxLength
                                {
                                // 如果超过maxLength，截断字符串
                                    self.taskName = String(newValue.prefix(maxLength))
                                }
                                else
                                {
                                    self.taskName = newValue
                                }
                            }
                        )
                    )
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding([.trailing], 10)
                }
                .padding([.leading], 10)
                .padding([.top],40)
                HStack{
                    Spacer()
                    Text("*任务最长不超过\(maxLength)个字符")
                        .font(.subheadline)
                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.trailing)
                        .padding([.trailing],10)
                        
                }
                HStack{
                    Label(
                        title:{
                            Text("总时长：")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        },
                        icon:{
                            Image("hourglass")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 35,height: 35)
                        }
                    )
                    .padding([.leading],10)
                    MyStepper(width:100, height:100,range: 10...60,initNum:30, selectedNumber:$selectedTotalTime)
                        .foregroundColor(.black)
                    Text("分钟")
                        .font(.largeTitle)
                }
//                .padding([.leading],10)
                .padding([.trailing], 10)
                .padding([.top],20)
                HStack{
                    Label(
                        title:{
                            Text("休息：")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        },
                        icon:{
                            Image("hourglass")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 35,height: 35)
                        }
                    )
                    .padding([.leading],10)
                    Spacer()
                    MyStepper(width:110, height:100,range: 5...10,initNum:5, selectedNumber:$selectedRestTime)
                        .foregroundColor(.black)
                    Text("分钟")
                        .font(.largeTitle)
                }
//                .padding([.leading],10)
                .padding([.trailing], 10)
                .padding([.top],20)
                HStack{
                    Label(
                        title:{
                            Text("循环：")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        },
                        icon:{
                            Image("circulate")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 35,height: 35)
                        }
                    )
                    .padding([.leading],10)
                    Spacer()
                    MyStepper(width:110, height:100,range: 1...24,initNum:4, selectedNumber:$selectedCycleNum)
                        .foregroundColor(.black)
                    Text("次数")
                        .font(.largeTitle)
                }
                .padding([.trailing], 10)
                .padding([.top],20)
                Button(
                    action:
                        {
                            if(isNew)
                            {
                                // 在这里定义点击按钮后的动作
                                // podo的uid直接调用UUID随机生成
                                let podo = Podomoro(
                                    uid:UUID()
                                        .uuidString,
                                    task: taskName,
                                    totalTime: selectedTotalTime,
                                    breakTime: selectedRestTime,
                                    cycleTimes: selectedCycleNum
                                )
                                modelContext.insert(podo)
                            }
                            else
                            {
                                let len = podos.count
                                for id in podos.indices
                                {
                                    if(podos[id].uid == self.uid)
                                    {
                                        podos[id].task = self.taskName
                                        podos[id].totalTime = selectedTotalTime
                                        podos[id].breakTime = selectedRestTime
                                        podos[id].cycleTimes = selectedCycleNum
                                        break
                                    }
                                    else
                                    {
                                        //do nothing
                                    }
                                }
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }
                )
                {
                    Text("完成")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                            .padding()
                Spacer()
                
            }
            
        }
        .frame(minWidth:0, maxWidth:.infinity, minHeight: 0, maxHeight: .infinity)
//        .background(Color.black)
    }
}
struct previews:PreviewProvider{
    @State static var test:Int=30
    @State static var taskName:String=""
    @State static var rest:Int=5
    @State static var cycle:Int=6
    
    static var previews:some View{
        PodoConfigurationView(isNew:true)/*(taskName:$taskName,selectedTotalTime:$test,selectedRestTime: $rest,selectedCycleNum: $cycle)*/
    }
}
//#Preview {
//    @State var test:Int=0
//    PodoConfigurationView(selectedTotalTime:$test)
//}
