--Wybierz wszystkie pola z tabeli `SalesLT.Customer`.
SELECT * FROM SalesLT.Customer;

--Wybierz unikalne nazwy miast z tabeli `SalesLT.Address`.
SELECT DISTINCT City FROM SalesLT.Address;

--Wybierz imi�, nazwisko oraz adres e-mail pierwszych 10 klient�w. Wy�wietl rezultaty jako, 'FirstName', 'LastName', 'Email'.
SELECT TOP 10 FirstName, LastName, EmailAddress AS Email 
FROM SalesLT.Customer;

--Pobiera wszystkie adresy (tabela `SalesLT.Address`), kt�re znajduj� si� w stanie California (kolumna StateProvince).
SELECT *
FROM SalesLT.Address
WHERE  StateProvince = 'California'

--Znajduje wszystkie produkty (tabela SalesLT.Product), kt�rych cena sprzeda�y ListPrice przekracza 1000, ale maksymalnie wynosi 2000.
SELECT * 
FROM SalesLT.Product 
WHERE ListPrice between 1000 AND 2000;

--Znajduje wszystkich klient�w, kt�rzy maj� wype�nione pole MiddleName i Suffix.
SELECT * 
FROM SalesLT.Customer 
WHERE MiddleName is not null and Suffix is not null;

--Wy�wietla wszystkie zam�wienia (tabela SalesLT.SalesOrderHeader), kt�rych data zako�czenia sprzeda�y ShipDate jest p�niejsza ni� data zam�wienia OrderDate.
SELECT * 
FROM SalesLT.SalesOrderHeader 
WHERE ShipDate > OrderDate;

--Zwraca wszystkie produkty, kt�re by�y na wyprzeda�y w 2005 roku, co najmniej dzie� (SellStartDate/SellEndDate)
SELECT * 
FROM SalesLT.Product 
WHERE (YEAR(SellStartDate) <= 2005) and (YEAR(SellEndDate)>=2005 or YEAR(SellEndDate) is null) and (DATEDIFF(DAY,SellStartDate, SellEndDate)>1 or DATEDIFF(DAY,SellStartDate, SellEndDate) is null);

--Sortuje szczeg�y zam�wie� (tabela SalesLT.SalesOrderDetail) wed�ug ilo�ci zam�wio� (OrderQty) w kolejno�ci malej�cej, zwracaj�c informacje z kolumn SalesOrderID, OrderQty oraz UnitPrice, tylko dla zam�wie�, kt�re maj� ilo�� zam�wionych produkt�w wi�ksz� ni� 5.
SELECT SalesOrderID, OrderQty, UnitPrice 
FROM SalesLT.SalesOrderDetail 
WHERE OrderQty>5 
ORDER BY OrderQty DESC;

--Zwraca posortowane zam�wienia (tabela: SalesLT.SalesOrderHeader) wed�ug daty zam�wienia OrderDate w kolejno�ci rosn�cej, dodatkowo je�li zam�wienia maj� t� sam� dat� to posortujemy je wed�ug ceny ca�kowitej SubTotal w kolejno�ci malej�cej.
SELECT * 
FROM SalesLT.SalesOrderHeader 
ORDER BY OrderDate, SubTotal DESC;

--Zwraca produk o najni�szej cenie.
SELECT TOP 1 * 
FROM SalesLT.[Product] 
ORDER BY ListPrice;

--Zwraca sume wszystkich nalerzno�ci.
SELECT SUM(TotalDue) AS SumPrice 
FROM SalesLT.SalesOrderHeader;

--Zwraca liczb� miast dla ka�dego stanu StateProvince z osobna.
SELECT StateProvince, COUNT(DISTINCT City) AS AmountOfCities
FROM SalesLT.Address 
GROUP BY StateProvince;

--Zwraca liczb� klient�w obs�ugiwanych przez danego sprzedawc� (tabela Customer, kolumna SalesPerson).
SELECT SalesPerson, COUNT(*) AS CountOfCustomer 
FROM SalesLT.Customer 
GROUP BY SalesPerson;

--Zwraca sprzedawce z najwi�ksz� liczb� przypisanych klient�w.
SELECT TOP 1 SalesPerson, COUNT(*) AS CountOfCustomer 
FROM SalesLT.Customer 
GROUP BY SalesPerson 
ORDER BY CountOfCustomer DESC;

--Zwraca �redni� warto�� ListPrice produkt�w w danychm kolorze, kt�rych cena ListPrice jest wi�ksza ni� 100.
SELECT Color, AVG(ListPrice) 
FROM SalesLT.Product 
WHERE ListPrice>100 
GROUP BY Color;

--Zwraca cene najta�szego produktu w danym rozmiarze Size.
SELECT Size, MIN(ListPrice) AS Price  
FROM SalesLT.Product 
GROUP BY Size 
ORDER BY Price;

