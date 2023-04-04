Select saledate
From master.dbo.NashvilleHousingData

Select *
From master.dbo.NashvilleHousingData
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM master.dbo.NashvilleHousingData a
JOIN master.dbo.NashvilleHousingData b
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null 

-- update null values in table
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM master.dbo.NashvilleHousingData a
JOIN master.dbo.NashvilleHousingData b
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Pull up Property address 
Select PropertyAddress
From master.dbo.NashvilleHousingData
-- Where PropertyAddress is null
-- order by ParcelID

-- Separate address by Street Name and City 
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM master.dbo.NashvilleHousingData 

-- Alter Table to Add New Column for Split Address 
SELECT * 
FROM master.dbo.NashvilleHousingData
ALTER TABLE master.dbo.NashvilleHousingData
Add PropertySplitAddress Nvarchar(255);

-- Update Table to include Property Split Address 
Update master.dbo.NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

-- Alter Table to Add New Column for Split City
ALTER TABLE master.dbo.NashvilleHousingData
Add PropertySplitCity Nvarchar(255);

-- Update Table to include Property Split City 
Update master.dbo.NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

-- Check to ensure all updates have been added correctly
SELECT * 
FROM master.dbo.NashvilleHousingData

-- Replacement
SELECT OwnerAddress
FROM master.dbo.NashvilleHousingData

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM master.dbo.NashvilleHousingData

-- Make replacement changes?
ALTER TABLE master.dbo.NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

Update master.dbo.NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE master.dbo.NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);

Update master.dbo.NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE master.dbo.NashvilleHousingData
Add OwnerSplitState Nvarchar(255);

Update master.dbo.NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- Check to ensure all updates have been added correctly
SELECT * 
FROM master.dbo.NashvilleHousingData

-- Remove duplicates 
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				--  PropertyAddress,
				 SalePrice,
				--  SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From master.dbo.NashvilleHousingData
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From master.dbo.NashvilleHousingData

-- Delete unused columns 
ALTER TABLE master.dbo.NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From master.dbo.NashvilleHousingData