struct Color
    red::Int
    green::Int
    blue::Int
end

function higher_capacity(a::Color, b::Color)
    return (a.red >= b.red) && (a.green >= b.green) && (a.blue >= b.blue)
end

function max_elementwise(a::Color, b::Color)
    return Color(max(a.red, b.red), max(a.green, b.green), max(a.blue, b.blue))
end

function find_possible_game_nums(games)
    possible_game_nums = Int[]
    ref_color = Color(12, 13, 14)

    for (round, game) in enumerate(games)
        if all(color -> higher_capacity(ref_color, color), game)
            push!(possible_game_nums, round)
        end
    end

    return possible_game_nums
end

function find_power(games)
    necessary = map(game -> reduce(max_elementwise, game), games)
    return map(n -> n.red * n.green * n.blue, necessary)
end

function parse_color(color_str)
    parts = split(color_str, ", ")
    color_fields = Dict(reverse(split(part, " ")) for part in parts)
    return Color(parse(Int, get(color_fields, "red", "0")),
                 parse(Int, get(color_fields, "green", "0")),
                 parse(Int, get(color_fields, "blue", "0")))
end

function parse_file()
    games = Vector{Vector{Color}}()

    open("day_2_input.txt", "r") do f
        for line in readlines(f)
            # Parse the line
            color_strs = split(split(line, ": ")[2], "; ")
            colors = [parse_color(color_str) for color_str in color_strs]
            push!(games, colors)    
        end
    end

    return games
end

games = parse_file()
game_nums = find_possible_game_nums(games)
println("Possible game numbers: ", game_nums)
println("Possible game numbers totals: ", sum(game_nums))
powers = find_power(games)
println("Total power: ", sum(powers))