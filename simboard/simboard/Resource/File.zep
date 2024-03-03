namespace SimBoard\Resource;
use InvalidArgumentException;

class File extends Content {

  /**
   * @var string 파일 절대 경로.
   */
  private absolutePath { get };

  /**
   * @var string 파일 상대 경로.
   */
  private inputPath { get };

  /**
   * @var int 변경 시간 (ctime).
   */
  private changeTime { get };

  /**
   * @var int 수정 시간 (mtime).
   */
  private modifiedTime { get };

  /**
   * @var int 접근 시간 (atime).
   */
  private accessTime { get };

  /**
   * 파일의 절대 경로를 가져온다.
   *
   * @param string inputPath
   * @return void
   * @throws InvalidArgumentException
   */
  private function setAbsolutePath(const string! inputPath) -> void {

    var absolutePath = realpath(inputPath);

    // 파일이 없으면
    if (absolutePath == false) {
      throw new InvalidArgumentException("File does not exist.");
    }

    // 디렉토리거나 접근 권한이 없으면
    if (is_dir(absolutePath) || !is_readable(absolutePath)) {
      throw new InvalidArgumentException("Invalid or inaccessible file.");
    }

    let this->absolutePath = absolutePath;

  }

  public function __construct(const string path = null) {
    if (path !== null && path->length() > 0) {
      this->read(path);
    }
  }

  /**
   * 파일을 메모리에 가져온다.
   *
   * @param string path
   * @return void
   * @throws InvalidArgumentException
   */
  public function read(const string! path) -> void {

    string extension = "";
    var pathInfo = [];
    var mimeType = "";
    var content  = "";

    // 파일의 절대 경로를 가져온다.
    let this->inputPath = path;
    this->setAbsolutePath(path);

    // 파일의 미디어 타입을 가져온다.
    let pathInfo = pathinfo(this->absolutePath, PATHINFO_ALL);
    if (!isset pathInfo["extension"]) {
      let pathInfo["extension"] = "txt";
    }
    let extension = (string)pathInfo["extension"];
    let mimeType = constant("\SimBoard\Resource\MimeType::_%s"->format(extension->upper()));
    if (mimeType === null) {
      throw new InvalidArgumentException("Failed to determine media type.");
    }
    this->setType(mimeType);

    // 파일의 내용을 가져온다.
    let content = file_get_contents(this->absolutePath, false);
    if (content === false) {
      throw new InvalidArgumentException("Failed to read the file.");
    }
    this->setContent(content);

    // 파일의 시간을 가져온다.
    let this->changeTime   = filectime(this->absolutePath);
    let this->modifiedTime = filemtime(this->absolutePath);
    let this->accessTime   = fileatime(this->absolutePath);

  }

}