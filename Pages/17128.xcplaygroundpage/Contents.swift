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

func solution() -> String{
    let fIO = FileIO()
    let N = fIO.readInt()
    let Q = fIO.readInt()
    var PS = [Int]()
    var answer = [Int]()
    
    var nums = [Int]()
    
    for _ in 0..<N{
        nums.append(fIO.readInt())
    }
    nums.append(nums[0])
    nums.append(nums[1])
    nums.append(nums[2])
    
    for i in 0..<N{
        PS.append(nums[i]*nums[i+1]*nums[i+2]*nums[i+3])
    }
    for _ in 0..<Q{
        var now = answer.isEmpty ? PS.reduce(0, +) : answer.last!
        let q = fIO.readInt()-1
        for k in stride(from: q, through: q-3, by: -1) {
            let a = k < 0 ? N+k : k
            now -= PS[a]
            PS[a] /= nums[a]
            PS[a] *= -nums[a]
            now += PS[a]
        }
        answer.append(now)
    }
    return answer.map{String($0)}.joined(separator: "\n")
}

print(solution())
