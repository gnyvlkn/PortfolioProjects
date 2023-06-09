-- select all the data

Select *
From dbo.NashvilleHousing

-- standardize date format

Select SaleDate_New	, CONVERT(date,SaleDate)
From dbo.NashvilleHousing


Alter Table NashvilleHousing
Add SaleDate_New date;

Update NashvilleHousing
Set SaleDate_New = CONVERT(date,SaleDate)


--Populate Property Address Data Nulls (Add Address Into Property Address Data Nulls based on Parcel ID)

Select a.UniqueID, a.ParcelID,a.PropertyAddress, b.UniqueID, b.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is NULL


Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is NULL


Select *
From PortfolioProject.dbo.NashvilleHousing

--Breaking out adress into individual columns (Property Address)

Select
Substring(PropertyAddress, 1 , Charindex(',',PropertyAddress)-1) as address ,
Substring(PropertyAddress, Charindex(',',PropertyAddress)+1 , LEN(PropertyAddress))as address
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertyAddress_new nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set PropertyAddress_new=Substring(PropertyAddress, 1 , Charindex(',',PropertyAddress)-1)


Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertyAddress_city nvarchar(255)


Update PortfolioProject.dbo.NashvilleHousing
Set PropertyAddress_city = Substring(PropertyAddress, Charindex(',',PropertyAddress)+1 , LEN(PropertyAddress))

Select PropertyAddress_new
From PortfolioProject.dbo.NashvilleHousing

--Another approach for breaking out adress into individual columns (OwnerAddress)

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
Parsename(replace(OwnerAddress , ',' , '.'), 3)
From PortfolioProject.dbo.NashvilleHousing

Select
Parsename(replace(OwnerAddress , ',' , '.'), 2)
From PortfolioProject.dbo.NashvilleHousing

Select
Parsename(replace(OwnerAddress , ',' , '.'), 1)
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerAddress_new nvarchar(255),


Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerAddress_city nvarchar(255)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerAddress_province nvarchar(255)



Update PortfolioProject.dbo.NashvilleHousing
Set OwnerAddress_new=Parsename(replace(OwnerAddress , ',' , '.'), 3)


Update PortfolioProject.dbo.NashvilleHousing
Set Owneraddress_city=Parsename(Replace(OwnerAddress, ',','.'), 2)

Update PortfolioProject.dbo.NashvilleHousing
Set Owneraddress_province=Parsename(Replace(OwnerAddress, ',','.'), 1)

Select *
from PortfolioProject.dbo.NashvilleHousing
