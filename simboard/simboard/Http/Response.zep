namespace SimBoard\Http;
use SimBoard\Resource\MimeType;

final class Response {

  private statusCode { set, get };
  private headers    { get };
  private body       { get };

  /**
   * @param int statusCode HTTP 상태 코드
   * @param array headers HTTP 헤더
   * @param string body 본문
   */
  public function __construct(
    const int!    statusCode = 200,
    const array!  headers    = [],
    const string! body       = ""
  ) {
    let this->statusCode = statusCode;
    let this->headers    = headers;
    let this->body       = body;
  }

  /**
   * 응답에 헤더를 추가한다.
   *
   * @param string field 헤더 필드.
   * @param string value 헤더 값.
   * @return void
   */
  public function addHeader(string! field, string value) -> void {

    var currentField = "";
    var currentValue = "";

    for currentField, currentValue in this->headers {
      if (currentField->lower() == field->lower()) {
        let field = currentField;
        break;
      }
    }

    let this->headers[field] = value;

  }

  /**
   * Response를 전송한다.
   *
   * @return void
   */
  public function write() -> void {

    var field = "";
    var value = "";

    StatusCode::setServerStatusCode(this->statusCode);
    Header::setServerHeader(Header::CONTENT_TYPE, MimeType::_TXT);
    for field, value in this->headers {
      Header::setServerHeader(field, value);
    }
    //Header::setServerHeader(Header::CONTENT_LENGTH, strlen(this->body));
    Header::setServerHeader(Header::DATE, date(DATE_RFC7231, time()));
    Header::setServerHeader(Header::SERVER, "Zephir");
    Header::setServerHeader(Header::X_POWERED_BY, "Zephir");

    echo this->body;

  }

  /**
   * 파일을 응답으로 전송한다.
   *
   * @param string mimeType 파일의 MIME 타입.
   * @param string content 파일의 내용.
   * @return void
   */
  public static function file(const string! mimeType, const string content) -> void {
    (new Response(StatusCode::OK,
      [ Header::CONTENT_TYPE : mimeType ],
      content
    ))->write();
  }

  // TXT 파일을 응답으로 전송한다.
  public static function plaintext(const string text = "") -> void {
    self::file(MimeType::_TXT, text);
  }

  // HTML 파일을 응답으로 전송한다.
  public static function html(const string html = "<html></html>") -> void {
    self::file(MimeType::_HTML, html);
  }

  /**
   * 리디렉션 응답을 전송한다.
   *
   * @param string uri 리디렉션할 URI.
   * @param bool permanent True일 경우 상태 코드 301, False일 경우 302로 응답.
   * @return void
   */
  public static function redirectTo(const string! uri, const bool permanent = false) -> void {
    (new Response(
      permanent ? StatusCode::MOVED_PERMANENTLY : StatusCode::MOVED_TEMPORARILY,
      [ Header::LOCATION : uri->trim() ]
    ))->write();
  }

}