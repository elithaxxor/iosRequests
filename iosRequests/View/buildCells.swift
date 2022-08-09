//
//  buildCells.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation



internal class buildCells {
    static var build = buildCells()
    static var cellCountHREF: Int?
    static var cellCountPTAG: Int?
    internal func getCountHREF() -> Int {
        let currentCount = buildCells.cellCountHREF
        print("[[HREF] -> Cell Count] --> \(String(describing: currentCount))")
        return currentCount ?? 2
    }
    // TODO: pass download amount from soupmodule here
    internal func setCountHREF(newCount: Int) -> Int {
        print("[HREF] -> Setting Count for Amt of Cells] --> \(newCount)")
        buildCells.cellCountHREF = newCount
        return buildCells.cellCountHREF ?? 2
    }
    internal func getCountPTAG() -> Int {
        let currentCount = buildCells.cellCountPTAG ?? 2
        print("[PTAG] -> Getting Count for Amt of Cells] --> \(currentCount)")
        return currentCount
    }
    internal func setCountPTAG(newCount: Int) -> Int {
        buildCells.cellCountPTAG = newCount
        print("[PTAG] -> Setting Count for Amt of Cells] -->")
        return buildCells.cellCountPTAG ?? 2
    }
}
