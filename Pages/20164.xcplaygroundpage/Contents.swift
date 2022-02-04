import Foundation

func solution() -> String {
    var max = 0
    var min = Int.max
    
    func DFS(_ num: Int, _ cnt: Int) {
        if num < 10 {
            let now = num%2 == 1 ? cnt+1 : cnt
            max = max > now ? max : now
            min = min < now ? min : now
            return
        }
        if num < 100 {
            var newCnt = cnt
            if (num%10)%2 == 1 { newCnt += 1 }
            if (num/10)%2 == 1 { newCnt += 1 }
            return DFS(num%10+num/10, newCnt)
        }
        var plus = 0
        for i in 1..<Int(log10(Double(num)))+2{
            if (num%Int(pow(10.0,Double(i))))/Int(pow(10.0,Double(i-1)))%2 == 1 { plus += 1}
        }
        
        for i in 2..<Int(log10(Double(num)))+1 {
            for j in 1..<i {
                let a = num/Int(pow(10.0,Double(i)))
                let b = (num%Int(pow(10.0,Double(i))))/Int(pow(10.0,Double(j)))
                let c = num%Int(pow(10.0,Double(j)))
                DFS(a+b+c, cnt+plus)
            }
        }
        return
    }
    let N = Int(readLine()!)!
    DFS(N, 0)
    return "\(min) \(max)"
}
print(solution())
