import Foundation

func solution() -> Int {
    let S = readLine()!.map{String($0)}
    let T = readLine()!
    let sCnt = S.count
    let tCnt = T.count

    var IV = ""
    for _ in 0..<1000000/tCnt {
        IV += T
    }

    var idx = 0
    var answer = 0
    for (index,s) in IV.enumerated() {
        if S[idx] == String(s) {
            idx += 1
        }
        if idx == sCnt {
            answer = (index+1)%tCnt == 0 ? (index+1)/tCnt : (index+1)/tCnt+1
            return answer
        }
    }
    return -1
}

print(solution())
