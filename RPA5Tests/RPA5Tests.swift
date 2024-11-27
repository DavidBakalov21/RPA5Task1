//
//  RPA5Tests.swift
//  RPA5Tests
//
//  Created by david david on 20.11.2024.
//

import Testing
@testable import RPA5
import XCTest

final class HW5Tests: XCTestCase {
    lazy var bank = BankAccount()
    // Deposit
    func testDepositNegativeValue() throws {
        bank.deposit(amount: -10)
        
        XCTAssertEqual(bank.transactionHistory.count, 0)
        XCTAssertEqual(bank.deposit, 0)
        XCTAssertEqual(bank.balance, 0)
    }
    func testDepositPositiveValue() throws {
        bank.deposit(amount: 10)
        
        XCTAssertEqual(bank.transactionHistory.count, 1)
        XCTAssertEqual(bank.deposit, 10)
        XCTAssertEqual(bank.balance, 10)
    }
    
    // Withdraw
    func testWithdrawPositiveValueFromBiggerDeposit() throws {
        bank.deposit(amount: 100)
        let res = bank.withdraw(amount: 10)
        
        XCTAssertEqual(bank.transactionHistory.count, 2)
        XCTAssertEqual(bank.deposit, 90)
        XCTAssertEqual(bank.balance, 90)
        XCTAssertEqual(res, true)
    }
    func testWithdrawPositiveValueFromSmallerDeposit() throws {
        let res = bank.withdraw(amount: 10)
        XCTAssertEqual(bank.transactionHistory.count, 0)
        XCTAssertEqual(bank.deposit, 0)
        XCTAssertEqual(bank.balance, 0)
        XCTAssertEqual(res, false)
    }
    func testWithdrawNegativeValueFromDeposit() throws {
        let res = bank.withdraw(amount: -90)
        XCTAssertEqual(bank.transactionHistory.count, 0)
        XCTAssertEqual(bank.deposit, 0)
        XCTAssertEqual(bank.balance, 0)
        XCTAssertEqual(res, false)
    }
    
    // takeCredit
    func testTakeCreditBiggerThenLimit() throws {
        let res = bank.takeCredit(amount: 100000)
        
        XCTAssertEqual(bank.transactionHistory.count, 0)
        XCTAssertEqual(bank.creditBalance, 0)
        XCTAssertEqual(bank.creditLoan, 0)
        XCTAssertEqual(bank.balance, 0)
        XCTAssertEqual(res, false)
    }
    func testTakeCreditAmountLessThenLimitNoLoan() throws {
        let res = bank.takeCredit(amount: 100)
        XCTAssertEqual(bank.transactionHistory.count, 1)
        XCTAssertEqual(bank.creditBalance, 100)
        XCTAssertEqual(bank.creditLoan, 100)
        XCTAssertEqual(bank.balance, 100)
        XCTAssertEqual(res, true)
    }
    func testTakeCreditNegatieAmount() throws {
        let res = bank.takeCredit(amount: -100)
        XCTAssertEqual(bank.transactionHistory.count, 0)
        XCTAssertEqual(bank.creditBalance, 0)
        XCTAssertEqual(bank.creditLoan, 0)
        XCTAssertEqual(bank.balance, 0)
        XCTAssertEqual(res, false)
    }
    // payCredit
    func testPayCreditOutsideAccaptableRange() throws {
        _ = bank.takeCredit(amount: 100)
        let res = bank.payCredit(amount: 190)
        
        XCTAssertEqual(bank.transactionHistory.count, 1)
        XCTAssertEqual(bank.creditLoan, 100)
        XCTAssertEqual(res, false)
    }
    
    func testPayCreditAmountWithinAccaptableRange() throws {
        _ = bank.takeCredit(amount: 100)
        let res = bank.payCredit(amount: 90)
        XCTAssertEqual(bank.transactionHistory.count, 2)
        XCTAssertEqual(bank.creditLoan, 10)
        XCTAssertEqual(res, true)
    }
    
    func testPayCreditNegativeAmount() throws {
        _ = bank.takeCredit(amount: 100)
        let res = bank.payCredit(amount: -90)
        XCTAssertEqual(bank.transactionHistory.count, 1)
        XCTAssertEqual(bank.creditLoan, 100)
        XCTAssertEqual(res, false)
    }
    // getTransactionHistory
    func testGetTransactionHistory() throws {
        bank.deposit(amount: 10)
        bank.deposit(amount: 10)
        bank.deposit(amount: 10)
        bank.deposit(amount: 10)
        bank.deposit(amount: 10)
        XCTAssertEqual(bank.getTransactionHistory().count, 5)
    }
}
