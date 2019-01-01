# fund_arules

펀드슈퍼마켓의 공개 포트폴리오 데이터를 활용하여 펀드간 연관성 분석을 시행하는 코드입니다.

해당 코드에 활용되는 데이터는 아래와 같은 방법을 통해 수집하였습니다. (펀드슈퍼마켓 사이트 크롤링)
공개 포트폴리오 데이터 : https://github.com/jhgil92/fund/blob/master/%EA%B3%B5%EA%B0%9C%20%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4.ipynb
펀드 정보 데이터 : https://github.com/jhgil92/fund_info_crawling/blob/master/fund_info_crawling_v2.R

개별의 포트폴리오를 하나의 transaction으로 보고 이 데이터를 통해 포트폴리오 사이에 있는 규칙을 살펴봅니다.