

# leaflet of projects

##load libraries
library(rgdal)
library(raster)
library(htmlwidgets)
library(leaflet)
library(tidyverse)
library(sf)

#read in first polygon shapefile
vermont <- st_read('sData/vermont.shp')
#keep columns "NAME" and "geometry"
# change "NAME" to 'name'
vermont <- vermont %>%
          select(7, 15) %>%
          rename(name = NAME)
# reproject
vermont <- st_transform(vermont, CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
plot(vermont)

#read in second polygon shapefile
gw_jeff <- st_read('sData/gw_jeff.shp') %>%
            select(4, 13) %>%
            rename(name = NFSLANDU_2) %>%
            st_transform(CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

plot(gw_jeff)

#read in third polygon shapefile
potomac <- st_read('sData/potomac.shp') %>%
            select(4, 5) %>%
           st_transform( CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

plot(potomac)

# try first two, then will add in third

projects <- st_union(vermont, gw_jeff)
plot(projects)


projects3 <- st_union(projects, potomac)
str(projects)
plot(projects3)

write_sf(projects, "./sData/projects.shp")

# da map
projectsMap <-
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(-98.483330, 38.712046, zoom = 4) %>%  
  addPolygons(data = projects, 
              fill = TRUE, 
              fillOpacity = 0.7,
              fillColor = '#B1DAB3',
              stroke = TRUE, 
              weight = 0.3,
              color = "#526653")

projectsMap

library(htmlwidgets)
saveWidget(projectsMap, 'projectsMap.html', selfcontained = TRUE)








