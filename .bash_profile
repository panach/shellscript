# zsh/bash 토글
# exec bash
#  위 사용 후 source ~/.bash_profile 해줘야 불러옴
# exec zsh

eval "$(rbenv init -)"

# Git branch in prompt.

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
# export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\h:\[\e[31;1m\]\w:> \[\e[0m\]"


export PS1=" \u${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
#export PS1="${debian_chroot:+($debian_chroot)}   \[\033[01;34m\]   \w\[\033[00m\]\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "


#  color
RED="\033[0;31m"
GREEN="\033[0;32m"
BROWN="\033[0;33m"
BLUE="\033[0;34m"
MARGENT="\033[0;35m"
CYAN="\033[0;36m"
ENDCOLOR="\033[0m"

function color () {
  echo -e "${RED}RED${ENDCOLOR} "
  echo -e "${GREEN}GREEN${ENDCOLOR} "
  echo -e "${BROWN}BROWN${ENDCOLOR} "
  echo -e "${BLUE}BLUE${ENDCOLOR} "
  echo -e "${MARGENT}MARGENT${ENDCOLOR} "
  echo -e "${CYAN}CYAN${ENDCOLOR} "
}


# bash_profile 리로드
function reload () {
  # clear
  source ~/.bash_profile
  echo -e "${RED}bash_profile Reloaded!!!${ENDCOLOR}"
}

# git - pull add commit push 순차
# combo "문구"
function combo () {
  git pull
  git pull origin $(git rev-parse --abbrev-ref HEAD)
  git add .
  git commit -m "[$(git rev-parse --abbrev-ref HEAD | cut -c 9-)] $1"
  git push origin $(git rev-parse --abbrev-ref HEAD)
}


# git - pull add commit push , release 로 PR 생성
# combo "문구"
function combo2 () {
  # 브런치 변수에 저장
  branch_name=$(git rev-parse --abbrev-ref HEAD)
  # 현제 폴더 경로 변수에 저장
  local_path=$(pwd)
  # 열어야 하는 bitbucket 경로, 빈 변수로 일단
  open_path=''

  # git  pull, add, commit, push 과정
  git pull
  git pull origin $branch_name
  git add .
  git commit -m "[$(git rev-parse --abbrev-ref HEAD | cut -c 9-)] $1"
  git push origin $branch_name

  # 저장소가 어딘지 현제 폴더 경로에서 텍스트 검색하여 웹 경로 재료 구성
  # 지금 버전은 fe, service_tmon_benefit_ui 버전만 가능
  if [[ $local_path =~ '/fe/' ]];then
    # fe 저장소
    open_path="fe"
  elif [[ $local_path =~ '/service_tmon_benefit_ui/' ]];then
    # service_tmon_benefit_ui 저장소
    open_path="service_tmon_benefit_ui"
  fi

  # 지라 문서 오픈
  # j $(git rev-parse --abbrev-ref HEAD | cut -c 15-)ㅁ

  # 위 if 에서 저장소 경로 확인. 브런치 변수에서 생성할 PR 브런치가 대상 브런치(release) 설정
  # PR 생성 전까지만 진행하여 웹으로 띄워줌
  /usr/bin/open -a "/Applications/Google Chrome.app" "https://bitbucket.tmon.co.kr/bitbucket/projects/SDUUI/repos/$open_path/pull-requests?create&targetBranch=refs/heads/release&sourceBranch=refs/heads/$branch_name"

}

# git - pull 체크아웃
# ck feature/SDUFM-00
function ck () {
  echo $1
  git pull
  git checkout $1
}

# git - pull 체크아웃
# ckm 00
function ckm () {
  # git pull origin release
  git pull
  echo "git - pull 진행"
  branch_number=$(git branch --all | grep feature/SDUFM-$1)
  branch_type="feature"

  # 조합 type + num
  if [ -n "$branch_number" ]; then
    echo "$branch_number 존재함 - checkout 진행"
    git checkout feature/SDUFM-$1
  else
    echo "$branch_number 없음 - branch 생성 및 checkout"
    git checkout -b feature/SDUFM-$1
  fi
}

