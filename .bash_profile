# zsh/bash 토글
# exec bash
#  위 사용 후 source ~/.bash_profile 해줘야 불러옴
# exec zsh


# Git branch in prompt.

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
# export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\h:\[\e[31;1m\]\w:> \[\e[0m\]"


export PS1=" \u${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
#export PS1="${debian_chroot:+($debian_chroot)}   \[\033[01;34m\]   \w\[\033[00m\]\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

# bash_profile 리로드
function reload () {
  # clear
  source ~/.bash_profile
  echo "bash_profile Reloaded!!!"
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
  j $(git rev-parse --abbrev-ref HEAD | cut -c 15-)

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
  nextName="김주현" # daily 다음 사람 이름
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
    # 해당 명령어를 입력하는 폴더 경로를 받아 특정단어를 검색
    # 특정단어에 따라 bitbucket 의 PR 까지 연다
    text=$(pwd)
    if [[ $text =~ 'fe' ]];then
        echo "fe"
    elif [[ $text =~ 'benefit' ]];then
        echo "be"
    fi
}


# 전체서비스 PR 생성
function allpr () {

  # branch_list=("home" "atstore" "order" "checkout" "benefit" "paymentbenefit" "cs" "deallist" "mart" "deals_v3" "mall" "point" "tour" "search" "member" "interest" "plan" "schedule" "seller" "shared" "keyword" "tips" "auth" "delivery_my" "review" "category" "mediaprofile" "media" "delivery" "outlet" "store")

  # footer_pr 목록
  branch_list=("home" "tips" "atstore" "benefit" "paymentbenefit" "checkout" "order" "deallist" "mart" "mall" "seller" "plan" "point" "tour" "search" "member" "deals_v3" "keyword" "interest" "cs" "schedule" "shared")

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
    echo "$1 지라 열기"
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUFM/issues/SDUFM-$1?filter=allissues"
  else
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://jira.tmon.co.kr/projects/SDUFM/?filter=allissues"
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


## 파일 관련
# png 60-80 파일명.png
alias png='pngquant --ext _new.png --speed 1 --quality'


## 브라우저
alias cat_bash='cat ~/.bash_profile'
alias vs_bash='code ~/.bash_profile'
alias sun='/usr/bin/open -a "/Applications/Google Chrome.app" "http://sun.tmonc.net/view/994.FE/job/FE_BUILD/ws/panach/"'


## git
alias ga='git add .'
alias gp='git pull; git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias com='git commit -m $1'
alias gr='git checkout release;git pull'
alias gs='git status'
alias gss='git stash'
alias gssl='git stash list'
alias ns='po;npm start'
alias bb='kill -9 $(lsof -ti:3000 -sTCP:LISTEN);git pull;grunt bswatch'
alias pm='git pull origin master;git push origin master'
alias ps='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias lsof='lsof -i :3000'
alias kill='kill -9 $(lsof -ti:3000 -sTCP:LISTEN)'
alias po='kill -9 $(lsof -ti:3000 -sTCP:LISTEN);git pull;npm start'

## mac
alias vo='sudo osascript -e "set Volume $1"'