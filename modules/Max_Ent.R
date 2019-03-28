#This module calculates the maximum entropy of each genomic region.

#Obtaining the files.
files <- list.files(pattern=".csv")

selected_entropy<- numeric(0)
all_max_entropy_result <- c()
y <- 1

#Reading files using loop.
for (f in files) {
  table <- read.csv(f, header=T, sep="\t", row.name=1)
  #Converting table in matrix
  adj_matrix <- as.matrix(table)
  
  #Summing the values for each string
  sum.each.string_value <- apply(X=adj_matrix, MARGIN=1, FUN=sum)
  i <- 1  
  j <- 1
  table_row <- nrow(table)
  
  max_entropy<- numeric(0)  
  #Sliding in table
    while(i < table_row){
     
    sum.total.h1 <- sum(sum.each.string_value[1:j])
    freq.rel.h1 <- sum.each.string_value[1:j] / sum.total.h1
     
    #Applying log2 to each relative frequency.
    log.h1 <- log2(freq.rel.h1)
    
    #Multiplying the relative frequency of each value by their respective log results.
    h1 <- freq.rel.h1 * log.h1 
    
    #Where exists "NaN" in the vector, changes by "0".
    index <- which(is.nan(h1))
    h1[index]=0
  
    #Making results in positive values.
    h1.positive <- h1 * (- 1)
  
    h1_result <- sum(h1.positive)
    
    x <- j+1
    
    sum.total.h2 <- sum(sum.each.string_value[x:table_row])
    freq.rel.h2 <- sum.each.string_value[x:table_row] / sum.total.h2 
    
    #Applying log2 to each relative frequency.
    log.h2 <- log2(freq.rel.h2)
    
    #Multiplying the relative frequency of each value by their respective log results.
    h2 <- freq.rel.h2 * log.h2    
    
    #Where exists "NaN" in the vector, changes by "0".
    index <- which(is.nan(h2))
    h2[index]=0
    
    #Making results in positive values.
    h2.positive <- h2 * (- 1)
  
    h2_result <- sum(h2.positive)
    
    #Obtaining the maximum entropy 
    h_max <- h1_result + h2_result
       
    select_entropy <- max(max_entropy)
    max_entropy[j] <- h_max
            
    i <- i + 1
    j <- j + 1
    
  }
  selected_entropy[y] <- max(max_entropy)
  all_max_entropy_result <-rbind(all_max_entropy_result, max_entropy)
 
  y <- y+1
  
 }

#Storing the results in a data.frame.
selected_max_entropy_result<-data.frame(cbind(files, selected_entropy)) 

max_entropy_result<-data.frame(cbind(files, all_max_entropy_result)) 

#Creating a file to final max entropy result.
write.table(selected_max_entropy_result, file= "MaxEnt_result.txt", sep="\t")


