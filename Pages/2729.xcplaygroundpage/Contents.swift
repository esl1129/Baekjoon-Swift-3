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

func solution() -> String {
    var a = fIO.readString().map{String($0)}
    var b = fIO.readString().map{String($0)}
    var answer = [String]()
    var now = 0
    while true {
        if a.isEmpty && b.isEmpty {
            answer.append(String(now))
            break
        }
        if !a.isEmpty {
            now += Int(a.removeLast())!
        }
        if !b.isEmpty {
            now += Int(b.removeLast())!
        }
        switch now {
        case 0:
            answer.append("0")
            now = 0
        case 1:
            answer.append("1")
            now = 0
        case 2:
            answer.append("0")
            now = 1
        case 3:
            answer.append("1")
            now = 1
        default:
            break
        }
    }
    while !answer.isEmpty && answer.last == "0" {
        answer.removeLast()
    }
    return answer.isEmpty ? "0" : answer.reversed().joined(separator: "")
}

let fIO = FileIO()
for _ in 0..<fIO.readInt() {
    print(solution())
}
