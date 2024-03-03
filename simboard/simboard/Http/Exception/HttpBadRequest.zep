namespace SimBoard\Http\Exception;
use SimBoard\Http\StatusCode;
use Throwable;

final class HttpBadRequest extends HttpErrorException {

  public function __construct(const string! details = "", const <Throwable> previous = null) {
    parent::__construct(StatusCode::BAD_REQUEST, "Bad Request", details, previous);
  }

}