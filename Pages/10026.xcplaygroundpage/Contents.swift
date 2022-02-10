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
struct Point: Hashable{
    let x: Int
    let y: Int
    init(_ x:Int, _ y: Int){
        self.x = x
        self.y = y
    }
}

func solution() -> String{
    func isBound(_ xx: Int, _ yy: Int) -> Bool {
        return xx >= 0 && yy >= 0 && xx < N && yy < N
    }
    let dx = [0,1,0,-1]
    let dy = [1,0,-1,0]
    
    let FIO = FileIO()
    let N = FIO.readInt()
    var board = [[String]]()
    
    for _ in 0..<N{
        board.append(FIO.readString().map{String($0)})
    }
    
    var generalQ = DoubleStackQueue<Point>()
    var specialQ = DoubleStackQueue<Point>()
    
    var gVisited = [[Bool]](repeating: [Bool](repeating: false, count: N), count: N)
    var sVisited = [[Bool]](repeating: [Bool](repeating: false, count: N), count: N)
    
    var g = ""
    var s = ""

    var gAns = 0
    var sAns = 0
    
    for i in 0..<N{
        for j in 0..<N{
            if !gVisited[i][j] {
                generalQ.enqueue(Point(i, j))
                gVisited[i][j] = true
                g = board[i][j]
                while !generalQ.isEmpty{
                    let a = generalQ.dequeue()
                    for k in 0..<4{
                        let xx = a.x+dx[k]
                        let yy = a.y+dy[k]
                        if !isBound(xx, yy) || gVisited[xx][yy] || board[xx][yy] != g { continue }
                        gVisited[xx][yy] = true
                        generalQ.enqueue(Point(xx, yy))
                    }
                }
                gAns += 1
            }
            if !sVisited[i][j] {
                specialQ.enqueue(Point(i, j))
                sVisited[i][j] = true
                s = board[i][j]
                while !specialQ.isEmpty{
                    let a = specialQ.dequeue()
                    for k in 0..<4{
                        let xx = a.x+dx[k]
                        let yy = a.y+dy[k]
                        if !isBound(xx, yy) || sVisited[xx][yy] { continue }
                        if (s == "B" || board[xx][yy] == "B") && (s == "G" || s == "R" || board[xx][yy] == "G" || board[xx][yy] == "R") { continue }
                        sVisited[xx][yy] = true
                        specialQ.enqueue(Point(xx, yy))
                    }
                }
                sAns += 1
            }
        }
    }
    
    return "\(gAns) \(sAns)"
}
print(solution())
