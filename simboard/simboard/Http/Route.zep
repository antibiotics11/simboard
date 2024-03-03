namespace SimBoard\Http;

final class Route {

  private method  { get };
  private pattern { get };
  private handler { get };
  private matches { set, get };

  /**
   * @param string method 요청 메소드.
   * @param string pattern 요청을 비교할 URI 패턴.
   * @param callable handler 요청을 처리할 핸들러 (컨트롤러).
   * @param string[] matches 요청과 일치하는 URI 정보.
   */
  public function __construct(
    const string!   method,
    const string!   pattern,
    const callable! handler,
    const array!    matches = []
  ) {
    let this->method  = method;
    let this->pattern = pattern;
    let this->handler = handler;
    let this->matches = matches;
  }

}