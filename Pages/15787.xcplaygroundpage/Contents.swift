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

func solution() -> Int{
    let fIO = FileIO()
    let N = fIO.readInt()
    let M = fIO.readInt()
    var trains = [[Int]](repeating: [Int](repeating: 0, count: 20), count: N)
    for _ in 0..<M{
        let order = fIO.readInt()
        let tNum = fIO.readInt()-1
        if order > 2 {
            if order == 3 {
                trains[tNum].removeLast()
                trains[tNum] = [0]+trains[tNum]
            } else {
                trains[tNum].removeFirst()
                trains[tNum].append(0)
            }
            continue
        }
        let idx = fIO.readInt()-1
        if order == 1 {
            trains[tNum][idx] = 1
        } else {
            trains[tNum][idx] = 0
        }
    }
    
    return Set(trains).count
}

print(solution())

