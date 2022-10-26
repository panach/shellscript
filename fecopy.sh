#!/bin/sh
clear
echo '시작';

sunDir=/Users/panach/Documents/git/fe_build/panach/
feDir=/Users/panach/Documents/git/fe/tmon/dist
webFeBuildURL="http://sun.tmonc.net/view/994.FE/job/FE_BUILD/ws/panach/"

timeStampDay=$(date '+%Y%m%d')"_"$(date '+%H%M')
branchName=$(git -C "${feDir}" rev-parse --abbrev-ref HEAD) | sed -e 's/feature//' -e 's/hotfix//' -e 's/fix//' -e 's/\///';
echo "$branchName"

# fe_build 폴더가 있는지 체크
if [ -d "$sunDir" ];then 
    echo "1.0 FE_BUILD 존재함 --------------------------"

    # 저장소 최신화
    # fe_build -> git pull
    echo "1.0.1. MAC 계정 패스워드를 넣어주세요 ---------------------"
    git -C "$sunDir" pull
    echo "1.0.2. FE_BUILD 최신화 완료 ---------------------"
    echo "1.0.3. FE 브랜치 확인 $branchName ---------------------"
    #pwd 에 브런치명이 있는가??? 없다면 입력!!
    if [ -n "$branchName" ]; then
        echo "1.1.1 저장소의 브런치가 확인 되었습니다."
        echo "1.1.2 $branchName"
    else 
        echo "1.1.1 저장소의 브런치가 미확인 상태입니다."
        read -e -p "1.1.2 사용 하실 폴더 명을 입력해 주세요 : " branchName
            # branchName 빈값 테스트
        if [ -n "$branchName" ]; then
            echo "1.2 폴더명 입력 완료 ($branchName) --------------------------"
        else 
            echo "1.3 폴더명을 입력 해주세요!! 실행을 중단합니다. -----"
            exit
        fi
    fi

    echo "1.4 FE_BUILD 입력 하신 폴더를 확인합니다. -----------------------------"

    # 생성할 폴더가 존재하는지 체크
    if [ -d "$sunDir/$branchName" ]; then
        clear
        echo "1.5. 입력하신 폴더가 존재합니다. ------------------"
        echo "1.5.1. 폴더 존재 :  ${branchName} "
        echo "--------------------------------------------"
        echo " "
        echo "1.5.2. 기존 폴더를 삭제 후 복사  = 1"
        echo "1.5.3. finder로 보기 = 2"
        echo "1.5.4. 중지 = 엔터"
        echo ""
        read -e -p "1.5.5 실행 프로세스를 선택 해주세요 : " tmpAn
        if [ $tmpAn = "1" ]; then
            echo "------------------------"
            echo "1.5.5.1 ---- 1번 입력 ----"
            rm -rf $sunDir/$branchName 
            cp -r $feDir/ /$sunDir/$branchName

        elif [ $tmpAn = "2" ]; then
            echo "------------------------"
            echo "1.5.5.2 ---- 2번 입력 ----"
            open -a Finder /$sunDir/$branchName
            exit
        else
            clear
            echo "------------------------"
            echo "1.5.5.4 과정을 정지합니다.."
            exit
        fi

    else 
        echo "1.6 $branchName 폴더를 생성합니다.------"
        mkdir "$sunDir/$branchName"
        echo "1.6.1. 생성한 폴더에 파일을 복사합니다.------"
        cp -r $feDir/ /$sunDir/$branchName

        # fe_build -> add, commit , push 
        # commit -> 현시간으로.
        echo "1.6.2 [${branchName}] $timeStampDay"


        git -C "$sunDir" add .
        git -C "$sunDir" commit -m "[${branchName}] $timeStampDay"
        echo "1.6.3 완료 ----------------------"
        git -C "$sunDir" push origin master

        # 브라우저로 fe_build 열기
        /usr/bin/open -a "/Applications/Google Chrome.app" "$webFeBuildURL"
    fi

else 
    echo "2.0. FE_BUILD 없음, git clone 을 먼저 확인해주세요. --------------------------"
    exit
fi
