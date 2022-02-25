import Foundation

let MOD = 1000000007

func solution() -> Int{
    func sumArr(_ a: [[Int]], _ b: [[Int]]) -> [[Int]]{
        var temp = [[Int]](repeating: [Int](repeating: 0, count: 8), count: 8)
        for i in 0..<8{
            for j in 0..<8{
                var num = 0
                for k in 0..<8{
                    num += (a[i][k]*b[k][j])%MOD
                }
                num %= MOD
                temp[i][j] = num
            }
        }
        return temp
    }
    var dp = [
        [0,1,1,0,0,0,0,0],
        [1,0,1,1,0,0,0,0],
        [1,1,0,1,1,0,0,0],
        [0,1,1,0,1,1,0,0],
        [0,0,1,1,0,1,1,0],
        [0,0,0,1,1,0,0,1],
        [0,0,0,0,1,0,0,1],
        [0,0,0,0,0,1,1,0]
    ]
    
    var dpArr = [dp]
    var answer = [[Int]](repeating: [Int](repeating: 0, count: 8), count: 8)
    
    for i in 0..<8{
        answer[i][i] = 1
    }

    let N = Int(readLine()!)!
    var binary = String(N, radix: 2)

    for _ in 0..<binary.count{
        let d = dpArr.last!
        dpArr.append(sumArr(d, d))
    }

    var index = 0
    while !binary.isEmpty{
        let s = binary.removeLast()
        if s == "1" {
            answer = sumArr(answer, dpArr[index])
        }
        index += 1
    }
    return answer[0][0]
}
print(solution())
