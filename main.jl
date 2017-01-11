include("E:\\_LESSONS\\_servis_sistemleri\\proje\\TaylanFunctions.jl")

# f = open("E:\\_LESSONS\\_servis_sistemleri\\proje\\smallinput.txt")
f = open("E:\\_LESSONS\\_servis_sistemleri\\proje\\input.txt")

lines = readlines(f)

infoLine = split(lines[1], " ")

numberOfCities       = parse(Int64,   infoLine[1])
blimpCost            = parse(Float64, infoLine[2]) # per mile
blimpFactorOfDecline = parse(Float64, infoLine[3])
travelCost           = 1

println("Number of cities       : $numberOfCities")
println("Per mile blimp cost    : $blimpCost")
println("Blimp factor of decline: $blimpFactorOfDecline")

#dosyadaki butun noktalari ve fiyatlarini ekrana yazdirmak icin
#100.000 satir icin uzun surebilir
# [print(lines[i]) for i=[2:length(lines);]] 


cities = eye(numberOfCities, 5) # x, y, blimp ücreti, merkeze uzaklik
for i=1:numberOfCities
    city = split(lines[i+1], " ")
    cities[i, 1] = i # sehirlere numara vermek icin
    cities[i, 2] = parse(Float64, city[1,1]) # x
    cities[i, 3] = parse(Float64, city[2,1]) # y
    cities[i, 4] = parse(Float64, city[3,1]) # blimp ücreti
    cities[i, 5] = distance(cities[i,1], cities[i,2]) # merkeze olan uzaklik
end

# [println(cities[i, 1:end]) for i=1:numberOfCities] 

# şehirlerin merkeze göre 
# sortrows matrixte satir siralama icin kullanilir
# by parametresi hangi columna veya columnlara göre sıralaması gerektiği değerini alır
# sortrows(A; alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)
# http://docs.julialang.org/en/latest/stdlib/sort.html#Sorting-Functions-1
sortedCities = sortrows(cities, by=x->(x[5]))
# println()
# [println(sortedCities[i, 1:end]) for i=1:numberOfCities] 

totalProfit = 0
decline = blimpFactorOfDecline
cityNumberList = []

for i=1:numberOfCities
    decline = CalculateDecline(decline, numberOfCities, i)
    cost    = CalculateCost(sortedCities[i, 5], blimpCost, travelCost)
    profit  = CalculateProfit(cost, sortedCities[i, 4], decline)
    cityNumber = sortedCities[i, 1]
    # println("visited cities:$cityNumber")
    #println("decline:$decline")
    # println("cost:$cost, profit:$profit")
    # println()
    
    if profit > 0
        totalProfit += profit
        push!(cityNumberList, sortedCities[i, 1])
    end
    if decline == 0.0
        break
    end
end

println("visited cities :")
println(cityNumberList)
visitedCityCount = length(cityNumberList)
println("visited city count : $visitedCityCount")
println("total profit       : $totalProfit")
println("final decline      : $decline")

