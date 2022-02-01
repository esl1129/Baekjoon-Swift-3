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

struct cal {
    let id: Int
    var cnt: Int
    init(_ id: Int, _ cnt: Int){
        self.id = id
        self.cnt = cnt
    }
}
// 1
func reverseVertical(_ N: Int, _ M: Int, _ brd: inout [[Int]]) {
    let board = brd
    for i in 0..<N{
        brd[N-i-1] = board[i]
    }
    return
}
// 2
func reverseHorizontal(_ N: Int, _ M: Int, _ brd: inout [[Int]]) {
    let board = brd
    for i in 0..<N{
        for j in 0..<M{
            brd[i][j] = board[i][M-j-1]
        }
    }
    return
}
// 3
func rotateRight(_ N: inout Int, _ M: inout Int, _ brd: inout [[Int]]) {
    var board = [[Int]](repeating: [Int](repeating: 0, count: N), count: M)
    let newN = M
    let newM = N
    for i in 0..<newN{
        for j in 0..<newM{
            board[i][j] = brd[N-j-1][i]
        }
    }
    N = newN
    M = newM
    brd = board
    return
}
// 4
func rotateLeft(_ N: inout Int, _ M: inout Int, _ brd: inout [[Int]]) {
    var board = [[Int]](repeating: [Int](repeating: 0, count: N), count: M)
    let newN = M
    let newM = N
    for i in 0..<newN{
        for j in 0..<newM{
            board[i][j] = brd[j][M-i-1]
        }
    }
    N = newN
    M = newM
    brd = board
    return
}

// 3,4
func rotateTwice(_ N: inout Int, _ M: inout Int, _ brd: inout [[Int]]) {
    let board = brd
    for i in 0..<N{
        for j in 0..<M{
            brd[i][j] = board[N-i-1][M-j-1]
        }
    }
    return
}
// 5
func divisionAndRotateRight(_ N: Int, _ M: Int, _ brd: inout [[Int]]) {
    let board = brd
    let midN = N/2
    let midM = M/2
    
    for i in 0..<midN{
        for j in 0..<midM{
            brd[i][j] = board[midN+i][j]
            brd[i][j+midM] = board[i][j]
            brd[i+midN][j+midM] = board[i][j+midM]
            brd[i+midN][j] = board[i+midN][j+midM]
        }
    }
    return
}
// 6
func divisionAndRotateLeft(_ N: Int, _ M: Int, _ brd: inout [[Int]]) {
    let board = brd
    let midN = N/2
    let midM = M/2
    
    for i in 0..<midN{
        for j in 0..<midM{
            brd[i][j] = board[i][midM+j]
            brd[i][j+midM] = board[i+midN][j+midM]
            brd[i+midN][j+midM] = board[i+midN][j]
            brd[i+midN][j] = board[i][j+midM]
        }
    }
    return
}

func divisionAndRotateTwice(_ N: Int, _ M: Int, _ brd: inout [[Int]]) {
    let board = brd
    let midN = N/2
    let midM = M/2
    
    for i in 0..<midN{
        for j in 0..<midM{
            brd[i][j] = board[i+midN][j+midM]
            brd[i+midN][j+midM] = board[i][j]
            brd[i+midN][j] = board[i][j+midM]
            brd[i][j+midM] = board[i+midN][j]
        }
    }
    return
}

func solution() -> String{
    let fIO = FileIO()
    var N = fIO.readInt()
    var M = fIO.readInt()
    let R = fIO.readInt()
    
    var board = [[Int]](repeating: [Int](repeating: 0, count: M), count: N)
    var cals = [cal]()
    
    for i in 0..<N{
        for j in 0..<M{
            board[i][j] = fIO.readInt()
        }
    }
    
    for _ in 0..<R{
        let id = fIO.readInt()
        if cals.isEmpty{
            cals.append(cal(id, 1))
        } else {
            if cals.last!.id == id {
                var now = cals.removeLast()
                now.cnt += 1
                cals.append(now)
            } else {
                cals.append(cal(id, 1))
            }
        }
    }
    
    for cal in cals {
        switch cal.id {
        case 1:
            reverseVertical(N, M, &board)
        case 2:
            reverseHorizontal(N, M, &board)
        case 3:
            switch cal.cnt%4 {
            case 1:
                rotateRight(&N, &M, &board)
            case 2:
                rotateTwice(&N, &M, &board)
            case 3:
                rotateLeft(&N, &M, &board)
            default:
                continue
            }
        case 4:
            switch cal.cnt%4 {
            case 1:
                rotateLeft(&N, &M, &board)
            case 2:
                rotateTwice(&N, &M, &board)
            case 3:
                rotateRight(&N, &M, &board)
            default:
                continue
            }
        case 5:
            switch cal.cnt%4 {
            case 1:
                divisionAndRotateRight(N, M, &board)
            case 2:
                divisionAndRotateTwice(N, M, &board)
            case 3:
                divisionAndRotateLeft(N, M, &board)
            default:
                continue
            }
        case 6:
            switch cal.cnt%4 {
            case 1:
                divisionAndRotateLeft(N, M, &board)
            case 2:
                divisionAndRotateTwice(N, M, &board)
            case 3:
                divisionAndRotateRight(N, M, &board)
            default:
                continue
            }
        default:
            continue
        }
    }
    
    return board.map{String($0.map{String($0)}.joined(separator: " "))}.joined(separator: "\n")
}

print(solution())

