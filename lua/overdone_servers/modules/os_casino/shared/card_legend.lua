local OS_Casino = OverdoneServers.OS_Casino
local module = OS_Casino.Module
local enum = OverdoneServers:GetLibrary("enum")

OS_Casino.ENUMS = OS_Casino.ENUMS or {}

OS_Casino.ENUMS.SUIT = {SPADES = 1, CLUBS = 2, DIAMONDS = 3, HEARTS = 4} --enum.new("SUIT", {"SPADES", "CLUBS", "DIAMONDS", "HEARTS"})
 --enum.new("KIND", {"ACE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN", "JACK", "QUEEN", "KING"})

local SUIT = OS_Casino.ENUMS.SUIT

OS_Casino.CardLegend = {}

OS_Casino.ENUMS.KIND = {ACE = 1, TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, TEN = 10, JACK = 11, QUEEN = 12, KING = 13}
local KIND = OS_Casino.ENUMS.KIND

OS_Casino.CardLegend.AceLow = {
    [1]  = {kind = KIND.ACE,   suit = SUIT.SPADES},
    [2]  = {kind = KIND.TWO,   suit = SUIT.SPADES},
    [3]  = {kind = KIND.THREE, suit = SUIT.SPADES},
    [4]  = {kind = KIND.FOUR,  suit = SUIT.SPADES},
    [5]  = {kind = KIND.FIVE,  suit = SUIT.SPADES},
    [6]  = {kind = KIND.SIX,   suit = SUIT.SPADES},
    [7]  = {kind = KIND.SEVEN, suit = SUIT.SPADES},
    [8]  = {kind = KIND.EIGHT, suit = SUIT.SPADES},
    [9]  = {kind = KIND.NINE,  suit = SUIT.SPADES},
    [10] = {kind = KIND.TEN,   suit = SUIT.SPADES},
    [11] = {kind = KIND.JACK,  suit = SUIT.SPADES},
    [12] = {kind = KIND.QUEEN, suit = SUIT.SPADES},
    [13] = {kind = KIND.KING,  suit = SUIT.SPADES},

    [14] = {kind = KIND.ACE,   suit = SUIT.CLUBS},
    [15] = {kind = KIND.TWO,   suit = SUIT.CLUBS},
    [16] = {kind = KIND.THREE, suit = SUIT.CLUBS},
    [17] = {kind = KIND.FOUR,  suit = SUIT.CLUBS},
    [18] = {kind = KIND.FIVE,  suit = SUIT.CLUBS},
    [19] = {kind = KIND.SIX,   suit = SUIT.CLUBS},
    [20] = {kind = KIND.SEVEN, suit = SUIT.CLUBS},
    [21] = {kind = KIND.EIGHT, suit = SUIT.CLUBS},
    [22] = {kind = KIND.NINE,  suit = SUIT.CLUBS},
    [23] = {kind = KIND.TEN,   suit = SUIT.CLUBS},
    [24] = {kind = KIND.JACK,  suit = SUIT.CLUBS},
    [25] = {kind = KIND.QUEEN, suit = SUIT.CLUBS},
    [26] = {kind = KIND.KING,  suit = SUIT.CLUBS},

    [27] = {kind = KIND.ACE,   suit = SUIT.DIAMONDS},
    [28] = {kind = KIND.TWO,   suit = SUIT.DIAMONDS},
    [29] = {kind = KIND.THREE, suit = SUIT.DIAMONDS},
    [30] = {kind = KIND.FOUR,  suit = SUIT.DIAMONDS},
    [31] = {kind = KIND.FIVE,  suit = SUIT.DIAMONDS},
    [32] = {kind = KIND.SIX,   suit = SUIT.DIAMONDS},
    [33] = {kind = KIND.SEVEN, suit = SUIT.DIAMONDS},
    [34] = {kind = KIND.EIGHT, suit = SUIT.DIAMONDS},
    [35] = {kind = KIND.NINE,  suit = SUIT.DIAMONDS},
    [36] = {kind = KIND.TEN,   suit = SUIT.DIAMONDS},
    [37] = {kind = KIND.JACK,  suit = SUIT.DIAMONDS},
    [38] = {kind = KIND.QUEEN, suit = SUIT.DIAMONDS},
    [39] = {kind = KIND.KING,  suit = SUIT.DIAMONDS},

    [40] = {kind = KIND.ACE,   suit = SUIT.HEARTS},
    [41] = {kind = KIND.TWO,   suit = SUIT.HEARTS},
    [42] = {kind = KIND.THREE, suit = SUIT.HEARTS},
    [43] = {kind = KIND.FOUR,  suit = SUIT.HEARTS},
    [44] = {kind = KIND.FIVE,  suit = SUIT.HEARTS},
    [45] = {kind = KIND.SIX,   suit = SUIT.HEARTS},
    [46] = {kind = KIND.SEVEN, suit = SUIT.HEARTS},
    [47] = {kind = KIND.EIGHT, suit = SUIT.HEARTS},
    [48] = {kind = KIND.NINE,  suit = SUIT.HEARTS},
    [49] = {kind = KIND.TEN,   suit = SUIT.HEARTS},
    [50] = {kind = KIND.JACK,  suit = SUIT.HEARTS},
    [51] = {kind = KIND.QUEEN, suit = SUIT.HEARTS},
    [52] = {kind = KIND.KING,  suit = SUIT.HEARTS},
}

