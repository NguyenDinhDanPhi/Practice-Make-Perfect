//
//  main.swift
//  MemoryLeaker
//
//  Created by Giordano Scalzo on 12/12/2018.
//  Copyright © 2018 Giordano Scalzo. All rights reserved.
//

import Foundation

class MemoryLeak {
    weak var ref: MemoryLeak?
    init(ref: MemoryLeak) {
        self.ref = ref
    }
    init() {
        ref = self
    }
}


class Hello {
    func world() {
        print("Hello, World!")
    }
}
/// step1
//let hello = Hello()
//hello.world() // set a breakpoint here

func createLeak() {
    let leak = MemoryLeak()
}
/// step 2
//createLeak()
//print("set a breakpoint here")


///step 3
func test() -> MemoryLeak {
    let a = MemoryLeak()
    let b = MemoryLeak(ref: a)
    let c = MemoryLeak(ref: b)
    a.ref = c
    return a
}

let result = test()
assert(result.ref != nil)
