function distance(x, y)
    return (x^2 + y^2) ^ (0.5)
end 

function CalculateCost(distance, blimpCost, travelCost)
    return distance * (blimpCost + 2 * travelCost)
end

function CalculateProfit(cost, price, decline)
    return price * decline - cost
end

function CalculateDecline(decline, cityCount, currentCityIndex)
    times = floor(currentCityIndex / (cityCount / 10))
    finalDecline = decline
    for i = 1:times
        finalDecline = finalDecline * decline
    end
    return finalDecline
end
