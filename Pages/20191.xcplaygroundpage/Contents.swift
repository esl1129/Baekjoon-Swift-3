import Foundation

func solution() -> Int {
    let S = readLine()!.map{String($0)}
    let T = readLine()!
    let sCnt = S.count

    var answer = 1
    var idx = 0
    while true {
        var nowIdx = idx
        for s in T {
            if S[nowIdx] == String(s) {
                nowIdx += 1
            }
            if nowIdx == sCnt {
                return answer
            }
        }
        if idx == nowIdx { return -1 }
        idx = nowIdx
        answer += 1
    }
}

print(solution())