function c_vo () {
  echo $1
  say -v Yuna $1
}

# cp_fb
function fe_copy () {

  # 브런치명이거나 입력 받거나
  test_name=$(git rev-parse --abbrev-ref HEAD | cut -c 15-)

  if [ -n "$test_name" ]; then
    echo "true - 비어있지 않음 ($test_name)"
  else
    echo "false - 비어 있음"
    echo "브런치 번호를 입력하세요 "
    read test_name
    echo -e "입력하신 번호는 $test_name -> 확인 및 복사 진행합니다."
  fi

  git -C Documents/git/fe_build/panach pull
  mkdir -p -v /Users/panach/Documents/git/fe_build/panach/$test_name/

  if [ -d /Users/panach/Documents/git/fe/tmon/dist/m ];then
    echo "mw 있음 -> 폴더 생성 및 복사 진행"
    cp -r /Users/panach/Documents/git/fe/tmon/dist/m/ /Users/panach/Documents/git/fe_build/panach/$test_name/m/
  fi
  if [ -d /Users/panach/Documents/git/fe/tmon/dist/pc ];then
    echo "pc 있음 -> 폴더 생성 및 복사 진행"
    cp -r /Users/panach/Documents/git/fe/tmon/dist/pc/ /Users/panach/Documents/git/fe_build/panach/$test_name/pc/
  fi
  /usr/bin/open -a "/Applications/Google Chrome.app" "http://sun.tmonc.net/view/994.FE/job/FE_BUILD/ws/panach/"
}

function dcp () {
  echo "test" | grep -c cc
}


# daily 저장소 pull / 이름 기준으로 영역을 echo / 클립보드에 복사
# 사용하실때 내이름, 다음 이름,  local- git - daily 주소를 수정하고 사용할것
function dl () {
  # cd ~
  myName="김영득" # 내이름
  nextName="김영술" # daily 다음 사람 이름
  dailyDirectory="/Users/panach/Documents/git/daily" # 데일리 git 절대경로

  git -C $dailyDirectory pull
  # 1초 딜레이
  sleep 1

  # 오늘 요일 받아오기
  toDay=$(date '+%A')

  # 비교할 요일 지정
  tarDay="월요일"

  # 오늘이 월요일이면 지난주 금요일, 그외 요일은 어제 일자를 받기 위한 변수
  time=""

  # 오늘 요일과 지정한 요일(월요일)을 비교
  if [ "$toDay" == "$tarDay" ];then
    # 오늘 = 월요일 이면 63 을 변수에 담음 이는 리눅스 일자 계산 함수로 15를 어제일로 계산 하루 추가시 24를 더해야함
    # 3일을 뒤로 가려면 15 어제 + 1일 24 + 1일 24 = 63
    time=63
    echo "오늘과 지난주 금요일 데일리 열기."
    else
    # 그외 요일은 15로 어제로 돌리면 됨
    time=15
    echo "오늘과 어제 데일리 열기"
  fi

    # 위에서 검색 날짜의 파일에서 내 이름과 내 다음 사람의 이름을 검색
    first_line=$(grep -n $myName "$dailyDirectory/UI개발유닛과코어UI개발지원유닛/$(TZ=KST+$time date +%Y%m)/$(TZ=KST+$time date +%Y%m%d).md" | cut -f1 -d:)
    second_line=$(grep -n $nextName "$dailyDirectory/UI개발유닛과코어UI개발지원유닛/$(TZ=KST+$time date +%Y%m)/$(TZ=KST+$time date +%Y%m%d).md" | cut -f1 -d:)
    # 오늘날짜의 문서에서 내이름의 라인수를 찾음. 오늘문서를 열때 라인을 정해서 열때 사용
    third_line=$(grep -n $myName "$dailyDirectory/UI개발유닛과코어UI개발지원유닛/$(TZ=KST date +%Y%m)/$(TZ=KST date +%Y%m%d).md" | cut -f1 -d:)

    n1=$(($first_line - 2)) ## 검색한 이름의 2줄 위의 라인수를 찾음 (본인)
    n2=$(($second_line - 2)) ## 검색한 이름의 2줄 위의 라인수를 찾음 (다음 사람)

    echo ""
    echo "#############################"
    echo "#"
    echo "# 오늘 : $toDay"
    echo "# 지난 : $(TZ=KST+$time date +%Y%m%d)"
    echo "#"
    echo "# 검색 결과 라인수 $n1 ~ $n2"
    echo "#"
    echo "#############################"
    echo ""

    # 검색된 라인수부터 출력 & pdcopy 클립보드에 복사
    sed -n "$n1, $(($n2))p" "$dailyDirectory/UI개발유닛과코어UI개발지원유닛/$(TZ=KST+$time date +%Y%m)/$(TZ=KST+$time date +%Y%m%d).md"
    sed -n "$n1, $(($n2))p" "$dailyDirectory/UI개발유닛과코어UI개발지원유닛/$(TZ=KST+$time date +%Y%m)/$(TZ=KST+$time date +%Y%m%d).md" | pbcopy

  # 오늘 일자로 데일리 열기
  /usr/bin/open -a "/Applications/Google Chrome.app" "https://bitbucket.tmon.co.kr/bitbucket/projects/FRT/repos/daily/browse/UI%EA%B0%9C%EB%B0%9C%EC%9C%A0%EB%8B%9B%EA%B3%BC%EC%BD%94%EC%96%B4UI%EA%B0%9C%EB%B0%9C%EC%A7%80%EC%9B%90%EC%9C%A0%EB%8B%9B/$(date '+%Y%m')/$(date '+%Y%m%d').md?useDefaultHandler=true#$third_line"
  code
}


