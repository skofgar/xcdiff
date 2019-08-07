//
// Copyright 2019 Bloomberg Finance L.P.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
@testable import XCDiffCommand
import XCTest

final class CommandsRunnerTests: XCTestCase {
    private var sut: CommandRunner!
    private var printer: PrinterMock!
    private var system: SystemMock!
    private let fixtures = Fixtures()

    override func setUp() {
        super.setUp()

        printer = PrinterMock()
        system = SystemMock()

        sut = CommandRunner(printer: printer, system: system)
    }

    func testRun_whenDifferentProjectsFilterUnsupportedTags() {
        // Given
        let command = buildCommand("-g", "targets, unsupported, unsupported_too")

        // When
        let code = sut.run(with: command)

        // Then
        XCTAssertEqual(printer.output, "Unsupported tag(s) \"UNSUPPORTED\", \"UNSUPPORTED_TOO\"\n")
        XCTAssertEqual(code, 1)
    }

    func testRun_whenP1NotExists() {
        // Given
        let nonExistingPath = fixtures.project.non_existing().string
        let command = [
            "-p1", nonExistingPath,
            "-p2", fixtures.project.ios_project_2().string,
        ]

        // When
        let code = sut.run(with: command)

        // Then
        let expected = "-p1 \"\(nonExistingPath)\" project does not exist\n"
        XCTAssertEqual(printer.output, expected)
        XCTAssertEqual(code, 1)
    }

    func testRun_whenP2NotExists() {
        // Given
        let nonExistingPath = fixtures.project.non_existing().string
        let command = [
            "-p1", fixtures.project.ios_project_1().string,
            "-p2", nonExistingPath,
        ]

        // When
        let code = sut.run(with: command)

        // Then
        let expected = "-p2 \"\(nonExistingPath)\" project does not exist\n"
        XCTAssertEqual(printer.output, expected)
        XCTAssertEqual(code, 1)
    }

    func testRun_whenBothNotExist() {
        // Given
        let nonExistingPath = fixtures.project.non_existing().string
        let command = [
            "-p1", nonExistingPath,
            "-p2", nonExistingPath,
        ]

        // When
        let code = sut.run(with: command)

        // Then
        let expected = "-p1 \"\(nonExistingPath)\" project does not exist\n"
        XCTAssertEqual(printer.output, expected)
        XCTAssertEqual(code, 1)
    }

    func testRun_whenUnknownArguments() {
        // Given
        let command = ["unknown", "arguments"]

        // When
        let code = sut.run(with: command)

        // Then
        XCTAssertEqual(printer.output, "unexpected argument unknown; use --help to list available arguments\n")
        XCTAssertEqual(code, 1)
    }

    func testRun_whenProjectsNotSpecifiedButExistInCurrentDirectory() {
        // Given
        let command: [String] = []
        system.listCurrentDirectoryReturn = [
            fixtures.project.ios_project_1().string,
            fixtures.project.ios_project_1().string,
        ]

        // When
        let code = sut.run(with: command)

        // Then
        XCTAssertEqual(printer.output, """
        ✅ TARGETS > NATIVE targets
        ✅ TARGETS > AGGREGATE targets
        ✅ SOURCES > "Project" target
        ✅ SOURCES > "ProjectTests" target
        ✅ SOURCES > "ProjectUITests" target


        """)
        XCTAssertEqual(code, 0)
    }

    func testRun_whenProjectsNotSpecifiedAndNotExistInCurrentDirectory() {
        // Given
        let command: [String] = []
        let nonExistingPath = fixtures.project.non_existing().string
        system.listCurrentDirectoryReturn = [
            nonExistingPath,
            fixtures.project.ios_project_2().string,
        ]

        // When
        let code = sut.run(with: command)

        // Then
        let expected = "The project cannot be found at \(nonExistingPath)\n"
        XCTAssertEqual(printer.output, expected)
        XCTAssertEqual(code, 1)
    }

    func testRun_whenProjectsNotSpecifiedAndMoreThen2ProjectInCurrentDirectory() {
        // Given
        let command: [String] = []
        let nonExistingPath = fixtures.project.non_existing().string
        system.listCurrentDirectoryReturn = [
            nonExistingPath,
            fixtures.project.ios_project_1().string,
            fixtures.project.ios_project_2().string,
        ]

        // When
        let code = sut.run(with: command)

        // Then
        let expected = "Could not find 2 projects in the current directory\n"
        XCTAssertEqual(printer.output, expected)
        XCTAssertEqual(code, 1)
    }

    // MARK: - Private

    private func buildCommand(p1: String? = nil, p2: String? = nil, _ args: String...) -> [String] {
        return [
            "-p1", p1 ?? fixtures.project.ios_project_1().string,
            "-p2", p2 ?? fixtures.project.ios_project_2().string,
        ] + args
    }
}