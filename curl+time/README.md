
현재 시간 구하기
```
$(date +%y-%m-%dT%H:%M:%S)
```

Curl 옵션
* -s : 진척상황 미표시
* -S : 에러 메시지 표시
* -w '%{http_code}\n' : status 표시

명령어 소요시간 표시
time()

2>&1
표준 에러를 표준 출력으로 리다이렉트
ex) rm test.txt > /dev/null 2>&1
