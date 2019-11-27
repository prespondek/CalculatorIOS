//
//  HugeInt.swift
//  Calculator
//
//  Created by Peter Respondek on 27/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
 

enum HugeNumberError: Error {
    case IllegalNumberError( String )
}

// A huge number class to handle numbers of any size (up to the max string lenght).
class HugeNumber {
    private var _number : String
    var negative : Bool = false

    var number : String {
        if (negative) {
            return "-" + _number
        }
        return _number
    }
    var count : Int {
        get {
            return _number.count
        }
    }
    
    init(_ number: String) {
        if (number.count > 0 && number[0] == "-") {
            negative = true
            self._number = number[1...number.count]
        } else {
            self._number = number
        }
        for char in self._number {
            assert(char.isNumber,"Number has non numerical characters in it.")
            break
        }
    }
    
    func append(_ str: String) {
        for char in str {
            assert(char.isNumber,"Number has non numerical characters in it.")
            break
        }
        _number.append(str)
    }
    func removeLast() {
        _number.removeLast()
    }
    
    static func +(_ left: HugeNumber,_ right: HugeNumber) -> HugeNumber {
        if (left.negative || right.negative) &&
            left.negative != right.negative {
            return HugeNumber(left._number) - HugeNumber(right._number)
        }
        let maximum = max(left.count, right.count) + 1
        var newNumber : String = ""
        var carry = 0
        for i in 1..<maximum {
            var x = 0
            var y = 0
            if (i < left.count + 1) {
                x = left._number[left.count - i].wholeNumberValue!
            }
            if (i < right.count + 1) {
                y = right._number[right.count - i].wholeNumberValue!
            }
            var num = x + y + carry
            carry = num / 10
            num = num % 10
            newNumber.append(String(num))
        }
        if carry > 0 {
            newNumber.append(String(carry))
        }
        return HugeNumber(String(newNumber.reversed()))
    }
    
    static func -(_ left: HugeNumber,_ right: HugeNumber) -> HugeNumber {
        if (left.negative || right.negative) &&
            left.negative != right.negative {
            let out = HugeNumber(left._number) + HugeNumber(right._number)
            out.negative = true
            return out
        }
        if (left.negative && right.negative) {
            let out = HugeNumber(left._number) - HugeNumber(right._number)
            out.negative = !out.negative
            return out
        }
        
        var left = left
        var right = right
        var negative = false
        
        if left < right {
            swap(&left, &right)
            negative = true
        }
        let maximum = max(left.count, right.count) + 1
        var newNumber : String = ""
        var carry = 0
        for i in 1..<maximum {
            var x = 0
            var y = 0
            if (i < left.count + 1) {
                x = left._number[left.count - i].wholeNumberValue!
            }
            if (i < right.count + 1) {
                y = right._number[right.count - i].wholeNumberValue!
            }
            var num = x - y - carry
            carry = num / 10
            num = abs(num % 10)
            newNumber.append(String(num))
        }
        if carry > 0 {
            newNumber.append(String(carry))
        }
        newNumber = String(newNumber.reversed())
        while 0 != newNumber.count {
            if newNumber[0] == "0" {
                newNumber.remove(at: newNumber.startIndex)
            } else {
                break
            }
        }
        let out = HugeNumber(newNumber)
        if (negative) {
            out.negative = true
        }
        return out
    }
    static func *(_ left: HugeNumber,_ right: HugeNumber) -> HugeNumber {
        return HugeNumber("0")
    }
    static func /(_ left: HugeNumber,_ right: HugeNumber) -> HugeNumber {
        //String result = "";
        //String num1 = this.Number;
        //String num2 = other.Number;
        /*var Select = right.count;
        String temp = left.substring(0, Select);
        BigNumber tempNum = new BigNumber(temp);
        int NumbersLeft = num1.length() - temp.length();
        BigNumber MultObject = new BigNumber("1");
        if (tempNum.compareTo(other) < 0) {
            temp = num1.substring(0, Select+1);
            tempNum.Number = temp;
            NumbersLeft--;
            Select++;
        }
        do {
            MultObject.Number = "0";
            int Index = 0;
            while (other.mult(MultObject).compareTo(tempNum) < 0) {
                Index++;
                MultObject.Number = Integer.toString(Index);
            }
            Index--;
            MultObject.Number = Integer.toString(Index);
            String Carry = tempNum.sub(other.mult(MultObject)).Number;
            if (NumbersLeft > 0) {
                Select++;
                Carry += num1.charAt(Select - 1);
                NumbersLeft--;
            }
            result += Index;
            tempNum.Number = Carry;
        }while (NumbersLeft > 0);
        MultObject.Number = "0";
        int Index = 0;
        while (other.mult(MultObject).compareTo(tempNum) < 0) {
            Index++;
            MultObject.Number = Integer.toString(Index);
        }
        Index--;
        MultObject.Number = Integer.toString(Index);
        String Carry = tempNum.sub(other.mult(MultObject)).Number;
        if (NumbersLeft > 0) {
            Select++;
            Carry += num1.charAt(Select - 1);
            NumbersLeft--;
        }
        result += Index;
        tempNum.Number = Carry;
            BigNumber Big = new BigNumber(result);
            return Big;
        }
        return HugeNumber("0")*/
    }
    static func -=(_ left: inout HugeNumber,_ right: HugeNumber) {
        left = left - right
    }
    static func +=(_ left: inout HugeNumber,_ right: HugeNumber) {
        left = left + right
    }
    static func *=(_ left: inout HugeNumber,_ right: HugeNumber) {
        left = left * right
    }
    static func /=(_ left: inout HugeNumber,_ right: HugeNumber) {
        left = left / right
    }
    static func <(_ left: inout HugeNumber,_ right: inout HugeNumber) -> Bool {
        if ( left.negative && !right.negative) { return true }
        if ( !left.negative && right.negative) { return false }
        if ( left._number.count < right._number.count ) { return true }
        if ( right._number.count < left._number.count ) { return false }
        
        var left = left
        var right = right
        
        if (left.negative && right.negative) {
            swap(&left, &right)
        }
        
        for i in 0..<left._number.count {
            if left._number[i] < right._number[i] { return true }
            else if (left._number[i] > right._number[i]) { return false }
        }
        return false
    }
    static func >(_ left: inout HugeNumber,_ right: inout HugeNumber) -> Bool {
        if ( !left.negative && right.negative) { return true }
        if ( left.negative && !right.negative) { return false }
        if ( left._number.count > right._number.count ) { return true }
        if ( right._number.count > left._number.count ) { return false }
        
        var left = left
        var right = right
        
        if (left.negative && right.negative) {
            swap(&left, &right)
        }
        
        for i in 0..<left._number.count {
            if left._number[i] > right._number[i] { return true }
            else if (left._number[i] < right._number[i]) { return false }
        }
        return false
    }
    static func ==(_ left: inout HugeNumber,_ right: inout HugeNumber) -> Bool {
        if ( left.negative != right.negative) { return false }
        if ( left._number.count != right._number.count ) { return false }
        for i in 0..<left._number.count {
            if left._number[i] != right._number[i] { return false }
        }
        return true
    }
}
