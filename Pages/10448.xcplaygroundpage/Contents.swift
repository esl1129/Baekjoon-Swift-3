import Foundation

func solution() {
    let TC = Int(readLine()!)!
    var dp = [1]
    for i in 2...45 {
        dp.append(dp.last!+i)
    }
    var PS = Set<Int>()
    for i in 0..<dp.count{
        for j in 0..<dp.count{
            for k in 0..<dp.count{
                PS.insert(dp[i]+dp[j]+dp[k])
            }
        }
    }
    for _ in 0..<TC {
        let n = Int(readLine()!)!
        print(PS.contains(n) ? 1 : 0)
    }
    return
}
solution()
