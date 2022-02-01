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

// 0 -> up, 1 -> right, 2 -> down, 3 -> left
struct BLOCK {
    let id: Int
    var status: Int
    init(_ id: Int, _ status: Int){
        self.id = id
        self.status = status
    }
    
}
func rotate(_ block: inout [[Int]], _ status: Int){
    let ROW = block.count
    let COL = block[0].count

    switch status%4{
    case -3,1:
        var temp = [[Int]](repeating: [Int](repeating: 0, count: ROW), count: COL)
        for i in 0..<COL{
            for j in 0..<ROW{
                temp[i][j] = block[ROW-j-1][i]
            }
        }
        block = temp
    case -2,2:
        let temp = block
        for i in 0..<ROW{
            for j in 0..<COL{
                block[i][j] = temp[ROW-i-1][COL-j-1]
            }
        }
    case -1,3:
        var temp = [[Int]](repeating: [Int](repeating: 0, count: ROW), count: COL)
        for i in 0..<COL{
            for j in 0..<ROW{
                temp[i][j] = block[j][COL-i-1]
            }
        }
        block = temp
    default:
        break
    }
    return
}

func solution() -> String{
    let fIO = FileIO()
    let N = fIO.readInt()
    let M = fIO.readInt()
    var newN = N
    var newM = M
    let R = fIO.readInt()
    var rotateStatus = true // rotateStatus
    var temp = BLOCK(0, 0)
    var vert = true
    var horz = true
    
    var board = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: M/2), count: N/2), count: 4)
    
    for i in 0..<N{
        for j in 0..<M{
            if i < N/2 {
                if j < M/2 {
                    board[0][i][j] = fIO.readInt()
                } else {
                    board[1][i][j-M/2] = fIO.readInt()
                }
            } else {
                if j < M/2 {
                    board[2][i-N/2][j] = fIO.readInt()
                } else {
                    board[3][i-N/2][j-M/2] = fIO.readInt()
                }
            }
        }
    }
    var blocks = [[BLOCK(0, 0),BLOCK(1, 0)],[BLOCK(2, 0),BLOCK(3, 0)]]
    for _ in 0..<R{
        let id = fIO.readInt()
        switch id{
        case 1:
            vert = !vert
            break
            temp = blocks[0][0]
            blocks[0][0] = blocks[1][0]
            blocks[1][0] = temp
            temp = blocks[0][1]
            blocks[0][1] = blocks[1][1]
            blocks[1][1] = temp
        case 2:
            horz = !horz
            break
            temp = blocks[0][0]
            blocks[0][0] = blocks[0][1]
            blocks[0][1] = temp
            temp = blocks[1][0]
            blocks[1][0] = blocks[1][1]
            blocks[1][1] = temp
        case 3:
            temp = blocks[0][0]
            blocks[0][0] = blocks[1][0]
            blocks[1][0] = blocks[1][1]
            blocks[1][1] = blocks[0][1]
            blocks[0][1] = temp
            for i in 0..<2{
                for j in 0..<2{
                    blocks[i][j].status += 1
                }
            }
            let now = newN
            newN = newM
            newM = now
            rotateStatus = !rotateStatus
        case 4:
            temp = blocks[0][0]
            blocks[0][0] = blocks[0][1]
            blocks[0][1] = blocks[1][1]
            blocks[1][1] = blocks[1][0]
            blocks[1][0] = temp
            for i in 0..<2{
                for j in 0..<2{
                    blocks[i][j].status -= 1
                }
            }
            rotateStatus = !rotateStatus
            let now = newN
            newN = newM
            newM = now
        case 5:
            temp = blocks[0][0]
            blocks[0][0] = blocks[1][0]
            blocks[1][0] = blocks[1][1]
            blocks[1][1] = blocks[0][1]
            blocks[0][1] = temp
        case 6:
            temp = blocks[0][0]
            blocks[0][0] = blocks[0][1]
            blocks[0][1] = blocks[1][1]
            blocks[1][1] = blocks[1][0]
            blocks[1][0] = temp
        default:
            continue
        }
        
    }

    
    var answer = [[Int]](repeating: [Int](repeating: 0, count: newM), count: newN)
    rotate(&board[blocks[0][0].id], blocks[0][0].status)
    rotate(&board[blocks[0][1].id], blocks[0][1].status)
    rotate(&board[blocks[1][0].id], blocks[1][0].status)
    rotate(&board[blocks[1][1].id], blocks[1][1].status)

    for i in 0..<newN{
        for j in 0..<newM{
            if i < newN/2{
                if j < newM/2{
                    answer[i][j] = board[blocks[0][0].id][i][j]
                } else {
                    answer[i][j] = board[blocks[0][1].id][i][j-newM/2]
                }
            } else {
                if j < newM/2{
                    answer[i][j] = board[blocks[1][0].id][i-newN/2][j]
                } else {
                    answer[i][j] = board[blocks[1][1].id][i-newN/2][j-newM/2]
                }
            }
        }
    }

    let verT = answer
    if !vert {
        for i in 0..<newN{
            answer[i] = verT[newN-i-1]
        }
    }
    let horT = answer

    if !horz {
        for i in 0..<newN{
            for j in 0..<newM{
                answer[i][j] = horT[i][newM-j-1]
            }
        }
    }
    return answer.map{String($0.map{String($0)}.joined(separator: " "))}.joined(separator: "\n")
}

print(solution())

