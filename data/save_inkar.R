library(dplyr)
library(arrow)
library(vroom)

temp_dir <- tempdir()

URL <- "https://www.bbr-server.de/imagemap/inkar/download/inkar_2021.zip"

download.file(URL, file.path(temp_dir, "inkar_2021.zip"),  mode = "wb")

unzip(file.path(temp_dir, "inkar_2021.zip"), 
      files = "inkar_2021.csv", 
      exdir = temp_dir, 
      unzip = "unzip", 
      setTimes = TRUE)

inkar_2021 <- vroom(file.path(temp_dir, "inkar_2021.csv"), 
                    locale = locale(grouping_mark = ".", decimal_mark = ",", encoding = "UTF-8"),
                    col_types = 
                      cols(
                        Bereich = col_character(),
                        ID = col_double(),
                        Indikator = col_character(),
                        Raumbezug = col_character(),
                        Kennziffer = col_double(),
                        Kennziffer_EU = col_character(),
                        Name = col_character(),
                        Zeitbezug = col_character(),
                        Wert = col_double()
                    ))

attr(inkar_2021, "CSVFileDate") <- file.info(file.path(temp_dir, "inkar_2021.csv"))$mtime

write_parquet(x = inkar_2021, sink = "data/inkar_2021.parquet") 

saveRDS(object = inkar_2021, file = "data/inkar_2021.RDS")

unlink(temp_dir)
