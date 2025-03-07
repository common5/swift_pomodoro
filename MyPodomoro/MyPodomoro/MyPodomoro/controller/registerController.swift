//
//  registerController.swift
//  MyPodomoro
//
//  Created by admin on 2024/1/1.
//

import Foundation
struct RegisterRequest: Codable {
    let account: String
    let password: String
}

struct RegisterResponse: Codable {
    let ok: String
    let value: Int64?
    let message: String?
}

func sendRegisterRequest(account: String, password: String) async -> RegisterResponse? {
    let url = URL(string: "http://43.142.90.90:5042/api/user/Register")!
    var request = URLRequest(url: url)
//    var loginSucceed = false;
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let registerRequest = RegisterRequest(account: account, password: password)
    do {
        request.httpBody = try JSONEncoder().encode(registerRequest)
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
        
        let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
        // Handle the response here
        print("Ok: \(registerResponse.ok)")
        print("Value: \(registerResponse.value ?? 0)")
        print("Message: \(registerResponse.message)")
        return registerResponse
    } catch {
        print("Error during networking: \(error)")
        return nil
    }
    return nil
}
