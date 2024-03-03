<?php

declare(ticks = 1, strict_types = 1);

if (!version_compare(PHP_VERSION, "8.1.0", ">=")) {
  trigger_error("PHP 8.1+ required.", E_USER_ERROR);
}

$service = new SimBoard\SimBoardService([
  "MYSQL" => [
    "HOST"     => "localhost", // DB 서버 주소
    "DBNAME"   => "board",     // DB 이름
    "USERNAME" => "simboard",  // DB 사용자 이름
    "PASSWORD" => "1234"       // DB 패스워드
  ],
  "PATH" => [
    "STATIC_RESOURCES" => __DIR__ . "/../static",
    "VIEW_TEMPLATES"   => __DIR__ . "/../template",
  ]
]);

set_exception_handler([ $service, "handleException" ]);

$service->run(
  $_SERVER,
  $_GET     ?? [],
  $_POST    ?? [],
  $_FILES   ?? [],
  $_REQUEST ?? [],
  $_SESSION ?? [],
  $_ENV     ?? [],
  $_COOKIE  ?? [],
);

