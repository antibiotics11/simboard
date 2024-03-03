namespace SimBoard\Controller;
use SimBoard\Resource\MimeType;
use SimBoard\Http\Route;
use SimBoard\Http\StatusCode;
use SimBoard\Http\Header;
use SimBoard\Http\Response;
use SimBoard\Http\Exception\HttpErrorException;

final class ErrorController extends Controller {

  public function handleHttpError(const <HttpErrorException> ex) -> void {
    (new Response(
      ex->getStatusCode(),
      [
        Header::CONTENT_TYPE  : MimeType::_HTML,
        Header::CACHE_CONTROL : "no-cache, no-store, must-revalidate",
        Header::EXPIRES       : "Thu, 01 Jan 1970 00:00:00 GMT"
      ],
      this->view->view(ex->toArray())
    ))->write();
  }

  // 사용하지 않음.
  public function handle(const <Route> route, const array! globals) -> void {}

}