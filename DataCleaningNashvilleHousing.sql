-- New script in master.
-- Date: Dec 22, 2022
-- Time: 2:07:32 PM

/*
Cleaning Data in SQL Queries
*/



SELECT *
FROM NashvilleHousing nh 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate, CONVERT (Date, SaleDate)
FROM NashvilleHousing nh 

Update NashvilleHousing 
SET SaleDate = CONVERT (Date, SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select
    *
From
    PortfolioProject.dbo.NashvilleHousing
    --Where PropertyAddress is null
order by
    ParcelID
    
  
SELECT
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelID,
    b.PropertyAddress,
    ISNULL(
        a.PropertyAddress,
        b.PropertyAddress
    )
FROM
    NashvilleHousing a
JOIN NashvilleHousing b 
ON
    a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
    
    
WHERE a.PropertyAddress is null



Update
    a
SET
    PropertyAddress = ISNULL(
        a.PropertyAddress,
        b.PropertyAddress
    )
From
    NashvilleHousing a
JOIN NashvilleHousing b
    on
    a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
Where
    a.PropertyAddress is null
    
    
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
    
    
    
SELECT
    PropertyAddress
From
    NashvilleHousing nh
    
SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From
    NashvilleHousing nh
    
    
    
ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


Update
    NashvilleHousing
SET
    PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



SELECT PropertySplitAddress, PropertySplitCity 
FROM NashvilleHousing nh 



Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
    PARSENAME(
        REPLACE(OwnerAddress, ',', '.') ,
        3
    )
,
    PARSENAME(
        REPLACE(OwnerAddress, ',', '.') ,
        2
    )
,
    PARSENAME(
        REPLACE(OwnerAddress, ',', '.') ,
        1
    )
From
    NashvilleHousing
    
    
    
    
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select
    *
From
    PortfolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
    

SELECT
    SoldAsVacant,
    CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END

    
Update
    NashvilleHousing
SET
    SoldAsVacant = CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END
    
    
SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
From  NashvilleHousing nh 
Group By SoldAsVacant 



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
    Select
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
        ORDER BY
                    UniqueID
        ) row_num
    From
        NashvilleHousing
)

Select *
From RowNumCTE




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate