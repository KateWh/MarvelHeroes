import UIKit

var str = "Hello, playground"

func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporary = a
    a = b
    b = temporary
}

func changeString(first value: inout String, second val: inout String) {
    let temp = val
    val = value
    value = temp
}

var five = 5
var ten = 10
var ket = "ket"
var vit = "vit"
changeString(first: &vit, second: &ket)
swapTwoInts(&five, &ten)

print("ket is \(ket), vit is \(vit)")
print("5 = ", five, "\n10 = ", ten)


func swapToValues<T, U>(_ firsOne: inout T, _ secondOne: inout T, _ firstTwo: inout U, _ secondTwo: inout U) {
    let tempOne = firsOne
    let tempTwo = firstTwo
    firsOne = secondOne
    firstTwo = secondTwo
    secondOne = tempOne
    secondTwo = tempTwo
}

swapToValues(&ket, &vit, &five, &ten)


print("ket is \(ket), vit is \(vit)")
print("5 = ", five, "\n10 = ", ten)
