import Foundation
let N = Int(readLine()!)!
let str =  readLine()!
var answer = str.split(separator: "W").count + str.split(separator: "E").count
let list: [String] = str.map{String($0)}

for i in 0..<N-1 {
    if list[i]+list[i+1] == "EW" {
        answer -= 1
    }
}
print(answer)
