//
//  Subscript.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/6/1.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import Foundation

/*
 Classes, structures, and enumerations can define subscripts, 
 which are shortcuts for accessing the member elements of a collection, list, or sequence.
 */

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

class Subscript {

    public func hello() {
        let threeTimesTable = TimesTable(multiplier: 3)
        print("six times three is \(threeTimesTable[6])")
    }
    
    public func matrix() {
        let matrix = Matrix(rows: 2, columns: 2)
        print("six times three is \(matrix[1, 1])")
    }
}

