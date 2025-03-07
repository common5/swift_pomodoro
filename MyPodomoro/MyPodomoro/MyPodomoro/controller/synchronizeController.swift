//
//  synchronizeController.swift
//  MyPodomoro
//
//  Created by admin on 2024/1/1.
//

import Foundation
import SwiftData

struct PullRequest: Codable
{
    let user_id:Int64
}

struct TmpPodo:Codable
{
    var configure_id:String
    var task:String
    var totalTime:Int
    var breakTime:Int
    var cycleTimes:Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.configure_id = try container.decode(String.self, forKey: .configure_id)
        self.task = try container.decode(String.self, forKey: .task)
        self.totalTime = try container.decode(Int.self, forKey: .totalTime)
        self.breakTime = try container.decode(Int.self, forKey: .breakTime)
        self.cycleTimes = try container.decode(Int.self, forKey: .cycleTimes)
    }
    init(a:String, b:String, c:Int, d:Int, e:Int)
    {
        configure_id = a
        task = b
        totalTime = c
        breakTime = d
        cycleTimes = e
    }
}

struct PullResponse: Codable
{
    let ok:String
    let value:[TmpPodo]?
    let message:String?
}
struct PushRequest: Codable
{
    let user_id:Int64
    let podos:[TmpPodo]
}
struct PushResponse: Codable
{
    let ok:String?
    let value:Int32?
    let message:String?
}

func sendPullRequest(user_id: Int64) async -> PullResponse? {
    let url = URL(string: "http://43.142.90.90:5042/api/resource/pullFromCloud")!
    var request = URLRequest(url: url)
//    var loginSucceed = false;
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let pullRequest = PullRequest(user_id: user_id)
    do {
        request.httpBody = try JSONEncoder().encode(pullRequest)
    } catch {
        print("Error encoding login request: \(error)")
//        loginSucceed = false
    }
    do {
        // Use async variant of URLSession data task
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            // Handle the response code appropriately
            print("Error: HTTP request failed")
            return nil
        }
        
        let pullResponse = try JSONDecoder().decode(PullResponse.self, from: data)
        // Handle the response here
        return pullResponse

    } catch {
        print("Error during networking: \(error)")
        return nil
    }
    return nil
}

func sendPushRequest(user_id: Int64, podos:[Podomoro]) async -> PushResponse? {
    let url = URL(string: "http://43.142.90.90:5042/api/resource/pushToCloud")!
    var request = URLRequest(url: url)
    //    var loginSucceed = false;
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    var len = podos.count
    var tmp = [TmpPodo]()
    for i in 0..<len{
        let a:String = podos[i].uid.uuidString
        let b:String = podos[i].task
        let c:Int = podos[i].totalTime
        let d:Int = podos[i].breakTime
        let e:Int = podos[i].cycleTimes
        tmp.append(TmpPodo(a:a, b:b, c:c, d:d, e:e))
    }
    let pushRequest = PushRequest(user_id: user_id, podos:tmp)
    do {
        request.httpBody = try JSONEncoder().encode(pushRequest)
    } catch {
        print("Error encoding login request: \(error)")
//        loginSucceed = false
    }
    do {
        // Use async variant of URLSession data task
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            // Handle the response code appropriately
            print("Error: HTTP request failed")
            return nil
        }
        
        let pushResponse = try JSONDecoder().decode(PushResponse.self, from: data)
        // Handle the response here
        return pushResponse

    } catch {
        print("Error during networking: \(error)")
        return nil
    }
    return nil
}
