Select *
From PortfolioProject.dbo.NashvilleHousing

-- Stanardize Date Format
Select SaleDateConverted, Convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)



--Populating Property Address


Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--Breaking out Address into individual columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address
, Substring(PropertyAddress,  Charindex(',', PropertyAddress) + 1, Len(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress,  Charindex(',', PropertyAddress) + 1, Len(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
Parsename(Replace(OwnerAddress, ',','.'),3)
,Parsename(Replace(OwnerAddress, ',','.'),2)
,Parsename(Replace(OwnerAddress, ',','.'),1)
From PortfolioProject.dbo.NashvilleHousing




Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress, ',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = Parsename(Replace(OwnerAddress, ',','.'),1)


Select *
From PortfolioProject.dbo.NashvilleHousing




-- Change y and n to yes and no in "sold as vacant' field


Select Distinct(Soldasvacant), Count(Soldasvacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldasVacant
order by 2

Select SoldAsVacant
, Case when Soldasvacant = 'Y' then 'Yes'
	   when Soldasvacant = 'N' then 'No'
	   else SoldasVacant
	   end
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set Soldasvacant = Case when Soldasvacant = 'Y' then 'Yes'
	   when Soldasvacant = 'N' then 'No'
	   else SoldasVacant
	   end


--- Remove Duplicates


WITH RowNumCTE as(
Select *,
	Row_Number() Over(
	Partition BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order by 
	UniqueID
	) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--Delete Unused columns (ALWAYS SEEK PERMISSION FROM SUPERVISOR TO DELETE COLUMNS)


Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDIstrict, PropertyAddress 

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate