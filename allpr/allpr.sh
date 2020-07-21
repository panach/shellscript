# 전체서비스 PR 생성
# allpr  또는 allpr "feature/SDUFM-00"
function allpr () {

  branch_list=("home" "atstore" "order" "checkout" "benefit" "paymentbenefit" "cs" "deallist" "mart" "deals_v3" "mall" "point" "tour" "search" "member" "interest" "plan" "schedule" "seller" "shared" "keyword" "tips" "auth" "delivery_my" "review" "category" "mediaprofile" "media" "delivery" "outlet" "store")

  # footer_pr 목록
  # branch_list=("home" "tips" "atstore" "benefit" "paymentbenefit" "check out" "order" "deallist" "mart" "mall" "seller" "plan" "point" "tour" "search" "member" "deals_v3" "keyword" "interest" "cs" "schedule" "shared")
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
  /usr/bin/open -a "/Applications/Google Chrome.app" "https://bitbucket.tmon.co.kr/bitbucket/projects/SDUUI/repos/fe/pull-requests?create&targetBranch=refs/heads/release&sourceBranch=refs/heads/$branch_name"

}