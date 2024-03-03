namespace SimBoard\Http\Exception;
use SimBoard\Http\StatusCode;
use Throwable;

final class HttpInternalServerError extends HttpErrorException {

  public function __construct(const string! details = "", const <Throwable> previous = null) {
    parent::__construct(StatusCode::INTERNAL_SERVER_ERROR, "Internal Server Error", details, previous);
  }

}