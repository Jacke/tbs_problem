## TBS Prolem Çözümü

Uygulamanın kodunu 2 ayrı dosya kullanarak çözdüm asıl çözüm algoritmasının olduğu `main.jl` ve sık kullanılan fonksiyonların olduğu `TaylanFunctions.jl`

Uygulamanın sizde de çalışması için `main.jl`deki 1. ve 4. satırları kendi bilgisayarınızdaki dosya yoluna göre düzeltmeniz gerekmektedir.

### `Main.ln`

Burası 100.000 adet örnek veriden oluşan kısmı dosyadan okuduğum ve sabit değerleri girdiğim bölüm

``` Julia
# f = open("E:\\_LESSONS\\_servis_sistemleri\\proje\\smallinput.txt")
f = open("E:\\_LESSONS\\_servis_sistemleri\\proje\\input.txt")

lines = readlines(f)

infoLine = split(lines[1], " ")

numberOfCities       = parse(Int64,   infoLine[1])
blimpCost            = parse(Float64, infoLine[2]) # per mile
blimpFactorOfDecline = parse(Float64, infoLine[3])
travelCost           = 1
```

Bu kısım ise okuduğum verileri kullanılabilir hale getirip `cities` matrisine aktardığım kısım.

Matris şehir sayısı derinliğinde ve 5 genişliğindedir.

1. sütun  şehirlere numara verdiğim kısım. (İleride sıralama yaptığım zaman kaybolmaması için)

2. ve 3. sütun  şehir koordinatları için

4. sütun şehirte bir blimps sattığımız zaman kazanacağımız paranın miktarı

5. sütun x,y koordinatından şehrin merkezini hesaplayıp eklediğim kısım.

``` Julia
cities = eye(numberOfCities, 5) # x, y, blimp ücreti, merkeze uzaklik
for i=1:numberOfCities
    city = split(lines[i+1], " ")
    cities[i, 1] = i # sehirlere numara vermek icin
    cities[i, 2] = parse(Float64, city[1,1]) # x
    cities[i, 3] = parse(Float64, city[2,1]) # y
    cities[i, 4] = parse(Float64, city[3,1]) # blimp ücreti
    cities[i, 5] = distance(cities[i,1], cities[i,2]) # merkeze olan uzaklik
end

```

Bu satırda şehirleri merkeze olan mesafelerine göre sıralama yaptırıyorum sortrows fonksiyonu kullanarak
```Julia
sortedCities = sortrows(cities, by=x->(x[5]))
```

Burada ise `decline`, `cost`, `profit`'i hesaplayıp karımız 0 dan büyük olduğu sürece yeni karı hesaplayıp `totalProfit` değişkeline aktarıyorum, karımız `0`dan büyük olduğu sürece ekleyip, `decline` miktarı `0` olmadığı sürece hesaplatıyorum, `decline` 0 olduğu zaman şehirden alacağımız para kesin 0 olacağı için orada `break` edip döngüyü sonlandırıyorum.
``` Julia
totalProfit = 0
decline = blimpFactorOfDecline
cityNumberList = []

for i=1:numberOfCities
    decline = CalculateDecline(decline, numberOfCities, i)
    cost    = CalculateCost(sortedCities[i, 5], blimpCost, travelCost)
    profit  = CalculateProfit(cost, sortedCities[i, 4], decline)
    cityNumber = sortedCities[i, 1]
    if profit > 0
        totalProfit += profit
        push!(cityNumberList, sortedCities[i, 1])
    end
    if decline == 0.0
        break
    end
end

```


Aşağıdaki kodda ise elde ettiğim sonuçları ekrana yazdırıyorum.
``` Julia
println("visited cities :")
println(cityNumberList)
visitedCityCount = length(cityNumberList)
println("visited city count : $visitedCityCount")
println("total profit       : $totalProfit")
println("final decline      : $decline")
```








#IENG 418 - SERVİS SİSTEMLERİ

## Dönem Projesi Raporu - Ara Sınav

### Quality Blimps Inc

#### Giriş

Quality Blimps Inc satışlarını diğer şehirlere taşımak isteyen bir şirkettir. Bu yüzden sizi satış elemanı olarak işe aldılar. Diğer şehirlere gidip blimps (sosis balon) satmanız gerekiyor. Yanınızda blimps taşıyarak seyehat etmek size pahalıya patlayabilir. Bu yüzden bir yolculuğa çıkmadan önce yanınızda ne kadar blimps taşımanız gerektiğini belirlemelisiniz ve ne zaman merkeze geri dönüp daha fazla blimps almanız gerekeceğini hesaplamalısınız.
Ziyaret ettiğiniz her şehirde sadece bir blimps satarak geçebilirsiniz ve bütün şehirleri ziyaret etmek zorunda değilsiniz bazı şehirler ziyaret etmek için çok pahalı olabilirler. Her şehrin blimps satmak için bir başlangıç fiyatı vardır ama blimps sattıkça bu fiyat düşer. Karı en yüksek yapmak için gereken en iyi rotayı bulmalısınız.

#### Amaç

Problemin hedefi Blimpsleri şehirlere en yüksek karı elde edebilecek satış rotasını bulmaktır. Bunun için şehirlerde yapılan toplam satışın, toplam yol masraflarından çıkartıp en yüksek değer bulunmalıdır.

#### Detaylar

1. Blimp fiyatı, ziyaret edilen her %10 şehirde düşer. Örneğin, düşüş başlangıç oranı (D) 0.95 ise ve satış yapılabilecek 10 şehirimiz varsa D = 0.95 * 0.95 * 0.95 * 0.95 * 0.95 = 0.77 olur. (Şehir sayısı her zaman 10'un katları olacaktır.)

2. Satış elemanının seyehat etme fiyatı 1$ / Mil.

3. Blimps taşıma fiyatı C$ / Blimp / Mil (C verilecektir.)

4. Mesafe ücretleri o anda gidilen iki şehir arasındaki mesafeye göre ölçülecektir.

5. Quality Blips Merkez'i (0,0) noktasından başlamaktadır.

#### Girdi Formatı

İlk satır üç parametre içermektedir:

> Şehir Sayısı (N)

> Mil başına Blimps fiyatı (C)

> Blimp fiyat düşüş oranı (D)

Bundan sonraki N satır 3 adet integer sayı içerecektir. İlk ikisi x ve y koordinatları ve sonuncusu ise başlangıç blimp satıç fiyatı olacaktır.

> x y blimp_price

#### Kısıtlar

```
10    <= N <= 10^5
0.2   <= C <= 4
0.5   <= D <= 0.99
-1000 <= x <= 1000
-1000 <= y <= 1000
blimp fiyatı < 10^5
```

#### Çıktı Formatı

Her bir satır ziyaret edilen şehrin koordinatlarını (x,y) içermelidir. Ayrıca yanınızda götürdüğünüz blimps miktarını da içermelidir. Çıktıda merkez (0,0) koordinatlarını yazmanıza gerek yoktur.

#### Örnek Girdi

```
10 3 0.95
1 1 30
2 2 35
0 8 50
7 2 20
7 3 25
10 7 90
9 8 35
5 15 10
8 18 15
1 9 60
```

#### Örnek Çıktı
```
1 1 2
2 2
0 0
10 7 2
9 8
0 0
0 8 2
1 9
```

### KAYNAKÇA

Problem Orjinal Kaynak -> https://www.hackerrank.com/challenges/tbsp
