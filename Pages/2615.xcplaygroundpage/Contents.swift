import Foundation



func solution() -> String{
    let dx = [0,1,1,1]
    let dy = [1,1,0,-1]
    func isBound(_ xx: Int, _ yy: Int) -> Bool {
        return xx >= 0 && yy >= 0 && xx < 19 && yy < 19
    }
    
    func check(_ num: Int, _ x: Int, _ y: Int) -> (result: Bool, x: Int?, y: Int?) {
        for dir in 0..<4{
            if isBound(x-dx[dir], y-dy[dir]) && board[x-dx[dir]][y-dy[dir]] == num { continue }
            var check = true
            for k in 1...4{
                let xx = x+dx[dir]*k
                let yy = y+dy[dir]*k
                if !isBound(xx, yy) || board[xx][yy] != num {
                    check = false
                    break
                }
            }
            if isBound(x+dx[dir]*5, y+dy[dir]*5) && board[x+dx[dir]*5][y+dy[dir]*5] == num { continue }
            if check {
                return dir == 3 ? (true,x+dx[dir]*4+1,y+dy[dir]*4+1) : (true,x+1,y+1)
                
            }
        }
        return (false, nil, nil)
    }
    
    var board = [[Int]]()
    for _ in 0..<19{
        board.append(readLine()!.components(separatedBy: " ").map{Int(String($0))!})
    }
    
    for i in 0..<19{
        for j in 0..<19{
            if board[i][j] == 0 { continue }
            let c = check(board[i][j], i, j)
            if c.result {
                return "\(board[i][j])\n\(c.x!) \(c.y!)"
            }
        }
    }
    return "0"
}

print(solution())
