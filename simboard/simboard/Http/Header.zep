namespace SimBoard\Http;

class Header {

  /**
   * 애플리케이션이 직접 제어할 HTTP 헤더 목록.
   */
  const DATE             = "Date";
  const CONTENT_TYPE     = "Content-Type";
  const CONTENT_LENGTH   = "Content-Length";
  const LAST_MODIFIED    = "Last-Modified";
  const CACHE_CONTROL    = "Cache-Control";
  const EXPIRES          = "Expires";
  const LOCATION         = "Location";
  const SERVER           = "Server";
  const X_POWERED_BY     = "X-Powered-By";

  /**
   * 서버의 헤더를 설정한다.
   *
   * @param string field 헤더 필드.
   * @param string value 헤더 값.
   */
  public static function setServerHeader(const string! field, const string value) -> void {
    header("%s: %s"->format(field->trim(), value));
  }

  private function __construct() {}

}
