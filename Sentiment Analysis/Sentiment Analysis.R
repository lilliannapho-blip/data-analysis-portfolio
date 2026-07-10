

install.packages(c("wordcloud", "RColorBrewer", "tm", "dplyr"))
install.packages("SnowballC") 


install.packages(c(
"tidytext",
"syuzhet",
"sentimentr"
))


library(tidytext)
library(syuzhet)
library(sentimentr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

textdata <- readLines("https://www.r-bloggers.com/wp-content/uploads/2016/01/vent.txt")
textdata <- textdata[textdata != ""]


clean_text <- textdata %>%
  str_replace_all("[[:punct:]]", " ") %>%
  str_replace_all("[[:digit:]]", " ") %>%
  str_replace_all("http\\S+", " ") %>%
  str_replace_all("\\s+", " ") %>%
  trimws() %>%
  tolower()



nrc_df <- syuzhet::get_nrc_sentiment(clean_text)
emotion <- nrc_df %>%
  select(anger:trust) %>%
  mutate(max_emotion = colnames(.)[max.col(.)]) %>%
  pull(max_emotion)
emotion[apply(nrc_df[,1:8], 1, sum) == 0] <- "unknown"


pol_df <- sentiment(clean_text)
polarity <- ifelse(
  pol_df$sentiment > 0, "positive",
  ifelse(pol_df$sentiment < 0, "negative", "neutral")
)


sent_df <- tibble(
text = clean_text,
emotion = emotion,
polarity = polarity
)
sent_df$emotion <- factor(
  sent_df$emotion,
  levels = names(sort(table(sent_df$emotion), decreasing = TRUE))
)


ggplot(sent_df, aes(x = emotion, fill = emotion)) +
  geom_bar() +
  scale_fill_brewer(palette = "Dark2") +
  theme_minimal()

#This bar chart shows us that trust and anticipation are the most common emotion that show up
#in the text the most. While the other emotions show up at around the same rate as eachother
#we can use this to focus more on the trust aspect


ggplot(sent_df, aes(x = polarity, fill = polarity)) +
  geom_bar() +
  scale_fill_brewer(palette = "RdGy") +
  theme_minimal()

#We are seeing a lot more negative polarity with the text 
#This tells us that whatever we are trying to sell has more of a negative sentiment than a positive
#even though it's almost 50/50, we can see that the negative text has overcome the positive

emos <- unique(sent_df$emotion)
emo_docs <- map_chr(emos, ~ paste(sent_df$text[sent_df$emotion == .x], collapse = " "))
emo_docs_clean <- removeWords(emo_docs, stopwords("english"))
corpus <- Corpus(VectorSource(emo_docs_clean))
tdm <- TermDocumentMatrix(corpus)
tdm <- as.matrix(tdm)
comparison.cloud(
  tdm,
  colors = brewer.pal(length(emos), "Dark2"),
  scale = c(3, 0.6),
  random.order = FALSE,
  title.size = 1.5
)
  
#with this word cloud, we can see the most common text is the word "liar" and "west virginia"
#there are other common words like "news" as well. this tells us what words are being typed out the most
#we can use this make inferences as to what the text is talking about the most



