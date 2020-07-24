# 본문서는 개인적으로 사용하는 alias / shellScript 를 기록하고자 한다

mac, git 관련 작업이 주를 이루며  
회사 내부에서 사용하는 환경을 보조하고자 만들기 시작했다  

bash_profile 에 삽입하여 필요한것만 사용하면 된다  
alias 에는 function 을 이용하는것들도 있다



## allpr
>apppr  


저장소 1개에 여러 서비스를 관리하는 환경에서 사용  
release -> 작업 branch -> 서비스별-qa  로 작업할때  
작업 bracnch -> 서비스-dev, 서비스-qa  로 PR 을 생성해야함  

## reload
> re


bash_profile 수정후 바로 터미널에서 리로드 할때 사용.  
alias 로 re 로 등록함


## combo
> combo "커밋메세지"  


git 의 pull, add, commit, push 를 동시에 진행함  
해당 마크업 환경에서는 문제 없이 사용가능

## combo2
> combo2 "커밋메세지"  

combo + 와 동일하며  
추가로 해당 브랜치의 지라를 크롬으로 열고  
추가로 크롬 브라우저로 bitbuket으로 이동. pull request 까지 생성할수 있게 세팅 해줌  

## ck
>ck 숫자  

git pull, checkout 을 간소화

## ckm
>ckm 숫자  

pull, 그리고 원격 저장소에 지금  

## fe_copy
저장소에서 작업하면 로컬에만 산출물이 생성되며  
저장소에는 push 하지 않고 sass 와 include 되기 전 상태로만 업로든 됨  
이를 디자이너, 기획자에게 보여주기 위해 외부 저장소에 산출물 css 와 include 된 이후의 파일을  
다른 저장소 폴더에 물리적으로 복사함  