OS_Casino.ENUMS.KIND = {TWO = 1, THREE = 2, FOUR = 3, FIVE = 4, SIX = 5, SEVEN = 6, EIGHT = 7, NINE = 8, TEN = 9, JACK = 10, QUEEN = 11, KING = 12, ACE = 13}
local KIND = OS_Casino.ENUMS.KIND

OS_Casino.CardLegend.AceHigh = {
    [1]  = {kind = KIND.TWO,   suit = SUIT.SPADES},
    [2]  = {kind = KIND.THREE, suit = SUIT.SPADES},
    [3]  = {kind = KIND.FOUR,  suit = SUIT.SPADES},
    [4]  = {kind = KIND.FIVE,  suit = SUIT.SPADES},
    [5]  = {kind = KIND.SIX,   suit = SUIT.SPADES},
    [6]  = {kind = KIND.SEVEN, suit = SUIT.SPADES},
    [7]  = {kind = KIND.EIGHT, suit = SUIT.SPADES},
    [8]  = {kind = KIND.NINE,  suit = SUIT.SPADES},
    [9]  = {kind = KIND.TEN,   suit = SUIT.SPADES},
    [10] = {kind = KIND.JACK,  suit = SUIT.SPADES},
    [11] = {kind = KIND.QUEEN, suit = SUIT.SPADES},
    [12] = {kind = KIND.KING,  suit = SUIT.SPADES},
    [13] = {kind = KIND.ACE,   suit = SUIT.SPADES},

    [14] = {kind = KIND.TWO,   suit = SUIT.CLUBS},
    [15] = {kind = KIND.THREE, suit = SUIT.CLUBS},
    [16] = {kind = KIND.FOUR,  suit = SUIT.CLUBS},
    [17] = {kind = KIND.FIVE,  suit = SUIT.CLUBS},
    [18] = {kind = KIND.SIX,   suit = SUIT.CLUBS},
    [19] = {kind = KIND.SEVEN, suit = SUIT.CLUBS},
    [20] = {kind = KIND.EIGHT, suit = SUIT.CLUBS},
    [21] = {kind = KIND.NINE,  suit = SUIT.CLUBS},
    [22] = {kind = KIND.TEN,   suit = SUIT.CLUBS},
    [23] = {kind = KIND.JACK,  suit = SUIT.CLUBS},
    [24] = {kind = KIND.QUEEN, suit = SUIT.CLUBS},
    [25] = {kind = KIND.KING,  suit = SUIT.CLUBS},
    [26] = {kind = KIND.ACE,   suit = SUIT.CLUBS},

    [27] = {kind = KIND.TWO,   suit = SUIT.DIAMONDS},
    [28] = {kind = KIND.THREE, suit = SUIT.DIAMONDS},
    [29] = {kind = KIND.FOUR,  suit = SUIT.DIAMONDS},
    [30] = {kind = KIND.FIVE,  suit = SUIT.DIAMONDS},
    [31] = {kind = KIND.SIX,   suit = SUIT.DIAMONDS},
    [32] = {kind = KIND.SEVEN, suit = SUIT.DIAMONDS},
    [33] = {kind = KIND.EIGHT, suit = SUIT.DIAMONDS},
    [34] = {kind = KIND.NINE,  suit = SUIT.DIAMONDS},
    [35] = {kind = KIND.TEN,   suit = SUIT.DIAMONDS},
    [36] = {kind = KIND.JACK,  suit = SUIT.DIAMONDS},
    [37] = {kind = KIND.QUEEN, suit = SUIT.DIAMONDS},
    [38] = {kind = KIND.KING,  suit = SUIT.DIAMONDS},
    [39] = {kind = KIND.ACE,   suit = SUIT.DIAMONDS},

    [40] = {kind = KIND.TWO,   suit = SUIT.HEARTS},
    [41] = {kind = KIND.THREE, suit = SUIT.HEARTS},
    [42] = {kind = KIND.FOUR,  suit = SUIT.HEARTS},
    [43] = {kind = KIND.FIVE,  suit = SUIT.HEARTS},
    [44] = {kind = KIND.SIX,   suit = SUIT.HEARTS},
    [45] = {kind = KIND.SEVEN, suit = SUIT.HEARTS},
    [46] = {kind = KIND.EIGHT, suit = SUIT.HEARTS},
    [47] = {kind = KIND.NINE,  suit = SUIT.HEARTS},
    [48] = {kind = KIND.TEN,   suit = SUIT.HEARTS},
    [49] = {kind = KIND.JACK,  suit = SUIT.HEARTS},
    [50] = {kind = KIND.QUEEN, suit = SUIT.HEARTS},
    [51] = {kind = KIND.KING,  suit = SUIT.HEARTS},
    [52] = {kind = KIND.ACE,   suit = SUIT.HEARTS},
 
}

function OS_Casino:IsValidCard(cardData)
    return cardData != nil and cardData.kind != nil and cardData.suit != nil
end