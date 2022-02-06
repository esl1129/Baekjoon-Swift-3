func solution() -> String {
    let N = Int(readLine()!)!
    var keySet = Set<String>()
    var visited = [Bool](repeating: false, count: N)
    var answer = [String](repeating: "", count: N)
    for i in 0..<N {
        let str = readLine()!
        for word in str.components(separatedBy: " ").map{String($0)} {
            if !visited[i] && !keySet.contains(String(word.first!.uppercased())){
                answer[i] += "[\(word.first!)]\(word.suffix(word.count-1)) "
                keySet.insert(String(word.first!.uppercased()))
                visited[i] = true
                continue
            }
            answer[i] += word+" "
        }
        if visited[i] {
            answer[i].removeLast()
            continue
        }
        answer[i] = ""
        for s in str{
            if s == " " || visited[i] || keySet.contains(String(s.uppercased())){
                answer[i] += String(s)
                continue
            }
            keySet.insert(s.uppercased())
            answer[i] += "[\(String(s))]"
            visited[i] = true
        }
    }
    return answer.joined(separator: "\n")
}

print(solution())

