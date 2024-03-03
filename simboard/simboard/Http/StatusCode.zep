namespace SimBoard\Http;

class StatusCode {

  /**
   * 애플리케이션이 직접 제어할 HTTP 상태 코드 목록.
   */
  const OK                    = 200;
  const MOVED_PERMANENTLY     = 301;
  const MOVED_TEMPORARILY     = 302;
  const BAD_REQUEST           = 400;
  const FORBIDDEN             = 403;
  const NOT_FOUND             = 404;
  const INTERNAL_SERVER_ERROR = 500;

  /**
   * 서버의 상태 코드를 설정한다.
   *
   * @param int statusCode 상태 코드.
   */
  public static function setServerStatusCode(const int! statusCode = self::OK) -> void {
    http_response_code(statusCode);
  }

  private function __construct() {}

}