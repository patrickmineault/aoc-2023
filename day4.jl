using ParserCombinator

struct Card
    card_num::Int
    winning::Set{Int}
    numbers::Set{Int}
end

function num_winning(card::Card)
    return length(intersect(card.winning, card.numbers))
end

function parse_input()
    open("input.txt", "r") do f
        lines = readlines(f)
        number_parser = PInt()
        spaces_parser = Drop(Star(Space()))
        line_parser = number_parser + spaces_parser
        full_line_parser = Repeat(line_parser) |> collect

        card_parser = E"Card" + spaces_parser + number_parser + P":" + spaces_parser + full_line_parser + P"\|" + spaces_parser + full_line_parser

        cards = Vector{Card}()
        for line in lines
            numbers = parse_one(line, card_parser)
            push!(cards, Card(numbers[1], Set(numbers[2]), Set(numbers[3])))
        end
        return cards
    end
end

function evaluate_cards(cards)
    # Interpret the winning
    sum = 0
    for card in cards
        nmatches = num_winning(card)
        if nmatches > 0
            sum += 2^(nmatches - 1)
        end
    end
    return sum
end

function evaluate_cards_cumsum(cards)
    # Interpret the winning
    cards_to_evaluate = ones(Int, length(cards))
    for (i, card) in enumerate(cards)
        nmatches = num_winning(card)
        if nmatches > 0
            cards_to_evaluate[(i+1):(i+nmatches)] .+= cards_to_evaluate[i]
        end
    end
    return sum(cards_to_evaluate)
end

cards = parse_input()
println(length(cards))
println(evaluate_cards_cumsum(cards))
