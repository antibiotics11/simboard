namespace SimBoard\Controller;
use SimBoard\Resource\File;
use SimBoard\Http\Route;
use SimBoard\Http\Response;
use SimBoard\Http\Exception\HttpNotFound;
use SimBoard\Http\Exception\HttpInternalServerError;
use InvalidArgumentException;
use Throwable;

final class StaticController extends Controller {

  private staticResourcesPath;

  public function __construct(const string! staticResourcesPath) {

    let this->staticResourcesPath = staticResourcesPath;

    // StaticController에는 모델, 뷰 없음.
    parent::__construct(null, null);

  }

  public function handle(const <Route> route, const array! globals) -> void {

    string requestPath = "";
    var file = null;

    try {

      // 요청 경로가 없는 경우
      if (!isset route->getMatches()[1]) {
        throw new InvalidArgumentException();
      }

      // 요청 경로를 파일 경로로 전환한다.
      let requestPath = str_replace(["./", "../"], "/", route->getMatches()[1]);
      let requestPath = "%s/%s"->format(this->staticResourcesPath, requestPath);

      // 파일 객체를 생성한다.
      let file = new File(requestPath);

      // 파일을 응답으로 전송한다.
      Response::file(file->getType(), file->getContent());

    // InvalidArgumentException 발생한 경우, 404 Not Found 응답을 전송한다.
    } catch InvalidArgumentException {
      throw new HttpNotFound("요청하신 자료를 찾을 수 없습니다.");

    // 그 외 알 수 없는 오류가 발생한 경우, 500 Internal Server Error 응답을 전송한다.
    } catch Throwable {
      throw new HttpInternalServerError("알 수 없는 오류가 발생했습니다.");
    }

  }

}