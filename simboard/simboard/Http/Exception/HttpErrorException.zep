namespace SimBoard\Http\Exception;
use SimBoard\Http\StatusCode;
use Stringable;
use Exception;
use Throwable;

class HttpErrorException extends Exception implements Stringable {

  /**
   * @var int HTTP 상태 코드.
   */
  protected statusCode { get };

  /**
   * @var string HTTP 상태 구문.
   */
  protected statusPhrase { get };

  /**
   * @var string 오류 상세 정보.
   */
  protected details { get };

  /**
   * @param int statusCode HTTP 상태 코드.
   * @param string statusPhrase HTTP 상태 구문.
   * @param string details 오류와 관련된 상세 정보.
   * @param Throwable|null previous 이전 예외.
   */
  public function __construct(
    const int!        statusCode   = StatusCode::INTERNAL_SERVER_ERROR,
    const string!     statusPhrase = "Internal Server Error",
    const string!     details      = "",
    const <Throwable> previous     = null
  ) {

    let this->statusCode   = statusCode;
    let this->statusPhrase = statusPhrase;
    let this->details      = details;

    parent::__construct(this->__toString(), statusCode, previous);

  }

  public function __toString() -> string {
    return "%d %s"->format(this->statusCode, this->statusPhrase);
  }

  public function toArray() -> array {
    return get_object_vars(this);
  }

}