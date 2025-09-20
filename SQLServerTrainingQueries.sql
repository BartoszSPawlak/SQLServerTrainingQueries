--Wybierz wszystkie pola z tabeli `SalesLT.Customer`.
SELECT * FROM SalesLT.Customer;

--Wybierz unikalne nazwy miast z tabeli `SalesLT.Address`.
SELECT DISTINCT City FROM SalesLT.Address;

--Wybierz imiê, nazwisko oraz adres e-mail pierwszych 10 klientów. Wyœwietl rezultaty jako, 'FirstName', 'LastName', 'Email'.
SELECT TOP 10 FirstName, LastName, EmailAddress AS Email 
FROM SalesLT.Customer;

--Pobiera wszystkie adresy (tabela `SalesLT.Address`), które znajduj¹ siê w stanie California (kolumna StateProvince).
SELECT *
FROM SalesLT.Address
WHERE  StateProvince = 'California'

--Znajduje wszystkie produkty (tabela SalesLT.Product), których cena sprzeda¿y ListPrice przekracza 1000, ale maksymalnie wynosi 2000.
SELECT * 
FROM SalesLT.Product 
WHERE ListPrice between 1000 AND 2000;

--Znajduje wszystkich klientów, którzy maj¹ wype³nione pole MiddleName i Suffix.
SELECT * 
FROM SalesLT.Customer 
WHERE MiddleName is not null and Suffix is not null;

--Wyœwietla wszystkie zamówienia (tabela SalesLT.SalesOrderHeader), których data zakoñczenia sprzeda¿y ShipDate jest póŸniejsza ni¿ data zamówienia OrderDate.
SELECT * 
FROM SalesLT.SalesOrderHeader 
WHERE ShipDate > OrderDate;

--Zwraca wszystkie produkty, które by³y na wyprzeda¿y w 2005 roku, co najmniej dzieñ (SellStartDate/SellEndDate)
SELECT * 
FROM SalesLT.Product 
WHERE (YEAR(SellStartDate) <= 2005) and (YEAR(SellEndDate)>=2005 or YEAR(SellEndDate) is null) and (DATEDIFF(DAY,SellStartDate, SellEndDate)>1 or DATEDIFF(DAY,SellStartDate, SellEndDate) is null);

--Sortuje szczegó³y zamówieñ (tabela SalesLT.SalesOrderDetail) wed³ug iloœci zamówioñ (OrderQty) w kolejnoœci malej¹cej, zwracaj¹c informacje z kolumn SalesOrderID, OrderQty oraz UnitPrice, tylko dla zamówieñ, które maj¹ iloœæ zamówionych produktów wiêksz¹ ni¿ 5.
SELECT SalesOrderID, OrderQty, UnitPrice 
FROM SalesLT.SalesOrderDetail 
WHERE OrderQty>5 
ORDER BY OrderQty DESC;

--Zwraca posortowane zamówienia (tabela: SalesLT.SalesOrderHeader) wed³ug daty zamówienia OrderDate w kolejnoœci rosn¹cej, dodatkowo jeœli zamówienia maj¹ t¹ sam¹ datê to posortujemy je wed³ug ceny ca³kowitej SubTotal w kolejnoœci malej¹cej.
SELECT * 
FROM SalesLT.SalesOrderHeader 
ORDER BY OrderDate, SubTotal DESC;

--Zwraca produk o najni¿szej cenie.
SELECT TOP 1 * 
FROM SalesLT.[Product] 
ORDER BY ListPrice;

--Zwraca sume wszystkich nalerznoœci.
SELECT SUM(TotalDue) AS SumPrice 
FROM SalesLT.SalesOrderHeader;

--Zwraca liczbê miast dla ka¿dego stanu StateProvince z osobna.
SELECT StateProvince, COUNT(DISTINCT City) AS AmountOfCities
FROM SalesLT.Address 
GROUP BY StateProvince;

--Zwraca liczbê klientów obs³ugiwanych przez danego sprzedawcê (tabela Customer, kolumna SalesPerson).
SELECT SalesPerson, COUNT(*) AS CountOfCustomer 
FROM SalesLT.Customer 
GROUP BY SalesPerson;

