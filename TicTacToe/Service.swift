//
//  Service.swift
//  TicTacToe
//
//  Created by Mykhailo Seleznov on 12.04.2022.
//

import Foundation

struct Board: Codable {
    struct Position: Codable {
        let r: Int
        let c: Int
    }

    let x: [Position]
    let o: [Position]
}

class Service {
    var session: URLSession

    init() {
        session = URLSession.shared
    }

    func makeMove(board: Board, completion: @escaping (Board?) -> Void) {
        guard let url = URL(string: "https://glacial-retreat-66571.herokuapp.com/api") else {
//        guard let url = URL(string: "http://localhost:9292/api") else {
            return
        }
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(board) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data

        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }

            let decoder = JSONDecoder()

            guard let newBoard = try? decoder.decode(Board.self, from: data) else {
                completion(nil)
                return
            }

            completion(newBoard)
        }

        task.resume()
    }
}
