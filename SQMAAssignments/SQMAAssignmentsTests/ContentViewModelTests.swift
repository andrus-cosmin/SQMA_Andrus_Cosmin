//
//  ContentViewModelTests.swift
//  SQMAAssignments
//
//  Created by Cosmin Andrus on 14.01.2026.
//

import Testing
@testable import SQMAAssignments
import SwiftUI

@Suite("ContentViewModel Tests")
struct ContentViewModelTests {

    @Test("Initial state values")
    func initialState() {
        let vm = ContentViewModel()
        #expect(vm.title == "Name Challenge")
        #expect(vm.subtitle == "Type a name and see if it's cool!")
        #expect(vm.nameLabel == "Type a name")
        #expect(vm.checkNameButtonText == "Check Name")
        #expect(vm.name.isEmpty)
        #expect(vm.feedbackType == nil)
        #expect(vm.processButtonEnabled == false)
        #expect(vm.feedbackString == nil)
        #expect(vm.feedbackColor == .white)
    }

    @Test("Process button enabled toggles with name emptiness")
    func processButtonEnabledBehavior() {
        let vm = ContentViewModel()
        #expect(vm.processButtonEnabled == false)
        vm.name = "A"
        #expect(vm.processButtonEnabled == true)
        vm.name = ""
        #expect(vm.processButtonEnabled == false)
    }

    @Test("checkName results in .cool when vowels > non-vowels")
    func checkNameCool() throws {
        let vm = ContentViewModel()
        vm.name = "AaeB" // vowels=3, nonVowels=1
        vm.checkName()
        #expect(vm.feedbackType == .cool)
        let str = try #require(vm.feedbackString)
        #expect(str == "This is a cool name!")
        #expect(vm.feedbackColor == .green)
    }

    @Test("checkName results in .almostCool when vowels == non-vowels")
    func checkNameAlmostCool() throws {
        let vm = ContentViewModel()
        vm.name = "ab" // vowels=1, nonVowels=1
        vm.checkName()
        #expect(vm.feedbackType == .almostCool)
        let str = try #require(vm.feedbackString)
        #expect(str == "Not bad, but not cool name either.")
        #expect(vm.feedbackColor == .orange)
    }

    @Test("checkName results in .notCool when vowels < non-vowels")
    func checkNameNotCool() throws {
        let vm = ContentViewModel()
        vm.name = "bbb" // vowels=0, nonVowels=3
        vm.checkName()
        #expect(vm.feedbackType == .notCool)
        let str = try #require(vm.feedbackString)
        #expect(str == "Keep trying, you're getting there!")
        #expect(vm.feedbackColor == .red)
    }

    @Test("Changing name resets feedbackType and derived properties")
    func changingNameResetsFeedback() {
        let vm = ContentViewModel()
        vm.name = "bbb"
        vm.checkName()
        #expect(vm.feedbackType == .notCool)
        vm.name = "a" // triggers didSet to reset feedbackType
        #expect(vm.feedbackType == nil)
        #expect(vm.feedbackString == nil)
        #expect(vm.feedbackColor == .white)
    }
}
