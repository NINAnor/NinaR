CREATE OR REPLACE FUNCTION generate_viewshed(coordxy text) RETURNS text as
$$
  library(rgrass7)
coords <- as.numeric(unlist(strsplit(coordxy,",")))
#print(coords)
require(rgrass7)
initGRASS(gisBase ='/usr/local/grass-7.2.svn/', home = tempdir(), gisDbase = "/data/grassdata/", location = "ETRS_33N", mapset = "u_postgres", override = TRUE)
execGRASS("g.region", parameters = list(n="6992700", s="6990500", e="311500", w="309300", align="dem_10m_nosefi@PERMANENT"))
execGRASS("r.viewshed", parameters = list(input = "dem_10m_nosefi@PERMANENT", output = "viewshed_raster", coordinates = c(310400,6991600), observer_elevation = 25, max_distance = 1000), flags = c("b", "overwrite"))
execGRASS("r.to.vect", parameters = list(input = "viewshed_raster", output = "viewshed_vector", type = "area"), flags = c("overwrite"))
execGRASS("v.out.postgis", parameters = list(input = "viewshed_vector", output = "PG:dbname=gisdata user=jens.astrom", output_layer = "ninjea.viewshed_vector", type = "area"))
print('done')
;
$$
  LANGUAGE 'plr';
v.out.ogr input=polygons type=area output="PG:host=localhost dbname=gisdata user=postgres" output_layer=polymap format=PostgreSQL



###################

CREATE OR REPLACE FUNCTION generate_viewshed(coordxy text) RETURNS text as
$$
  library(rgrass7)
coords <- as.numeric(unlist(strsplit(coordxy,",")))
coords <- as.data.frame("x"=coords[1], "y"=coords[2])
#print(coords)
library(rgrass7)


#hmGrass <- function(){
#system("hostname")
#}
#tt<-hmGrass()
#print(tt)

initGRASS(gisBase ='/usr/local/grass-7.2.svn/', home = tempdir(), gisDbase = "/data/grassdata/", location = "ETRS_33N", mapset = "postgres", override = TRUE)

getViewshed <- function(xycoords, return = TRUE, dist = 100, observer_elevation = 1.75, target_elevation = 0){

  ##Calculate suitable boundary
  my_point = xycoords
  max_x <- my_point$x + 1.1*dist
  max_y <- my_point$y + 1.1*dist
  min_x <- my_point$x - 1.1*dist
  min_y <- my_point$y - 1.1*dist

  ##Set g.region
  execGRASS("g.region", align = "dem_10m_nosefi@PERMANENT",
            n = as.character(max_y), s = as.character(min_y), e = as.character(max_x),
            w = as.character(min_x))
  ##Get viewshed
  execGRASS("r.viewshed", parameters = list(input = "dem_10m_nosefi@PERMANENT", output = "viewshed_raster",
                                            coordinates = c(my_point$x, my_point$y),
                                            observer_elevation = observer_elevation,
                                            target_elevation = target_elevation,
                                            max_distance = dist),
            flags = c("b", "c","overwrite"))

  execGRASS("r.to.vect", parameters = list(input = "viewshed_raster", output = "viewshed_vector", type = "area"),
            flags = c("overwrite"))

  if(return==T){
    out <- readVECT("viewshed_vector")
    return(out)
  }}

print('done')

getViewshed(xycoords=coords)

$$
  LANGUAGE 'plr' STRICT;
