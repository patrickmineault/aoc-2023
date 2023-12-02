fn calculate_first_last(data: String) raises -> Int:
    var first_digit = String("")
    var last_digit = String("")

    let letter_mask = String("0123456789")
    for i in range(len(data)):
            let nums = letter_mask.count(data[i])
            if nums > 0:
                if first_digit == "":
                    first_digit = data[i]
                last_digit = data[i]

    return atol(first_digit + last_digit)

fn replace_numbers(owned a: String) -> String:
    let nums = StaticTuple[10, StringLiteral]("zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
    let strings = StaticTuple[10, StringLiteral]("z0o", "o1e", "t2o", "t3e", "f4r", "f5e", "s6x", "s7n", "e8t", "n9e")
    for num in range(10):
        while 1:
            let delta = a.find(nums[num], 0)
            if delta > -1:
                a = a[:delta] + strings[num] + a[delta+len(nums[num]):]
            else:
                break
    return a


fn sum(list: DynamicVector[Int]) -> Int:
    var start = 0
    for i in range(len(list)):
        start += list[i]
    return start

fn main() raises:
    # Read the input from disk
    let f = open("inputs/adventofcode.com_2023_day_1_input.txt", "r")
    let data = f.read()

    # Mojo doesn't have facilities to split lines, so do simple scanning
    var first_digit = String("")
    var last_digit = String("")

    var elements_nodigit = DynamicVector[Int]()
    var elements_digit = DynamicVector[Int]()

    var line_start = 0
    for i in range(len(data)):
        if data[i] == "\n":
            # Concatenate first and last digit.
            let the_line = data[line_start:i]
            elements_nodigit.push_back(calculate_first_last(the_line))
            let line_parsed = replace_numbers(the_line)
            elements_digit.push_back(calculate_first_last(line_parsed))
            line_start = i + 1

    # Now add up all the numbers.
    print(sum(elements_nodigit))
    print(sum(elements_digit))