--Zwraca sprzedawce z najwiêksz¹ liczb¹ przypisanych klientów.
SELECT TOP 1 SalesPerson, COUNT(*) AS CountOfCustomer 
FROM SalesLT.Customer 
GROUP BY SalesPerson 
ORDER BY CountOfCustomer DESC;

--Zwraca œredni¹ wartoœæ ListPrice produktów w danychm kolorze, których cena ListPrice jest wiêksza ni¿ 100.
SELECT Color, AVG(ListPrice) 
FROM SalesLT.Product 
WHERE ListPrice>100 
GROUP BY Color;

--Zwraca cene najtañszego produktu w danym rozmiarze Size.
SELECT Size, MIN(ListPrice) AS Price  
FROM SalesLT.Product 
GROUP BY Size 
ORDER BY Price;

--ZnajdŸ wszystkich sprzedawców SalesPerson, którzy obsluguj¹ co najmniej 100 klientów.
SELECT SalesPerson, COUNT(*) 
FROM SalesLT.Customer 
GROUP BY SalesPerson 
HAVING COUNT(*)>100;

--ZnajdŸ które modele (produktu ProductModelID), maj¹ œredni¹ cene produktu ListPrice wiêksz¹ ni¿ 300.
SELECT ProductModelID, AVG(ListPrice) AS AvaragePrice 
FROM SalesLT.Product 
GROUP BY ProductModelID 
HAVING AVG(ListPrice)>300;

--ZnajdŸ kolory Color produktów, które maj¹ miminaln¹ cenê ListPrice 30.
SELECT Color, MIN(ListPrice) AS MinimumPrice 
FROM SalesLT.Product 
GROUP BY Color 
HAVING MIN(ListPrice)>30;

--Szuka top 3 klientów pod wzglêdem ³¹cznej kwoty wydatków (TotalDue z tabeli SalesOrderHeader).
SELECT TOP 3 FirstName, LastName, SUM(soh.TotalDue) 
FROM SalesLT.Customer AS c 
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID=soh.CustomerID 
GROUP BY c.CustomerID, c.FirstName, c.LastName 
ORDER BY SUM(soh.TotalDue) DESC;

--ZnajdŸ top 5 modeli produktów sprzedanych (z najwiêksz¹ liczb¹ sprzedanych iloœci) w stanie '`California`'.
SELECT TOP 5 pm.Name NameOfModel, COUNT(*) SoldCount 
FROM SalesLT.ProductModel pm
JOIN SalesLT.Product p ON pm.ProductModelID=p.ProductModelID
JOIN SalesLT.SalesOrderDetail AS sod ON p.ProductID=sod.ProductID
JOIN SalesLT.SalesOrderHeader AS soh ON sod.SalesOrderID=soh.SalesOrderID
JOIN SalesLT.Address AS a ON soh.BillToAddressID=a.AddressID
WHERE a.StateProvince='California'
GROUP BY pm.Name
ORDER BY COUNT(*) DESC;

--ZnajdŸ adresy klientów, którzy kupili produkty z kategorii rowerów '`Bikes`'.
SELECT DISTINCT a.*, ppc.Name
FROM SalesLT.Address a
JOIN SalesLT.CustomerAddress AS ca ON ca.AddressID=a.AddressID
JOIN SalesLT.Customer AS c on c.CustomerID=ca.CustomerID
JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID=c.CustomerID
JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID=soh.SalesOrderID
JOIN SalesLT.Product AS p ON p.ProductID=sod.ProductID
JOIN SalesLT.ProductCategory AS pc ON pc.ProductCategoryID=p.ProductCategoryID
JOIN SalesLT.ProductCategory AS ppc ON ppc.ProductCategoryID=pc.ParentProductCategoryID
WHERE ppc.Name='Bikes';

--Znajdz sprzedawce, który sprzeda³ najwiêcej produktów z kategorii '`Clothing`'.
SELECT TOP 1 c.SalesPerson, COUNT(*) AS TotalSales
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID=c.CustomerID
JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID=soh.SalesOrderID
JOIN SalesLT.Product AS p ON p.ProductID=sod.ProductID
JOIN SalesLT.ProductCategory AS pc ON pc.ProductCategoryID=p.ProductCategoryID
JOIN SalesLT.ProductCategory AS ppc ON ppc.ProductCategoryID=pc.ParentProductCategoryID
WHERE ppc.Name='Clothing'
GROUP BY c.SalesPerson
ORDER BY TotalSales DESC;