# 데일리 오픈
function dl2 () {

  # 오늘 일자로 데일리 열기
  /usr/bin/open -a "/Applications/Google Chrome.app" "https://bitbucket.tmon.co.kr/bitbucket/projects/FRT/repos/daily/browse/UI%EA%B0%9C%EB%B0%9C%EC%9C%A0%EB%8B%9B%EA%B3%BC%EC%BD%94%EC%96%B4UI%EA%B0%9C%EB%B0%9C%EC%A7%80%EC%9B%90%EC%9C%A0%EB%8B%9B/$(date '+%Y%m')/$(date '+%Y%m%d').md?useDefaultHandler=true"

  # 월요일이면 확인하여 지난주 금요일 데일리 열기

  # 오늘 요일 받아오기
  toDay=$(date '+%A')

  # 비교할 요일 지정
  tarDay="월요일"

  # 오늘이 월요일이면 지난주 금요일, 그외 요일은 어제 일자를 받기 위한 변수
  time=""

  # 오늘 요일과 지정한 요일(월요일)을 비교
  if [ "$toDay" == "$tarDay" ];then
    # 오늘 = 월요일 이면 63 을 변수에 담음 이는 리눅스 일자 계산 함수로 15를 어제일로 계산 하루 추가시 24를 더해야함
    # 3일을 뒤로 가려면 15 어제 + 1일 24 + 1일 24 = 63
    time=63
    echo "오늘과 지난주 금요일 데일리 열기."
    else
    # 그외 요일은 15로 어제로 돌리면 됨
    time=15
    echo "오늘과 어제 데일리 열기"
  fi
    # time 변수에 지정한 일로 데일리 열기
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://bitbucket.tmon.co.kr/bitbucket/projects/FRT/repos/daily/browse/UI%EA%B0%9C%EB%B0%9C%EC%9C%A0%EB%8B%9B%EA%B3%BC%EC%BD%94%EC%96%B4UI%EA%B0%9C%EB%B0%9C%EC%A7%80%EC%9B%90%EC%9C%A0%EB%8B%9B/$(TZ=KST+$time date +%Y%m)/$(TZ=KST+$time date +%Y%m%d).md?useDefaultHandler=true"
    echo "김영득" | pbcopy
}