--Znajd� wszystkich sprzedawc�w SalesPerson, kt�rzy obsluguj� co najmniej 100 klient�w.
SELECT SalesPerson, COUNT(*) 
FROM SalesLT.Customer 
GROUP BY SalesPerson 
HAVING COUNT(*)>100;

--Znajd� kt�re modele (produktu ProductModelID), maj� �redni� cene produktu ListPrice wi�ksz� ni� 300.
SELECT ProductModelID, AVG(ListPrice) AS AvaragePrice 
FROM SalesLT.Product 
GROUP BY ProductModelID 
HAVING AVG(ListPrice)>300;

--Znajd� kolory Color produkt�w, kt�re maj� miminaln� cen� ListPrice 30.
SELECT Color, MIN(ListPrice) AS MinimumPrice 
FROM SalesLT.Product 
GROUP BY Color 
HAVING MIN(ListPrice)>30;

--Szuka top 3 klient�w pod wzgl�dem ��cznej kwoty wydatk�w (TotalDue z tabeli SalesOrderHeader).
SELECT TOP 3 FirstName, LastName, SUM(soh.TotalDue) 
FROM SalesLT.Customer AS c 
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID=soh.CustomerID 
GROUP BY c.CustomerID, c.FirstName, c.LastName 
ORDER BY SUM(soh.TotalDue) DESC;

--Znajd� top 5 modeli produkt�w sprzedanych (z najwi�ksz� liczb� sprzedanych ilo�ci) w stanie '`California`'.
SELECT TOP 5 pm.Name NameOfModel, COUNT(*) SoldCount 
FROM SalesLT.ProductModel pm
JOIN SalesLT.Product p ON pm.ProductModelID=p.ProductModelID
JOIN SalesLT.SalesOrderDetail AS sod ON p.ProductID=sod.ProductID
JOIN SalesLT.SalesOrderHeader AS soh ON sod.SalesOrderID=soh.SalesOrderID
JOIN SalesLT.Address AS a ON soh.BillToAddressID=a.AddressID
WHERE a.StateProvince='California'
GROUP BY pm.Name
ORDER BY COUNT(*) DESC;

--Znajd� adresy klient�w, kt�rzy kupili produkty z kategorii rower�w '`Bikes`'.
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

--Znajdz sprzedawce, kt�ry sprzeda� najwi�cej produkt�w z kategorii '`Clothing`'.
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

--Znajd� sprzedawc�w, kt�rzy zrobili najwi�ksze obroty (`TotalDue` z tabeli `SalesOrderHeader`) w danej kategorii produkt�w, ale bez podzapyta� nie jeste� w stanie tylko ich wy�wietli�.
SELECT c.SalesPerson, pc.Name CategoryName, SUM(TotalDue) AS TotalSales
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID=c.CustomerID
JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID=soh.SalesOrderID
JOIN SalesLT.Product AS p ON p.ProductID=sod.ProductID
JOIN SalesLT.ProductCategory AS pc ON pc.ProductCategoryID=p.ProductCategoryID
GROUP BY c.SalesPerson, pc.Name
ORDER BY SUM(TotalDue) DESC;

--Bez u�ywania `JOIN`, `GROUP BY`, znajd� top 3 klient�w pod wzgl�dem ��cznej kwoty wydatk�w.
SELECT TOP 3 FirstName, LastName,
(SELECT SUM(TotalDue) 
FROM SalesLT.SalesOrderHeader AS soh 
WHERE soh.CustomerID=c.CustomerID )  AS TotalAmount 
FROM SalesLT.Customer AS c 
ORDER BY TotalAmount DESC;

--Bez u�ywania `GROUP BY`, znajd� top 5 modeli produkt�w sprzedanych (z najwi�ksz� liczb� sprzedanych ilo�ci) w stanie '`California`'.
SELECT TOP 5 pm.Name, 
	(SELECT COUNT(*) 
	FROM SalesLT.Product AS p
	JOIN SalesLT.SalesOrderDetail sod ON sod.ProductID=p.ProductID
	JOIN SalesLT.SalesOrderHeader soh ON soh.SalesOrderID=sod.SalesOrderID
	JOIN SalesLT.Address a ON a.AddressID=soh.BillToAddressID
	WHERE p.ProductModelID=pm.ProductModelID AND a.StateProvince='California') SoldCount
FROM SalesLT.ProductModel pm
ORDER BY SoldCount DESC;

--Bez u�ywania `JOIN`, `GROUP BY`, zwr�� unikalne numery zam�wie� (`SalesOrderID`) z tabeli `SalesOrderDetail`, dla kt�rych jakikolwiek produkt nale�y do kategorii `Helmets`.
SELECT DISTINCT SalesOrderID
FROM SalesLT.SalesOrderDetail
WHERE ProductID IN 
	(SELECT ProductID
	FROM SalesLT.Product
	WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE [Name]='Helmets'));

--Znajd� sprzedawc�w, kt�rzy zrobili najwi�ksze obroty (`TotalDue` z tabeli `SalesOrderHeader`) w danej kategorii produkt�w.
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