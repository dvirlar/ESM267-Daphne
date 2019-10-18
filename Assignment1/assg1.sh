# Aim of the script:
	#Use ogr2ogr to extract outline of SB County, and re-project it into NAD83/California Albers

#Create new folders, but make them so that they don't overwrite already existent folders.
#This should allow it to run more easily on other computers
mkdir -p output


# This tells us all of the generic info for the shapefile
ogrinfo -al -so tl_2018_us_county/tl_2018_us_county.shp
 

# Reproject the county data from NAD83 to NAD83/California Albers
ogr2ogr -t_srs EPSG:3310 output/counties.shp tl_2018_us_county/tl_2018_us_county.shp

# Check to make sure that the output file is in California Albers
ogrinfo -al -so output/counties.shp

#Specifying Santa Barbara County from the whole county list
ogr2ogr -where "name='Santa Barbara'" output/SB_County.shp output/counties.shp

#Now that we have just Santa Barbara County, we can clip to the tiff
#Use gdalwarp to extract MODIS image that intersects outlines of SB county. Then reproject into California Albers

#Use gdalwarp on the tif, bc that's what it's used for, to re-project the raw file from MODIS.
gdalwarp -t_srs EPSG:3310 crefl2_A2019257204722-2019257205812_250m_ca-south-000_143.tif output/CA_reprojection.tif

#steps
	#crop to cutline crops to the extent of the target dataset to the extent of the cutline.
	#therefore, we need to use cutline FIRST
	


# gdalwarp -cutline INPUT.shp -crop_to_cutline -dstalpha INPUT.tif OUTPUT.tif
gdalwarp -cutline output/SB_County.shp -crop_to_cutline -dstalpha output/CA_reprojection.tif output/SB_County.tif