# bitbucket pr 열기
function pr () {

  echo "${GREEN}저장소를 선택해주세요.${ENDCOLOR}"
  PS3="Enter a number: "
  select character in fe benefit spc
  do
      echo "Selected character: $character"
      # echo "Selected number: $REPLY"
      case $character in

        fe)
          ccc
          echo -e "${CYAN}fe${ENDCOLOR}"
        ;;
        benefit)
          echo -e "${CYAN}benefit${ENDCOLOR}"
        ;;
        spc)
          echo -e "${CYAN}spc${ENDCOLOR}"
        ;;
      esac
      break
  done

  echo "대상 브런치를 선택해주세요: $branch"
  select branch in home deallist
  do
      # echo "Selected number: $REPLY"
    echo "Selected character: $branch"
      break
  done



# fe > plan-qa
# https://bitbucket.tmon.co.kr/bitbucket/projects/SDUUI/repos/fe/pull-requests?create&targetBranch=refs%2Fheads%2Fplan-qa&sourceBranch=refs%2Fheads%2Ffeature%2FSDUFM-1240

# benefit > dev
# https://bitbucket.tmon.co.kr/bitbucket/projects/SDUUI/repos/service_tmon_benefit_ui/pull-requests?create&targetBranch=refs%2Fheads%2Fdev&sourceBranch=refs%2Fheads%2Ffeature%2FSDLUI-2457





  # ----------------------------
  #제작하면서 참고한 것들
  # ----------------------------

  # echo -e "한 단어를 입력하세요: c "
  # read  word
  # echo "입력한 단어는: $word"


  # echo -e "\n\033[4;31mLight Colors\033[0m  \t\t\033[1;4;31mDark Colors\033[0m"
  # echo -e "\e[0;30;47m Black    \e[0m 0;30m \t\e[1;30;40m Dark Gray  \e[0m 1;30m"
  # echo -e "\e[0;31;47m Red      \e[0m 0;31m \t\e[1;31;40m Dark Red   \e[0m 1;31m"
  # echo -e "\e[0;32;47m Green    \e[0m 0;32m \t\e[1;32;40m Dark Green \e[0m 1;32m"
  # echo -e "\e[0;33;47m Brown    \e[0m 0;33m \t\e[1;33;40m Yellow     \e[0m 1;33m"
  # echo -e "\e[0;34;47m Blue     \e[0m 0;34m \t\e[1;34;40m Dark Blue  \e[0m 1;34m"
  # echo -e "\e[0;35;47m Magenta  \e[0m 0;35m \t\e[1;35;40m DarkMagenta\e[0m 1;35m"
  # echo -e "\e[0;36;47m Cyan     \e[0m 0;36m \t\e[1;36;40m Dark Cyan  \e[0m 1;36m"
  # echo -e "\e[0;37;47m LightGray\e[0m 0;37m \t\e[1;37;40m White      \e[0m 1;37m"
  # https://bash.cyberciti.biz/guide/Exit_select_loop


} #pr 종료


