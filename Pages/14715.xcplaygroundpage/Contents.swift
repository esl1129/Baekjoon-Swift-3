import Foundation

func getPrime(_ num: Int) -> Bool {
    for i in 2...Int(sqrt(Double(num))){
        if num%i == 0 { return false }
    }
    return true
}
func solution() -> Int{
    var primeArr = [2,3]
    var N = Int(readLine()!)!
    if N < 4 { return 0 }
    for k in 4...N{
        if getPrime(k) {
            primeArr.append(k)
        }
    }
    var cnt = 1
    while !primeArr.contains(N) {
        for p in primeArr {
            if N%p == 0 {
                cnt += 1
                N /= p
                break
            }
        }
    }
    var answer = 0
    while cnt > 1 {
        cnt = cnt%2 == 0 ? cnt/2 : cnt/2+1
        answer += 1
    }
    return answer
}
print(solution())
