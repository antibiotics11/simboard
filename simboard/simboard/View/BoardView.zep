namespace SimBoard\View;

final class BoardView extends View {

  /**
   * 게시판 목록을 렌더링하여 반환한다.
   */
  public function list(const array! data) -> string {

    array  activeBoards    = [];
    array  closedBoards    = [];
    string displayOpenForm = "none";

    if (isset data["active_boards"] && is_array(data["active_boards"])) {
      let activeBoards = (array)data["active_boards"];
    }
    if (isset data["closed_boards"] && is_array(data["closed_boards"])) {
      let closedBoards = (array)data["closed_boards"];
    }
    if (isset data["is_logged_in"] && is_bool(data["is_logged_in"])) {
      let displayOpenForm = data["is_logged_in"] ? "inline" : "none";
    }

    return this->renderer->render(
      this->renderer->loadTemplate(
        "%s/board/list.html"->format(this->templatePath)
      ), [
        "display_open_form"   : displayOpenForm,
        "active_boards"       : this->listBoards(activeBoards),
        "active_boards_count" : "%d"->format(count(activeBoards)),
        "closed_boards"       : this->listBoards(closedBoards),
        "closed_boards_count" : "%d"->format(count(closedBoards))
      ]
    );

  }

  private function listBoards(const array! boards) -> string {

    if (count(boards) === 0) {
      return "";
    }

    string template = (string)this->renderer->loadTemplate(
      "%s/board/list_element.html"->format(this->templatePath)
    );
    string rendered = "";
    var    board    = [];

    for board in boards {
      let rendered = "%s%s"->format(rendered,
        this->renderer->render(template, [
          "board_title" : htmlspecialchars("%s"->format(board["board_title"])),
          "board_id"    : "%d"->format(board["board_id"]),
          "created_at"  : "%s"->format(explode(" ", board["created_at"])[0])
        ])
      );
    }

    return rendered;

  }

  /**
   * 게시판의 글 목록을 렌더링하여 반환한다.
   */
  public function board(const array! data) -> string {

    array  articles       = (array)data["articles"];
    array  boardDetails   = (array)data["board_details"];
    array  adminDetails   = (array)data["admin_details"];
    string adminEmail     = (string)adminDetails["email"];

    // 게시판 관리자가 아니면 이메일 주소 일부를 가린다.
    if (!data["is_board_admin"]) {
      let adminEmail = substr_replace(adminEmail, "****", adminEmail->length() / 5);
    }

    return this->renderer->render(
      this->renderer->loadTemplate(
        "%s/board/board.html"->format(this->templatePath)
      ), [
        "board_id"        : "%d"->format(boardDetails["board_id"]),
        "board_title"     : boardDetails["board_title"],
        "articles_count"  : "%d"->format(count(articles)),
        "created_at"      : boardDetails["created_at"],
        "admin_name"      : adminDetails["name"],
        "admin_email"     : adminEmail,
        "is_board_admin"  : (data["is_board_admin"] && !data["is_closed_board"]) ? "true" : "false",
        "is_closed_board" : (data["is_closed_board"]) ? "true" : "false",
        "is_logged_in"    : (data["is_logged_in"]) ? "true" : "false",
        "is_empty_board"  : (count(articles) === 0) ? "true" : "false",
        "articles"        : this->articles(articles)
      ]
    );

  }

  private function articles(const array! articles) -> string {

    if (count(articles) === 0) {
      return "";
    }

    uint   index = 0;
    string template = (string)this->renderer->loadTemplate(
      "%s/board/article.html"->format(this->templatePath)
    );
    string rendered = "";
    string content  = "";
    var    article  = [];

    for article in articles {
      let index++;
      let content = (string)nl2br(htmlspecialchars(article["content"]));

      let rendered = "%s%s"->format(rendered,
        this->renderer->render(template, [
          "article_index"       : "%d"->format(index),
          "article_author_name" : article["author_name"],
          "article_written_at"  : article["written_at"],
          "article_content"     : content
        ])
      );
    }

    return rendered;

  }

  public function view(const array! data) -> string {

    string rendered = "";
    array matchingViewer = [ this, (string)data["page"] ];

    if (is_callable(matchingViewer)) {
      let rendered = (string)call_user_func(matchingViewer, data["data"]);
    }

    return this->renderer->render(
      this->renderer->loadTemplate("%s/template.html"->format(this->templatePath)),
      [ "main_content" : rendered ]
    );

  }

}