# 윈도우에서 ip를 git으로 저장
function win_iptest () {
  # ip 획득
  text=$(ipconfig getifaddr en0)
  # 오늘 시간
  timestamp_day=$(date '+%Y%m%d')"_"$(date '+%H%M')
  # 업로드할 git 경로
  file_location="/Users/panach/Documents/git/markup_mis/panach/"
  # pc_page 파일 초기화 후 오늘시간 + ip 를 남김
  echo "$timestamp_day : $text" > $file_location'pc_page'
  # 테스트 코드임 : 터미널에 pc_page 의 마지막 라인을 출력함
  tail -n 1 $file_location'pc_page'

  # git 으로 남김
  # git -C "$(file_location)" pull
  # git -C "$(file_location)" add .
  # git -C "$(file_location)" commit -m "add : $timestamp_day"
  # git -C "$(file_location)" push origin master

  echo "업로드 완료"
  # 본코드 작업에는 에러코드에 대한 방어가 없다 차후 스킬업하고 추가한다
  # mac bash 에는 참고차 넣어만 두도록 하자. windows 에서만 사용하는 코드라고 보면된다
  # 차후 추가.
    # 계정 변경시 대응
    # git 업로드시 에러 대응

 # Tnldlqjf. 이 코드는 일단 쓸수 없다. 회사에서 지급받은 pc 에서 ....리눅스 설치 불가다
}

# mac 에서 저장된 문서 가져옴
function aaa () {
  git -C "/Users/panach/Documents/git/markup_mis/panach/" pull
  sleep 2
  echo "git pull / 2초 딜레이 ========"
  tail -n 1 $file_location'pc_page'
}





