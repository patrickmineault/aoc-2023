# Let's parse numbers one at a time, and find out which ones have symbols associated with them.
struct Number
    line::Int
    offset::Int
    len::Int
    value::Int
end

function parse_file_into_numbers()
    numbers = Vector{Number}()
    lines = []
    open("input.txt", "r") do f
        lines = readlines(f)
    end

    numbers = Number[]
    for (j, line) in enumerate(lines)
        buffing = false
        buff_start = 0
        for (i, char) in enumerate(line)
            digit = char ∈ "0123456789"
            if buffing && !digit
                buffing = false
                push!(numbers, Number(j, buff_start, i-buff_start, parse(Int, line[buff_start:i-1])))
            elseif !buffing && digit
                buffing = true
                buff_start = i
            end
        end
        if buffing
            push!(numbers, Number(j, buff_start, length(line)-buff_start+1, parse(Int, line[buff_start:end])))
        end
    end

    return (numbers, lines)
end

function check_range(num, line, lines)
    for i in range(num.offset-1, num.offset + num.len)
        if i < 1 || i > length(lines[line])
            continue
        end

        if lines[line][i] != '.'
            return true
        end
    end
    return false
end

function is_attached(num::Number, lines)
    # Check sides
    line_len = length(lines[1])
    if num.offset > 1 && lines[num.line][num.offset-1] != '.'
        return true
    elseif num.offset + num.len < line_len && lines[num.line][num.offset+num.len] != '.'
        return true
    elseif num.line > 1 && check_range(num, num.line-1, lines)
        return true
    elseif num.line < length(lines) && check_range(num, num.line+1, lines)
        return true
    end
    return false
end

function find_two_gears(line, offset, numbers)
    gears = Vector{Number}()
    for number in numbers
        # Check if in bound
        fromto = (number.offset <= offset + 1) && (number.offset + number.len - 1 >= offset - 1)

        if number.line == line - 1 && fromto
            push!(gears, number)
        elseif number.line == line + 1 && fromto
            push!(gears, number)
        elseif number.line == line && number.offset + number.len == offset
            push!(gears, number)
        elseif number.line == line && number.offset == offset + 1
            push!(gears, number)
        end
    end
    return Tuple(gears)
end

function find_stars_gears(lines, numbers)
    pairs = Vector{Tuple{Number, Number}}()
    for (j, line) in enumerate(lines)
        for (i, char) in enumerate(line)
            if char == '*'
                # Find nearest pairs
                pair = find_two_gears(j, i, numbers)
                if length(pair) == 2
                    push!(pairs, pair)
                end
            end
        end
    end
    return pairs
end

(numbers, lines) = parse_file_into_numbers()
numbers_filtered = filter(num -> is_attached(num, lines), numbers)
sum_num = sum(map(x -> x.value, numbers_filtered))
println(sum_num)

# Now find all the stars
pairs = find_stars_gears(lines, numbers)
sum_pairs = sum(map(pair -> pair[1].value * pair[2].value, pairs))
println(sum_pairs)