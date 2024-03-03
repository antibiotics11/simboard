namespace SimBoard\Http\Exception;
use SimBoard\Http\StatusCode;
use Throwable;

final class HttpForbidden extends HttpErrorException {

  public function __construct(const string! details = "", const <Throwable> previous = null) {
    parent::__construct(StatusCode::FORBIDDEN, "Forbidden", details, previous);
  }

}