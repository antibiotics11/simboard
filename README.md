# simboard
 
<a href="https://github.com/zephir-lang/zephir">Zephir</a>만 사용해서 웹 만들어보기

## 프로젝트 구조

- <a href="https://github.com/antibiotics11/simboard/tree/main/db">/db</a>: SQL 파일
- <a href="https://github.com/antibiotics11/simboard/tree/main/index">/index</a>: 가상 호스트의 루트 디렉토리
- <a href="https://github.com/antibiotics11/simboard/tree/main/simboard">/simboard</a>: Zephir 프로젝트 디렉토리
- <a href="https://github.com/antibiotics11/simboard/tree/main/simboard/simboard">/simboard/simboard</a>: Zephir 소스 코드
- <a href="https://github.com/antibiotics11/simboard/tree/main/static">/static</a>: 정적 리소스 (png,js,css...)
- <a href="https://github.com/antibiotics11/simboard/tree/main/template">/template</a>: 템플릿 파일 (html)

## 빌드

Zephir 0.17.0이 필요합니다. <br />
다른 버전에서는 빌드 가능 여부가 확인되지 않았습니다.

```bash
cd simboard/
zephir build
```

## 실행

PHP 8.1 또는 상위 버전에서 실행할 수 있습니다. <br />
Apache에서는 mod_rewrite를 활성화해야 합니다.

```bash
php -S localhost:80 index/index.php
```

### DB 접속정보 변경

<a href="https://github.com/antibiotics11/simboard/blob/main/index/index.php">/index/index.php</a>를 수정하여 DB 접속정보를 변경합니다.

```php
$service = new SimBoard\SimBoardService([
  "MYSQL" => [
    "HOST"     => "localhost", // DB 서버 주소
    "DBNAME"   => "board",     // DB 이름
    "USERNAME" => "simboard",  // DB 사용자 이름
    "PASSWORD" => "1234"       // DB 패스워드
  ]
]);
```

## 스크린샷

![simboard-1](https://github.com/antibiotics11/simboard/assets/75349747/a30b1c1c-d2a6-4da4-8266-b976864fb653)
![simboard-3](https://github.com/antibiotics11/simboard/assets/75349747/b6cf9b10-016f-4106-ad6c-3ddcb156b30a)
![simboard-2](https://github.com/antibiotics11/simboard/assets/75349747/14b28abe-31ab-4588-89ac-b8a812191f81)
