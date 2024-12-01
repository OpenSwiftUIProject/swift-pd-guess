//
//  PDGuess.swift
//  swift-pd-guess
//
//  Created by Kyle on 2024/12/1.
//

import Foundation
import ArgumentParser
import Algorithms
import CryptoKit

@main
struct PDGuess: AsyncParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(commandName: "swift-pd-guess")
    
    @Argument(help: "MD5 hash value (private-discriminator) to search for")
    var hash: String
    
    @Argument(help: "Possible words (comma separated)")
    var words: String
    
    @Option(help: "Prefix of the search (ususally the module name)")
    var prefix: String
    
    @Option(help: "Suffix of the search")
    var suffix: String = ".swift"
    
    @Option(help: "Max count of words to combine")
    var maxCount: Int = 4
    
    func run() async throws {
        let wordsArray = words.split(separator: ",").map(String.init)
        let targetHash = hash.uppercased()
        print("Try brute force hash: \(hash) with dictionary \(wordsArray) max-\(maxCount)")
        
        if let result = try await findMatch(wordsArray: wordsArray, targetHash: targetHash) {
            print("Found match: \(result)")
        } else {
            print("No match found")
        }
    }
    
    private func findMatch(wordsArray: [String], targetHash: String) async throws -> String? {
        return try await withThrowingTaskGroup(of: String?.self) { taskGroup in
            for length in 1...min(wordsArray.count, maxCount) {
                let permutations = Array(wordsArray.permutations(ofCount: length))
                let chunkSize = max(permutations.count / ProcessInfo.processInfo.processorCount, 1)
                
                for chunk in permutations.chunks(ofCount: chunkSize) {
                    let localPrefix = prefix
                    let localSuffix = suffix
                    
                    taskGroup.addTask {
                        for perm in chunk {
                            let combined = perm.joined()
                            let filename = "\(localPrefix)\(combined)\(localSuffix)"
                            let computedHash = filename.md5
                            
                            if computedHash == targetHash {
                                return filename
                            }
                        }
                        return nil
                    }
                }
                // Check result
                for try await result in taskGroup {
                    if let match = result {
                        taskGroup.cancelAll()
                        return match
                    }
                }
            }
            return nil
        }
    }
}

extension String {
    var md5: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhX", $0) }.joined()
    }
}
