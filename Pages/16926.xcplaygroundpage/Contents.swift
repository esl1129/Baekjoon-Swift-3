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

let dx = [1,0,-1,-0]
let dy = [0,1,0,-1]
func solution() -> String{
    func isBound(_ xx: Int, _ yy: Int, _ sX: Int, _ sY: Int, _ eX: Int, _ eY: Int) -> Bool {
        return xx >= sX && yy >= sY && xx <= eX && yy <= eY
    }
    
    func rotate(_ sX: Int, _ sY: Int, _ eX: Int, _ eY: Int) {
        let div = 2*(eX-sX)+2*(eY-sY)
        if div <= 0 { return }
        let r = R%div
        if r <= 0 { return }
        var cnt = 1
        var dir = 0
        var x = sX
        var y = sY
        var q = DoubleStackQueue<Int>()
        q.enqueue(board[x][y])
        while !q.isEmpty {
            let xx = x+dx[dir]
            let yy = y+dy[dir]
            if !isBound(xx, yy, sX, sY, eX, eY){
                dir = dir == 3 ? 0 : dir+1
                continue
            }
            if cnt < r {
                x = xx
                y = yy
                q.enqueue(board[x][y])
                cnt += 1
                continue
            }
            if visited[xx][yy] {
                return
            }
            if cnt >= r {
                q.enqueue(board[xx][yy])
                board[xx][yy] = q.dequeue()
                visited[xx][yy] = true
                x = xx
                y = yy
            }
            cnt += 1
        }
    }
    
    let fIO = FileIO()
    let N = fIO.readInt()
    let M = fIO.readInt()
    let R = fIO.readInt()
    var visited = [[Bool]](repeating: [Bool](repeating: false, count: M), count: N)
    var board = [[Int]](repeating: [Int](repeating: 0, count: M), count: N)
    for i in 0..<N{
        for j in 0..<M{
            board[i][j] = fIO.readInt()
        }
    }
    var startX = 0
    var startY = 0
    var endX = N-1
    var endY = M-1
    
    while startX <= endX && startY <= endY {
        rotate(startX, startY, endX, endY)
        startX += 1
        startY += 1
        endX -= 1
        endY -= 1
    }
    return board.map{String($0.map{String($0)}.joined(separator: " "))}.joined(separator: "\n")
}

print(solution())
