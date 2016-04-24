#prediction page

#db <- dbConnect(SQLite(), dbname="Data/AllGrams")
words.dict <- readRDS("wordsdict.rds")

nextWord <- function(sentence,db )
{
       
        sentence <- tolower(sentence) %>%
                removePunctuation %>%
                removeNumbers %>%
                stripWhitespace %>%
                str_trim %>%
                strsplit(split=" ") %>%
                unlist
        wr <- c("")
        w <- 0
        #  for(i in  length(sentence):max(1,length(sentence) -3))
        words <- sentence[max(1,length(sentence) -2):length(sentence)]  
        num <- 1:length(words)
        for(i in 1:length(words))
        {      n <- words.dict[which(words.dict[,2] == words[i]),1]
               if (length(n) == 0)
                       num[i] <- 0
               if (length(n) != 0)
                       num[i] <- n
        }
        num[is.na(num)] <- 1 
        num <- num[length(num):1]  
        
        # for (i in min(length(sentence), max):1) 
        w <- 0
        if(length(num) >= 3)
        { sql <- paste0("SELECT word4, prob   FROM quadgrams WHERE   word1="  , num[3], " and word2= ", num[2] , " and word3 =",num[1])
          result <- dbSendQuery(conn=db, sql)
          predicted <- dbFetch(result, n=-1)
           if (nrow(predicted) > 0)
          { predicted <- arrange(predicted,desc(prob))
             
            for (i in 1:min(3,nrow(predicted)))
                    wr[i] <- as.character(words.dict[which(words.dict[,1] == predicted[i,1]),2])        
                w <- length(wr)
           if (w == 3) return(wr)}
        }                 
        if(length(words) >= 2)
        { sql <- paste0("SELECT word3  ,prob  FROM trigrams WHERE   word1="  , num[2], " and word2= ", num[1]  )
          result <- dbSendQuery(conn=db, sql)
          predicted <- dbFetch(result, n=-1)
          dbClearResult(result)
          if (nrow(predicted) > 0)
          { predicted <- arrange(predicted,desc(prob))
            
            for (i in w:min(3,nrow(predicted)))
                    wr[i] <- as.character(words.dict[which(words.dict[,1] == predicted[i,1]),2])        
          w = w + length(wr)
            if (w>=3) return(wr)}
        }  
        if(length(words) >= 1)
        { sql <- paste0("SELECT word2, prob  FROM bigrams WHERE   word1="  , num[1])
          result <- dbSendQuery(conn=db, sql)
          predicted <- dbFetch(result, n=-1)
          dbClearResult(result)
          if (nrow(predicted) > 0)
          { predicted <- arrange(predicted,desc(prob))
          
            for (i in 1:min(3,nrow(predicted)))
                    wr[i] <- as.character(words.dict[which(words.dict[,1] == predicted[i,1]),2])        
            w = w + length(wr)
            if (w>=3)  return(wr)}
        }  
        
        if(length(words) >= 0)
        { sql <- paste0("SELECT V2, [uni.prob]  FROM unigrams order by [uni.prob] desc ")
          result <- dbSendQuery(conn=db, sql)
          predicted <- dbFetch(result, n=-1)
          
          if (nrow(predicted) > 0)
          {predicted <- arrange(predicted,desc(predicted[,2])) 
            
           for (i in 1:3)
           wr[i] <- as.character(words.dict[which(words.dict[,1] == predicted[i,1]),2]) 
           
          if (length(sentence) == 0)
                  {for(i in 1:3)
             {  wr[i] <-  paste(toupper(substr(wr[i], 1, 1)), substr(wr[i], 2, nchar(wr[i])), sep="")
                  }}
           return(wr)}
        }  
}


wordCloud <- function(gram,n,db)
{
        if(gram == "")
                return("Nothing to show")
        #process into a number
        gram <- word(gram,-1)
        gram <- tolower(gram) %>%   removePunctuation %>% removeNumbers %>%    stripWhitespace %>%
                str_trim %>%      strsplit(split=" ") %>%        unlist
         
         
        num <- words.dict[which(words.dict[,2] == gram),1]
        if(is.integer(num) && length(num) ==0)
                num[1] <- 0
        #look it up SQL
        sql <- paste0("SELECT word2, prob  FROM bigrams WHERE   word1="  , num[1] )
        result <- dbSendQuery(conn=db, sql)
        words <- dbFetch(result, n=-1)
        #store it with probabilities in dataframe and convert back to words
      if(nrow(words) >0){
        for (i in 1:nrow(words))
                words[i,1] <- as.character(words.dict[which(words.dict[,1] == words[i,1]),2])
        
      wc <-    wordcloud(words = words[,1], freq = words[,2], min.freq = 1,scale=c(5,0.5),
                  max.words=n, random.order=FALSE, rot.per=0.25, 
                  colors=brewer.pal(9, "Set1"))
        return(wc)
}
}






