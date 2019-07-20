library("dplyr")
library("ggplot2")


## input file

data = read.csv("data/df_merge.csv", header=T, row.names = 1, stringsAsFactors = FALSE)

data['rb_size'] <- nchar(data$cutseq)


index_seq_count <- data %>%
  select(cutseq, F_Index, R_Index, ClusterID, rb_size) %>%
  group_by(F_Index,R_Index,cutseq,rb_size) %>%
  count()
write.csv(index_seq_count,"output/index_seq_count.csv")



index_seq_count50 <- data %>%
  select(cutseq, F_Index, R_Index, ClusterID, rb_size) %>%
  group_by(F_Index,R_Index,cutseq,rb_size) %>%
  count() %>%
  filter(n>=50)

write.csv(index_seq_count50,"output/index_seq_count50.csv")




