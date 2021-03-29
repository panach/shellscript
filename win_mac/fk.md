### 일단 본 작업은 망햇음을 알린다  


## 의도/목표
윈도우 재부팅시 IP 변경됨. 고정 불가.  
윈도우를 구석에 모니터 없이 pc 본체만 짱박아두고   
mac 에서 원격으로 접속하여 브라우저 테스트를 하기 쉬운 환경을 제작한다.   
  
1. 윈도우 부팅 > shellscript 동작   
1.1 시간. ip 를 문서a에 기록  
1.2 git 을 동해 문서 a 를 저장  
2. mac 에서 bash 동작  
2.1 bash 에서 git -c 통해 경로 상관없이 저장소 갱신  
2.2 mac에서 git의 문서a 의 원하는 ip 가 기록된 줄의 텍스트만 추축하여 클립보드에 저장.  
3. mac 원격 툴에 ip 사용.



## 윈도우에서 ip를 git으로 저장
```bash
function win_iptest () {
   text=$(ipconfig getifaddr en0) # ip 획득
   timestamp_day=$(date '+%Y%m%d')"_"$(date '+%H%M') # 오늘 시간
   file_location="/Users/경로" # 업로드할 git 경로
   echo "$timestamp_day : $text" > $file_location'pc_page' # pc_page 파일 초기화 후 오늘시간 + ip 를 남김
   tail -n 1 $file_location'pc_page' # 테스트 코드임 : 터미널에 pc_page 의 마지막 라인을 출력함

   # git 으로 남김
    git -C "$(file_location)" pull
    git -C "$(file_location)" add .
    git -C "$(file_location)" commit -m "add : $timestamp_day"
    git -C "$(file_location)" push origin master

    echo "업로드 완료"
    # 본코드 작업에는 에러코드에 대한 방어가 없다 차후 스킬업하고 추가한다
    # mac bash 에는 참고차 넣어만 두도록 하자. windows 에서만 사용하는 코드라고 보면된다
    # 차후 추가.
        # 계정 변경시 대응
        # git 업로드시 에러 대응
}

```

  

## .... 이 코드는 일단 쓸수 없다. 회사에서 지급받은 pc 에서 ....리눅스 설치 불가다  
 위 코드를 대체하여 윈도에서 start.bat 으로 진행 아래 코그를 실행  
  
  

### windosw  start.bat  
  
```bash
  
 d:
 cd d:\/git/폴더명
 git checkout 브런치
 git pull
 echo %date% %time% > "d:\git\폴더\파일"
 ipconfig /renew >> "d:\git\폴더\파일"
 git add .
 git commit -m "add %date% %time%"
 git push origin test/rel

```
  

### mac bash -  저장된 문서 가져옴
```bash
function aaa () {
    git -C "git 경로" pull
    sleep 2
    echo "git pull / 2초 딜레이 ========"
    tail -n 1 $file_location'파일명'
}
```



> 윈도우 테스트를 완료 하고 mac 에서 테스트하는 순간 느꼈다  
> 이건 바보짓이였다  
> windows 에서 해당 bat 을 실행하려면....보안정책상 로그인을 해야한다.  
> 그러면 결국 모니터, 키보드, 마우스 전부 연결해야한다. 그러면 원격이 아닌 로컬로 테스트하면 될것이다.  
> netplwiz 도 정책상 사용불가능하며 레지스트리도 사용이 불가능핟.

그래서 그냥 패스.