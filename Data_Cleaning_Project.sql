/* Data Cleaning SQL Queries
*/
SELECT * FROM Portfolio_Projects.dbo.NashvelliHousing

-------------------------------------------------------------------------------------------------------------------------
--Standardize Date Formate

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Portfolio_Projects.dbo.NashvelliHousing


UPDATE Portfolio_Projects.dbo.NashvelliHousing
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE NashvelliHousing
ADD SaleDateConverted Date


UPDATE Portfolio_Projects.dbo.NashvelliHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM Portfolio_Projects.dbo.NashvelliHousing


SELECT * FROM Portfolio_Projects.dbo.NashvelliHousing


-------------------------------------------------------------------------------------------------------------------------------
--Populate Property Address

SELECT *
FROM Portfolio_Projects.dbo.NashvelliHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Projects.dbo.NashvelliHousing AS a
JOIN Portfolio_Projects.dbo.NashvelliHousing AS b
ON a.ParcelID =b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Projects.dbo.NashvelliHousing AS a
JOIN Portfolio_Projects.dbo.NashvelliHousing AS b
ON a.ParcelID =b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


SELECT * FROM Portfolio_Projects.dbo.NashvelliHousing

-----------------------------------------------------------------------------------------------------------------------------------
--Breaking Out Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM Portfolio_Projects.dbo.NashvelliHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress )+1 , LEN(PropertyAddress)) AS Address
FROM Portfolio_Projects.dbo.NashvelliHousing

ALTER TABLE NashvelliHousing
ADD PropertySplitAddress Nvarchar(255)


UPDATE NashvelliHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 )

ALTER TABLE NashvelliHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvelliHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress )+1 , LEN(PropertyAddress))

SELECT * 
FROM NashvelliHousing

SELECT OwnerAddress 
FROM Portfolio_Projects.dbo.NashvelliHousing

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvelliHousing

ALTER TABLE NashvelliHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvelliHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvelliHousing
ADD OwnerSplitCity Nvarchar(255)


UPDATE NashvelliHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvelliHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvelliHousing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



SELECT * FROM Portfolio_Projects.dbo.NashvelliHousing

---------------------------------------------------------------------------------------------------------------------------------
-- Change y and N to Yes and No in 'SoldAsVacant' filed

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolio_Projects.dbo.NashvelliHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Portfolio_Projects.dbo.NashvelliHousing


UPDATE NashvelliHousing
SET SoldAsVacant =CASE
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


SELECT * FROM Portfolio_Projects.dbo.NashvelliHousing

---------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNum_CTE AS(
SELECT *, 
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
					 UniqueID) AS row_num
FROM NashvelliHousing)
SELECT * FROM RowNum_CTE
WHERE row_num >1
ORDER BY PropertyAddress




-------------------------------------------------------------------------------------------------------------------------------------
--Delete Unused Columns

SELECT * FROM Portfolio_Projects.dbo.NashvelliHousing


ALTER TABLE Portfolio_Projects.dbo.NashvelliHousing
DROP COLUMN  OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE Portfolio_Projects.dbo.NashvelliHousing
DROP COLUMN  SaleDate