get_artists_data <- function() {
  
    
    file_path <- './data/music_artist_data.rds'
    if(file.exists(file_path)) {
      
      last_update_date <- date(file.mtime(file_path))
    } else {
      last_update_date <- fastPOSIXct('1970-01-01')
    }
    if(last_update_date==today()) {
      
      artist_data <- readRDS(file = file_path)  
    } else {
      
      artist_query <- paste0("")
      
      artist_data <- run_query(query_string = artist_query, db_type = 'sql')
      artist_data <- data.table(artist_data)
      saveRDS(object = artist_data, file = file_path)
    }
    
    artist_data
}


get_music_map <- function() {
  
  table_name <- 'music_map'
  filepath_db <- paste0('./data/', table_name, ".csv")
  filepath_rds <- paste0("./data/", table_name, ".rds", sep = "")
  
  last_db_modified_time <- file.mtime(filepath_db)
  if (file.exists(filepath_rds))
  {
    last_rds_saved_time <- file.mtime(filepath_rds)
  } else {
    last_rds_saved_time <- fastPOSIXct('1970-01-01')
  }
  
  # In case sales db (xlsx) was modified after the last version was saved
  # Or there is no RDS file
  if (last_db_modified_time > last_rds_saved_time)
  {
    # Read sales data
    music_map <- read.csv(file = filepath_db)
    table <- as.data.table(music_map)
    saveRDS(table, file = filepath_rds)
    
  } else {
    table <- readRDS(filepath_rds)
  }
  table
}


get_content_data <- function() {
  
  table_name <- 'text_content_data'
  filepath_db <- paste0('./data/', table_name, ".csv")
  filepath_rds <- paste0("./data/", table_name, ".rds", sep = "")
  
  last_db_modified_time <- file.mtime(filepath_db)
  if (file.exists(filepath_rds))
  {
    last_rds_saved_time <- file.mtime(filepath_rds)
  } else {
    last_rds_saved_time <- fastPOSIXct('1970-01-01')
  }
  
  # In case sales db (xlsx) was modified after the last version was saved
  # Or there is no RDS file
  if (last_db_modified_time > last_rds_saved_time)
  {
    # Read sales data
    content_text <- read.csv(file = filepath_db)
    table <- as.data.table(content_text)
    saveRDS(table, file = filepath_rds)
    
  } else {
    table <- readRDS(filepath_rds)
  }
  table
}