--ZnajdŸ sprzedawców, którzy zrobili najwiêksze obroty (`TotalDue` z tabeli `SalesOrderHeader`) w danej kategorii produktów, ale bez podzapytañ nie jesteœ w stanie tylko ich wyœwietliæ.
SELECT c.SalesPerson, pc.Name CategoryName, SUM(TotalDue) AS TotalSales
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID=c.CustomerID
JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID=soh.SalesOrderID
JOIN SalesLT.Product AS p ON p.ProductID=sod.ProductID
JOIN SalesLT.ProductCategory AS pc ON pc.ProductCategoryID=p.ProductCategoryID
GROUP BY c.SalesPerson, pc.Name
ORDER BY SUM(TotalDue) DESC;

--Bez u¿ywania `JOIN`, `GROUP BY`, znajdŸ top 3 klientów pod wzglêdem ³¹cznej kwoty wydatków.
SELECT TOP 3 FirstName, LastName,
(SELECT SUM(TotalDue) 
FROM SalesLT.SalesOrderHeader AS soh 
WHERE soh.CustomerID=c.CustomerID )  AS TotalAmount 
FROM SalesLT.Customer AS c 
ORDER BY TotalAmount DESC;

--Bez u¿ywania `GROUP BY`, znajdŸ top 5 modeli produktów sprzedanych (z najwiêksz¹ liczb¹ sprzedanych iloœci) w stanie '`California`'.
SELECT TOP 5 pm.Name, 
	(SELECT COUNT(*) 
	FROM SalesLT.Product AS p
	JOIN SalesLT.SalesOrderDetail sod ON sod.ProductID=p.ProductID
	JOIN SalesLT.SalesOrderHeader soh ON soh.SalesOrderID=sod.SalesOrderID
	JOIN SalesLT.Address a ON a.AddressID=soh.BillToAddressID
	WHERE p.ProductModelID=pm.ProductModelID AND a.StateProvince='California') SoldCount
FROM SalesLT.ProductModel pm
ORDER BY SoldCount DESC;

--Bez u¿ywania `JOIN`, `GROUP BY`, zwróæ unikalne numery zamówieñ (`SalesOrderID`) z tabeli `SalesOrderDetail`, dla których jakikolwiek produkt nale¿y do kategorii `Helmets`.
SELECT DISTINCT SalesOrderID
FROM SalesLT.SalesOrderDetail
WHERE ProductID IN 
	(SELECT ProductID
	FROM SalesLT.Product
	WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE [Name]='Helmets'));

--ZnajdŸ sprzedawców, którzy zrobili najwiêksze obroty (`TotalDue` z tabeli `SalesOrderHeader`) w danej kategorii produktów.
SELECT c.SalesPerson, pc.Name CategoryName, SUM(TotalDue) AS TotalSales
	FROM SalesLT.Customer AS c
	JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID=c.CustomerID
	JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID=soh.SalesOrderID
	JOIN SalesLT.Product AS p ON p.ProductID=sod.ProductID
	JOIN SalesLT.ProductCategory AS pc ON pc.ProductCategoryID=p.ProductCategoryID
	GROUP BY c.SalesPerson, pc.Name
	HAVING SUM(TotalDue) IN (
	SELECT MAX(TotalSales) AS MaxTotalSales
	FROM (
		SELECT c.SalesPerson, pc.Name CategoryName, SUM(TotalDue) AS TotalSales
		FROM SalesLT.Customer AS c
		JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID=c.CustomerID
		JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID=soh.SalesOrderID
		JOIN SalesLT.Product AS p ON p.ProductID=sod.ProductID
		JOIN SalesLT.ProductCategory AS pc ON pc.ProductCategoryID=p.ProductCategoryID
		GROUP BY c.SalesPerson, pc.Name) AS sq
	GROUP BY sq.CategoryName);