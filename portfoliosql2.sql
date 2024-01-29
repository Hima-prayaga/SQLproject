--cleaning data in SQL

Select *
from portfolio_project2.dbo.[Nashville housing]
order by 1


----changing the date format to only date
 select Saledate ,convert(date,saledate)
 from [Nashville housing]


 alter table [nashville housing]
 add Saledateconverted date;

 update [Nashville housing]
 set saledateconverted = convert(date,saledate)

 select saledate,saledateconverted
 from [Nashville housing]

 --populate property address data(fill the nulls)

 select Propertyaddress
 from [Nashville housing]
 where PropertyAddress is null

 select *
 from [Nashville housing]

 select a.parcelID, a.Propertyaddress,b.ParcelID,b.PropertyAddress ,isnull(a.propertyaddress,b.propertyaddress)
 from [Nashville housing] a
 join [Nashville housing] b
 on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set Propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from [Nashville housing] a
 join [Nashville housing] b
 on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--seperating the propertadress and owner adress using the substring and the parsename


select PropertyAddress
from [Nashville housing]

select 
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress) -1) ,
SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1, len(Propertyaddress)) 
from [Nashville housing]

alter table [nashville housing]
 add propertysplitadress nvarchar(255);

 update [Nashville housing]
 set propertysplitadress = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress) -1)

 alter table [nashville housing]
 add Propertycity nvarchar(255);

 update [Nashville housing]
 set Propertycity = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1, len(Propertyaddress)) 

 --owneraddress

 select 
 PARSENAME(replace(owneraddress,',','.'),3),
 PARSENAME(replace(owneraddress,',','.'),2),
 PARSENAME(replace(owneraddress,',','.'),1)
 from [nashville housing]

 alter table [nashville housing]
 add ownersplitaddress nvarchar(255);

 update [Nashville housing]
 set ownersplitaddress = PARSENAME(replace(owneraddress,',','.'),3)

 alter table [nashville housing]
 add ownersplitcity nvarchar(255);

 update [Nashville housing]
 set ownersplitcity = PARSENAME(replace(owneraddress,',','.'),2)

 alter table [nashville housing]
 add ownerstate nvarchar(255);

 update [Nashville housing]
 set ownerstate = PARSENAME(replace(owneraddress,',','.'),1)

 select *
 from [Nashville housing]


 --Changing y and n to yes and no in soldasvacant

 select distinct(soldasvacant), count(soldasvacant)
 from [Nashville housing]
 group by SoldAsVacant

 select Soldasvacant,
 case when soldasvacant = 'y' then 'Yes'
      when soldasvacant = 'n' then 'No'
	  else soldasvacant
	  end
from [Nashville housing]
 
 Update [Nashville housing]
 set soldasvacant = case when soldasvacant = 'y' then 'Yes'
      when soldasvacant = 'n' then 'No'
	  else soldasvacant
	  end

--removing the duplicates
with rownumcte as(
select *,
ROW_NUMBER() over ( partition by
   parcelId, 
   propertyaddress,
   saledate,
   saleprice,
   legalreference
   order by uniqueid) as row_num
from [Nashville housing]
)

select *
from rownumcte
where row_num>1
order by ParcelID

delete 
from rownumcte
where row_num>1

--delete unused columns
select *
from [Nashville housing]

alter table [nashville housing]
drop column propertyaddress,owneraddress,taxdistrict,saledate