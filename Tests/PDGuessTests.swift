//
//  PDGuessTests.swift
//  swift-pd-guess-tests
//
//  Created by Kyle on 2024/12/1.
//

import XCTest
@testable import swift_pd_guess

class PDGuessTests: XCTestCase {
    func makeGuess(wordsCount: Int, maxCount: Int) -> PDGuess {
        var force = PDGuess()
        force.hash = ""
        force.words = (1...wordsCount).map(String.init).joined(separator: ",")
        force.prefix = ""
        force.suffix = ""
        force.maxCount = maxCount
        return force
    }
    
    // 0.022s
    func testMeasure8_4() {
        measure {
            let exp = expectation(description: "Finished")
            Task {
                try await makeGuess(wordsCount: 8, maxCount: 4).run()
                exp.fulfill()
            }
            wait(for: [exp], timeout: 200.0)
        }
    }
    
    // 1.19s
    func testMeasure8_8() {
        measure {
            let exp = expectation(description: "Finished")
            Task {
                try await makeGuess(wordsCount: 8, maxCount: 8).run()
                exp.fulfill()
            }
            wait(for: [exp], timeout: 200.0)
        }
    }

    // Example playground
    func testExample() {
        let exp = expectation(description: "Finished")
        Task {
            var force = PDGuess()
            force.hash = "3a792cb70cfcf892676d7adf8bca260f"
            force.words = "Color"
            force.prefix = "SwiftUICore"
            force.suffix = ".swift"
            force.maxCount = 5
            try await force.run()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 200.0)
    }
}
