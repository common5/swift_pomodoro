//
//  PomodoroListView.swift
//  MyPodomoro
//
//  Created by admin on 2023/12/31.
//
import SwiftUI
import SwiftData
struct PodomoroListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var podos: [Podomoro]
    @State var showConfigurationView = false
    @State var isNew:Bool=true
//    var callback:()->void
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(podos, id:\.uid) { podo in
                    NavigationLink {
//                        PodoConfigurationView(isNew:false, uid:podo.uid)
                        PodoRunningView(cycles:podo.cycleTimes,workDuration: Double(podo.totalTime), breakDuration: Double(podo.breakTime))
                    } label: {
                        Text("\(podo.task),时长：\(podo.totalTime)min,休息：\(podo.breakTime)min,循环\(podo.cycleTimes)次")
                            .swipeActions(edge:.leading, allowsFullSwipe: true){
                                NavigationLink {
                                    PodoConfigurationView(isNew:false, uid:podo.uid)
                                } label: {
                                    Label("操作", systemImage: "pencil")
                                }
                                .tint(.blue) // 设置按钮颜色
                            }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) 
                {
                    EditButton()
                }
                ToolbarItem{
                    NavigationLink
                    {
                        HelpView()
                    }
                    label:
                    {
                        Label("help", systemImage:"help")
                    }
                }
                ToolbarItem
                {
                    NavigationLink 
                    {
                        PodoConfigurationView(isNew:true)
                    } 
                    label:
                    {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("")
        }
        if(showConfigurationView)
        {
            PodoConfigurationView(isNew:self.isNew)
        }
    }

    private func addPodo() {
        self.isNew = true
        withAnimation {
            modelContext.insert(Podomoro(uid:UUID().uuidString,task:"1",totalTime: 30, breakTime: 5, cycleTimes:4))
//            showConfigurationView.toggle()
//            PodoConfigurationView(isNew: true)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(podos[index])
            }
        }
    }
}

//#Preview {
//    PodomoroListView()
//        .modelContainer(for:Podomoro.self, inMemory:true)
//}
