namespace SimBoard\Http\Exception;
use SimBoard\Http\StatusCode;
use Throwable;

final class HttpNotFound extends HttpErrorException {

  public function __construct(const string! details = "", const <Throwable> previous = null) {
    parent::__construct(StatusCode::NOT_FOUND, "Not Found", details, previous);
  }

}