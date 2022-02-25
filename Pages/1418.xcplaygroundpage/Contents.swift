import Foundation
final class FileIO {
    private let buffer:[UInt8]
    private var index: Int = 0
    
    init(fileHandle: FileHandle = FileHandle.standardInput) {
        
        buffer = Array(try! fileHandle.readToEnd()!)+[UInt8(0)] // 인덱스 범위 넘어가는 것 방지
    }
    
    @inline(__always) private func read() -> UInt8 {
        defer { index += 1 }
        
        return buffer[index]
    }
    
    @inline(__always) func readInt() -> Int {
        var sum = 0
        var now = read()
        var isPositive = true
        
        while now == 10
                || now == 32 { now = read() } // 공백과 줄바꿈 무시
        if now == 45 { isPositive.toggle(); now = read() } // 음수 처리
        while now >= 48, now <= 57 {
            sum = sum * 10 + Int(now-48)
            now = read()
        }
        
        return sum * (isPositive ? 1:-1)
    }
    
    @inline(__always) func readString() -> String {
        var now = read()
        
        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1
        
        while now != 10,
              now != 32,
              now != 0 { now = read() }
        
        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }
    
    @inline(__always) func readByteSequenceWithoutSpaceAndLineFeed() -> [UInt8] {
        var now = read()
        
        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1
        
        while now != 10,
              now != 32,
              now != 0 { now = read() }
        
        return Array(buffer[beginIndex..<(index-1)])
    }
}
struct DoubleStackQueue<Element> {
    private var inbox: [Element] = []
    private var outbox: [Element] = []
    
    var isEmpty: Bool{
        return inbox.isEmpty && outbox.isEmpty
    }
    
    var count: Int{
        return inbox.count + outbox.count
    }
    
    var front: Element? {
        return outbox.last ?? inbox.first
    }
    
    init() { }
    
    init(_ array: [Element]) {
        self.init()
        self.inbox = array
    }
    
    mutating func enqueue(_ n: Element) {
        inbox.append(n)
    }
    
    mutating func dequeue() -> Element {
        if outbox.isEmpty {
            outbox = inbox.reversed()
            inbox.removeAll()
        }
        return outbox.removeLast()
    }
}

extension DoubleStackQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.init()
        inbox = elements
    }
}

let MOD = 1000000007
func solution() -> Int{
    let N = FIO.readInt()
    var arr = [Int]()
    for _ in 0..<N {
        arr.append(FIO.readInt())
    }
    var ans = 1
    if N == 1 {
        return 1
    }
    for _ in 0..<N-1{
        arr = arr.sorted{$0 > $1}
        let now = (arr.removeLast()%MOD)*(arr.removeLast()%MOD)
        ans *= now%MOD
        ans %= MOD
        if ans == 0 { return 1}
        arr.append(now)
    }
    return ans == 0 ? 1 : ans
}
let FIO = FileIO()

for _ in 0..<FIO.readInt() {
    print(solution())
}
