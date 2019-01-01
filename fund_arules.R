## 공개 포트폴리오 연관성 분석

# 공개 포트폴리오 데이터 : https://github.com/jhgil92/fund/blob/master/%EA%B3%B5%EA%B0%9C%20%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4.ipynb
# 펀드 정보 데이터 : https://github.com/jhgil92/fund_info_crawling/blob/master/fund_info_crawling_v2.R

# setwd(".//r//arules")

# data load
port <- read.csv("./input/portfolio.csv", row.names =NULL)
fund_info <- read.csv("./input/fund_info.csv", row.names = NULL)
port %>% head
fund_info %>% head

# library load
library(arules)
library(dplyr)
library(stringr)

# data preprocessing
port %>%
  select(c(-1,-7)) -> port

tr_list <- list()
length(tr_list) <- nrow(port)
for(i in 1:length(tr_list)){
  port[i,] %>%
    t %>%
    as.vector %>%
    lapply(function(x){return(x[!is.na(x)])}) %>%
    unlist -> tr_list[[i]]
  cat("\n", i)
}

tr <- as(tr_list, 'transactions')
summary(tr)
inspect(tr[1:5])

# itemInfo에 type 칼럼을 추가
tr@itemInfo %>%
  t %>%
  as.vector -> fund_name

return_type <- function(i){
  if(fund_name[i] %in% fund_info$FP_KRN_NAME){
    ind <- which(fund_info$FP_KRN_NAME==fund_name[i])
    return(fund_info$TYPE_NAME[ind] %>% as.character)
  }else{
    return("NOT SET")
  }
}
lapply(1:length(fund_name), return_type) %>%
  unlist -> level2
tr@itemInfo <- cbind(tr@itemInfo,level2)

return_type_2 <- function(i){
  if(fund_name[i] %in% fund_info$FP_KRN_NAME){
    ind <- which(fund_info$FP_KRN_NAME==fund_name[i])
    return(fund_info$LRG_TYPE_NAME[ind] %>% as.character)
  }else{
    return("NOT SET")
  }
}
lapply(1:length(fund_name), return_type_2) %>%
  unlist -> level3
tr@itemInfo <- cbind(tr@itemInfo,level3)

# itemInfo의 depth를 활용하여 transaction data를 추가
tr2 <- aggregate(tr, 'level2')
tr3 <- aggregate(tr, 'level3')

## apriori 알고리즘으로 연관성 분석 시행
# apriori(data, parameter=list(support=0.1, confidence=0.8, minlen=1, maxlen=10, smax=1))
# support=최소지지도, confidence=최소신뢰도, minlen=최소물품수(lhs+rhs), maxlen=최대물품수(lhs+rhs), smax=최대지지도
# 위의 숫자들은 default값, parameter를 따로 지정안하면 default값을 기준으로 계산함

tr %>%
  apriori(parameter = list(support=0.05)) %>%
  sort(by='lift') %>%
  inspect

tr2 %>%
  apriori(parameter = list(support=0.05)) %>%
  sort(by='lift') %>%
  inspect

tr3 %>%
  apriori(parameter = list(support=0.001, confidence=0.3)) %>%
  sort(by='lift') %>%
  inspect
