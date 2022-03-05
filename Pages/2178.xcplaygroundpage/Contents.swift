import Foundation

struct Point{
    let x: Int
    let y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

let dx = [0,1,0,-1]
let dy = [1,0,-1,0]
func solution() -> Int{
    func isBound(_ xx:Int, _ yy: Int) -> Bool {
        return xx >= 0 && yy >= 0 && xx < N && yy < M
    }
    let line = readLine()!.components(separatedBy: " ").map{Int(String($0))!}
    let N = line[0]
    let M = line[1]
    
    var board = [[Int]]()
    var visited = [[Bool]](repeating: [Bool](repeating: false, count: M), count: N)
    
    for _ in 0..<N{
        board.append(readLine()!.map{Int(String($0))!})
    }
    var q = [Point]()
    q.append(Point(0,0))
    visited[0][0] = true
    
    var move = 1
    while !q.isEmpty {
        for _ in q.indices{
            let a = q.removeFirst()
            for k in 0..<4{
                let xx = a.x+dx[k]
                let yy = a.y+dy[k]
                if !isBound(xx, yy) || visited[xx][yy] || board[xx][yy] == 0{ continue }
                if xx == N-1 && yy == M-1 {
                    return move+1
                }
                visited[xx][yy] = true
                q.append(Point(xx, yy))
            }
        }
        move += 1
    }
    return 1
}
print(solution())
