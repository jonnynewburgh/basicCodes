library(tidyverse)
library(sf) #requires an sf object
library(mapview)

#select file -- must be csv
fileToLoad <- file.choose(new = TRUE)
origAddress <- read.csv(fileToLoad, stringsAsFactors = FALSE)

#format loaded data frame
addresses <- as.data.frame(origAddress)
names(addresses) <- c("place","name")
addresses$place <- as.character(addresses$place)

#prepare geocoded file
geocoded <- data.frame(stringsAsFactors = F)

#attach longitude and latitude
for(i in 1:nrow(addresses))
{
  result <- geocode(addresses$place[i], output = "latlona", source = "dsk")
  addresses$lon[i] <- as.numeric(result[1])
  addresses$lat[i] <- as.numeric(result[2])
  addresses$geoAddress[i] <- as.character(result[3])
}

#map locations
locations_df <- st_as_sf(addresses, coords = c("lon", "lat"), crs = 4326)
rownames(locations_df) <- addresses$est
mapview(locations_df)

