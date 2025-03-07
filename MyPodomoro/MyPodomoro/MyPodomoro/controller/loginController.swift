//
//  registerController.swift
//  MyPodomoro
//
//  Created by admin on 2024/1/1.
//

import Foundation
struct LoginRequest: Codable {
    let account: String
    let password: String
}

struct LoginResponse: Codable {
    let ok: String
    let value: Int64?
    let message: String?
}

func sendLoginRequest(account: String, password: String) async -> Int64? {
    let url = URL(string: "http://43.142.90.90:5042/api/user/login")!
    var request = URLRequest(url: url)
//    var loginSucceed = false;
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let loginRequest = LoginRequest(account: account, password: password)
    do {
        request.httpBody = try JSONEncoder().encode(loginRequest)
    } catch {
        print("Error encoding login request: \(error)")
        return nil
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
        
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        // Handle the response here
        print("Ok: \(loginResponse.ok)")
        print("Value: \(loginResponse.value ?? 0)")
        print("Message: \(loginResponse.message)")
        return loginResponse.value
    } catch {
        print("Error during networking: \(error)")
        return nil
    }
    return nil
}
