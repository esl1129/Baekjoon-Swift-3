import Foundation


enum side{
    case left, right
}
struct fin{
    let side: side
    let x: Int
    let y: Int
    init (_ s: side, _ x: Int, _ y: Int) {
        self.side = s
        self.x = x
        self.y = y
    }
}
func solution() -> Int{
    var dict = [String : fin]()
    let sampleArr = ["qwert","asdfg","zxcv","Zyuiop","Khjkl","bnm"]
    for i in 0..<6{
        var j = 0
        for s in sampleArr[i] {
            dict[String(s)] = i < 3 ? fin(side.left, i, j) : fin(side.right, i, j)
            j += 1
        }
    }

    var answer = 0
    let line = readLine()!.components(separatedBy: " ").map{String($0)}
    var left = dict[line[0].lowercased()]!
    var right = dict[line[1].lowercased()]!
    
    for s in readLine()! {
        let now = dict[String(s).lowercased()]!
        if now.side == side.left {
            answer += abs(left.x-now.x)+abs(left.y-now.y)+1
            left = now
        } else {
            answer += abs(right.x-now.x)+abs(right.y-now.y)+1
            right = now
        }
    }
    return answer
}

print(solution())
