namespace SimBoard\Http;

class Session {

  private static function initialize() -> void {
    if (session_status() === PHP_SESSION_NONE) {
      session_start();
    }
  }

  private static function commit() -> void {
    if (session_status() === PHP_SESSION_ACTIVE) {
      session_commit();
    }
  }

  /**
   * 세션 변수 값을 가져온다.
   *
   * @param string key 가져올 세션 변수 키.
   * @return int|string|null 세션 변수 값 또는 null.
   */
  public static function get(const string! key) -> int|string|null {
    self::initialize();
    if (self::has(key)) {
      return _SESSION[key];
    }
    return null;
  }

  /**
   * 세션 변수에 값을 추가한다.
   *
   * @param string key 추가할 세션 변수 키.
   * @param string value 추가할 세션 변수 값.
   * @return void
   */
  public static function set(const string! key, const string! value) -> void {
    self::initialize();
    let _SESSION[key] = value;
    self::commit();
  }

  /**
   * 세션 변수에서 값을 제거한다.
   *
   * @param string key 삭제할 세션 변수 키.
   * @return void
   */
  public static function remove(const string! key) -> void {
    self::initialize();
    if (self::has(key)) {
      unset(_SESSION[key]);
    }
    self::commit();
  }

  public static function has(const string! key) -> bool {
    self::initialize();
    return array_key_exists(key, _SESSION);
  }

  private function __construct() {}

}