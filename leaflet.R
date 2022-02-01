

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


#read in second polygon shapefile
gw_jeff <- st_read('sData/gw_jeff.shp') %>%
            select(4, 13) %>%
            rename(name = NFSLANDU_2) %>%
            st_transform(CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))



#read in third polygon shapefile
potomac <- st_read('sData/potomac.shp') %>%
            select(4, 5) %>%
           st_transform( CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

# driftless

driftless <- st_read('sData/driftless.shp') %>%
  select(3, 4) %>%
  st_transform("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")


# nevada
nevada <- st_read('sData/nevada.shp') %>%
  select(7, 15) %>%
  rename(name = NAME) 

# wisconsin
wisconsin<- st_read('sData/wisconsin.shp')%>%
  select(1, 15) %>%
  rename(name = REGION) 

# abrp
abrp <- st_read('sData/abrp.shp')%>%
  select(13, 16)  %>%
  st_transform("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# deerCreek
deerCreek <- st_read('sData/deerCreek.shp') %>%
  select(1, 4)  %>%
  rename(name = NzProposed) %>%
  st_transform("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Green Mountain NF
gmnf <- st_read('sData/gmnf.shp') %>% # read in shapefile %>%
  select(1, 4) %>% # keep only needed columns
  rename(name = OBJECTID)  %>%  # rename column "OBJECTID" to "name"
  st_transform("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") 
  gmnf$name[1] <- "Green Mountain National Forest"   # change value "1" to "Green Mountain National Forest"
  
# Ten Sleep
tenSleep <- st_read('sData/tenSleep.shp')%>%
  select(2, 14)%>%
  rename(name = US_L3NAME) %>%
  st_transform("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") 

# Pennsylvania Marten Project
pennsylvania <- st_read('sData/pennsylvania.shp') %>%
  select(7, 15) %>%
  rename(name = NAME) %>%
  st_transform("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") 

# Black Hills
blackHills <- st_read('sData/blackHills.shp') %>%
  select(4, 31) %>%
  rename(name = US_L4NAME) %>%
  st_transform("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") 


blackHills$name[1] <- "Black Hills" 
  
  
# combine separate polygon spatial dataframes into one

all_projects <- rbind(gmnf,
                      vermont, 
                      gw_jeff, 
                      potomac,
                      driftless,
                      nevada,
                      wisconsin,
                      abrp,
                      deerCreek,
                      tenSleep,
                      pennsylvania,
                      blackHills
                      )
plot(all_projects)

# add in components
components <- read_csv("components.csv")
#View(components)

projects <- merge(all_projects, components, by = 'name')

write_sf(projects, "./sData/projects.shp")

# Make popup
popup <- paste("Project Name", projects$name, "<br>",
              "Sufficiency:", projects$sufficiency, "<br>",
              "Durability:", projects$durability, "<br>",
              "Condition:", projects$condition)


# da map
projectsMap <-
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(-98.483330, 38.712046, zoom = 4) %>%  
  addPolygons(data = projects, 
              fill = TRUE, 
              fillOpacity = 0.5,
              fillColor = '#B1DAB3',
              stroke = TRUE, 
              weight = 0.8,
              color = "#526653",
              popup = ~popup)

projectsMap

library(htmlwidgets)
saveWidget(projectsMap, 'projectsMap.html', selfcontained = TRUE)








