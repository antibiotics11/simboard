# simboard

A simple web board developed purely with <a href="https://github.com/zephir-lang/zephir">Zephir</a>, showcasing a minimal example of C.R.U.D functionality.

## Project Structure

- <a href="https://github.com/antibiotics11/simboard/tree/main/db">/db</a>: SQL schema and data
- <a href="https://github.com/antibiotics11/simboard/tree/main/index">/index</a>: Web root directory for the virtual host
- <a href="https://github.com/antibiotics11/simboard/tree/main/simboard">/simboard</a>: Zephir project directory
- <a href="https://github.com/antibiotics11/simboard/tree/main/simboard/simboard">/simboard/simboard</a>: Zephir source code
- <a href="https://github.com/antibiotics11/simboard/tree/main/static">/static</a>: Static assets (images, JavaScript, CSS, etc.)
- <a href="https://github.com/antibiotics11/simboard/tree/main/template">/template</a>: HTML templates


## Build Instructions

Requires Zephir 0.17.0. <br />
Compatibility with other versions has not been tested.

```bash
cd simboard/
zephir build
```

## Run the Server
Tested on PHP 8.1 or higher. <br />
If you're using Apache, make sure mod_rewrite is enabled.

```bash
php -S localhost:80 index/index.php
```

### Configure Database Connection

Edit <a href="https://github.com/antibiotics11/simboard/blob/main/index/index.php">/index/index.php</a> to update the database credentials.

```php
$service = new SimBoard\SimBoardService([
  "MYSQL" => [
    "HOST"     => "localhost", // Database host
    "DBNAME"   => "board",     // Database name
    "USERNAME" => "simboard",  // Username
    "PASSWORD" => "1234"       // Password
  ]
]);
```


## Notes

This project also explored whether Zephir could meaningfully improve the performance of a traditional synchronous PHP web application.
However, in PHP 8, even simple function calls showed noticeable overhead, leading to overall performance degradation.
While PHP 7 might offer some gains, in PHP 8 and above, Zephir may introduce more cost than benefit in this context.

## Screenshots

![simboard-1](https://github.com/antibiotics11/simboard/assets/75349747/a30b1c1c-d2a6-4da4-8266-b976864fb653)
![simboard-3](https://github.com/antibiotics11/simboard/assets/75349747/b6cf9b10-016f-4106-ad6c-3ddcb156b30a)
![simboard-2](https://github.com/antibiotics11/simboard/assets/75349747/14b28abe-31ab-4588-89ac-b8a812191f81)
