namespace SimBoard\View;
use SimBoard\Resource\File;
use InvalidArgumentException;

class Renderer {

  /**
   * 템플릿을 렌더링한여 HTML로 반환한다.
   *
   * @param string template 템플릿 양식.
   * @param mixed[] data 출력할 데이터. 배열 값이 문자열이면 그대로 출력하고,
   *                     "data" => [
   *                       "template"   => string,
   *                       "data"       => string[],
   *                       "escapeHTML" => boolean
   *                     ]
   *                     형식의 다차원 배열이면 재귀적으로 렌더링한다.
   * @param bool escapeHTML True일 경우, HTML 태그를 이스케이프한다.
   * @return string
   * @throws InvalidArgumentException
   */
  public function render(const string! template, const array! data = [], const bool! escapeHTML = false) -> string {

    string view = template;
    var key = "", value = "";

    for key, value in data {

      // value가 배열인 경우
      if (typeof value == "array") {

        // 필수 키들('template', 'data', 'escapeHTML')이 있는지 확인한다.
        if (!isset value["template"]) {
          throw new InvalidArgumentException("Missing 'template' in the nested array.");
        }
        if (!isset value["data"]) {
          throw new InvalidArgumentException("Missing 'data' in the nested array.");
        }
        if (!isset value["escapeHTML"]) {
          let value["escapeHTML"] = false;
        }

        // 재귀적으로 렌더링한다.
        let value = this->render(value["template"], value["data"], value["escapeHTML"]);

      }

      // value가 문자열인 경우, 템플릿에서 해당 key의 변수를 value로 치환한다.
      if (typeof value == "string") {
        let view = str_replace("${%s}"->format(key), value, view);
      } else {
        throw new InvalidArgumentException(
          "Invalid value type. Expected 'string', but received '%s'"->format(typeof value)
        );
      }

    }

    // escapeHTML이 True인 경우, HTML 태그를 이스케이프한다.
    if (escapeHTML) {
      let view = htmlspecialchars(view);
    }

    return view;

  }

  /**
   * 템플릿 파일을 문자열로 불러온다.
   *
   * @param string templateFilePath
   * @return string
   */
  public function loadTemplate(const string! templateFilePath) -> string {
    return (new File(templateFilePath))->getContent();
  }

}