# 전체서비스 PR 생성
function allpr () {

  # branch_list=("home" "atstore" "order" "checkout" "benefit" "paymentbenefit" "cs" "deallist" "mart" "deals_v3" "mall" "point" "tour" "search" "member" "interest" "plan" "schedule" "seller" "shared" "keyword" "tips" "auth" "delivery_my" "review" "category" "mediaprofile" "media" "delivery" "outlet" "store")

  # footer_pr 목록
  branch_list=("home" "tips" "atstore" "benefit" "paymentbenefit" "checkout" "order" "deallist" "mart" "mall" "seller" "plan" "point" "tour" "tour_home" "search" "member" "deals_v3" "keyword" "interest" "cs" "schedule" "shared" "supermart")

  # 터미널 경로에 브런치명을 불러올것이 있다면 변수에 저장
  branch_name=$(git rev-parse --abbrev-ref HEAD)

  # 터미널 경로상 브런치가 없다면 입력 받도록 함
  if [ -n "$branch_name" ]; then
    echo "$branch_name 대상으로 전체서비스 PR 생성합니다."
  else
    echo "브런치 번호를 입력하세요 형식 : feature/SDUFM-00"
    read branch_name
    echo -e "입력하신 브런치는 $branch_name -> 대상으로 전체서비스 PR 생성합니다."
  fi

  for (( i = 0 ; i < ${#branch_list[@]} ; i++ )) ; do
      /usr/bin/open -a "/Applications/Google Chrome.app" "https://bitbucket.tmon.co.kr/bitbucket/projects/SDUUI/repos/fe/pull-requests?create&targetBranch=refs/heads/${branch_list[$i]}-qa&sourceBranch=refs/heads/$branch_name"
      echo "${branch_list[$i]}-qa : "
  done
  # release 마지막에 추가
  # /usr/bin/open -a "/Applications/Google Chrome.app" "https://bitbucket.tmon.co.kr/bitbucket/projects/SDUUI/repos/fe/pull-requests?create&targetBranch=refs/heads/release&sourceBranch=refs/heads/$branch_name"

}

# j - 최신 모든 지라 순으로 보기
# j [NUM] - 해당 지라 번호로 문서 열기
function j () {
  if [ -n "$1" ]; then
    echo "SDUFM-$1 지라 열기"
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUFM/issues/SDUFM-$1?filter=allissues"
  else
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUFM/?filter=allissues"
    echo "최신 지라 열기"
  fi
}
function b () {
  if [ -n "$1" ]; then
    echo "SDUMU-$1 지라 열기"
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUMU/issues/SDUMU-$1?filter=allissues"
  else
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUMU/?filter=allissues"
    echo "최신 지라 열기"
  fi
}
# 지금 터미널 브런치 기준의 지라 열기
# 좀더 심플한 방법이 없을까? 아니면 위 function j 와 합칠수 있는 사용법은?
function jj () {
    branchNumber=$(git rev-parse --abbrev-ref HEAD | cut -c 15-)
    echo ${branchNumber}
    if [ -z ${branchNumber} ]; then
      echo "최신 지라 열기"
      /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUFM/?filter=allissues"
    else
      echo "$branchNumber 지라 열기"
      /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUFM/issues/SDUFM-${branchNumber}?filter=allissues"
    fi
}


# 아이피 클립보드 복사
function ip () {
  # 아이피
  ipconfig getifaddr en0

  #클립보드에 복사
  ipconfig getifaddr en0 | pbcopy
}

# 타임스템프 클립보드 복사
function tm () {
  timestamp_day=$(date '+%Y%m%d')"_"$(date '+%H%M')
  echo "$timestamp_day" | pbcopy
  echo "$timestamp_day"
}

# diff2html 커밋
function diff () {
  if [ -n "$1" ]; then
    diff2html -s side -- -M HEAD~$1
  else
    diff2html -s side -- -M HEAD~1
  fi
}

# 특정 브런치 삭제 후 바로 신규로 생성
# branch_delte feature/SDUFM-00
function branch_delete () {
  git checkout release
  git fetch origin
  git pull
  git branch -d $1
  git push --delete origin $1
  git branch $1
  git push origin $1
  git checkout $1
}


# bash_profile git push
function bash_git () {
    git -C "/Users/panach/Documents/git/shellscript" pull
    git -C "/Users/panach/Documents/git/shellscript" add .
    git -C "/Users/panach/Documents/git/shellscript" commit -m $1
    git -C "/Users/panach/Documents/git/shellscript" push origin master
}


## 터미널
alias re='reload'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias desk='cd ~/Desktop'
alias cl='clear'
alias c='clear'
alias op='open .'
alias v='code .'
alias f='open -a Finder ./'
alias ~='cd ~'


## 경로 이동
alias gog='~;cd Documents/git'
alias godw='~;cd Downloads'
alias gofe='~;cd Documents/git/fe/tmon'
alias gosun='~;cd Documents/git/fe_build/panach'
alias goco='~;cd Documents/git/fe/tmon_recruit/pc'
alias gobe='~;cd Documents/git/service_tmon_benefit_ui/src/main/webapp/'
alias godm='~;cd Documents/git/markup_dm'
alias godl='~;cd Documents/git/daily'
alias gospc='~;cd Documents/git/fe_spc/tmon/pc'
alias goold='~;cd Documents/git/fe_old/'
alias gomis='~;cd Documents/git/markup_mis/panach'



## 파일 관련
# png 60-80 파일명.png
alias png='pngquant --ext _new.png --speed 1 --quality'


## 브라우저
alias cat_bash='cat ~/.bash_profile'
alias vsbash='code ~/.bash_profile'
alias sun='/usr/bin/open -a "/Applications/Google Chrome.app" "http://sun.tmonc.net/view/994.FE/job/FE_BUILD/ws/panach/"'


## git
alias ga='git add .'
alias gp='git pull; git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias com='git commit -m $1'
alias ch2='git checkout $1'
alias ch='git checkout -b $1'
alias gr='git checkout release;git pull'
alias gs='git status'
alias gss='git stash'
alias gssl='git stash list'
alias ns='po;npm start'
alias ns2='grunt bswatch'
alias bb='kill -9 $(lsof -ti:3000 -sTCP:LISTEN);git pull;grunt bswatch'
alias pm='git pull origin master;git push origin master'
alias ps='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias lsof='lsof -i :3000'
alias kill='kill -9 $(lsof -ti:3000 -sTCP:LISTEN)'
alias lsof2='lsof -i :$1'
alias kill2='kill -9 $(lsof -ti:$1 -sTCP:LISTEN)'
alias po='kill -9 $(lsof -ti:3000 -sTCP:LISTEN);git pull;npm start'

## mac
alias vo='sudo osascript -e "set Volume $1"'