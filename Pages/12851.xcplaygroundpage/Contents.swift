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
func solution() -> String{
    let FIO = FileIO()
    let N = FIO.readInt()
    let K = FIO.readInt()
    var q = DoubleStackQueue<Int>()
    q.enqueue(N)
    var visited = [Int](repeating: -1, count: 100001)
    var value = [Int](repeating: 0, count: 100001)
    visited[N] = 0
    value[N] = 1
    
    var ans = 0
    
    while !q.isEmpty {
        for _ in 0..<q.count{
            let a = q.dequeue()
            if a == K {
                return "\(ans)\n\(value[K])"
            }
            if a > 0 {
                if value[a-1] == 0 {
                    q.enqueue(a-1)
                    value[a-1] += value[a]
                    visited[a-1] = ans
                } else if visited[a-1] == ans {
                    value[a-1] += value[a]
                }
            }
            if a < 100000 {
                if value[a+1] == 0 {
                    q.enqueue(a+1)
                    value[a+1] += value[a]
                    visited[a+1] = ans

                }else if visited[a+1] == ans {
                    value[a+1] += value[a]
                }
            }
            if a < 50001 {
                if value[a*2] == 0 {
                    q.enqueue(a*2)
                    value[a*2] += value[a]
                    visited[a*2] = ans
                }else if visited[a*2] == ans {
                    value[a*2] += value[a]
                }
            }
        }
        ans += 1
    }
    return ""
}

print(solution())

