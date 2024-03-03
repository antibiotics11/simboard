namespace SimBoard\View;

final class MemberView extends View {

  public function view(const array! data) -> string {

    string page = "%s/member/%s.html"->format(this->templatePath, data["page"]);

    return this->renderer->render(
      this->renderer->loadTemplate(
        "%s/template.html"->format(this->templatePath)
      ), [
        "main_content" : [
          "template"   : this->renderer->loadTemplate(page),
          "data"       : data["data"],
          "escapeHTML" : false
        ]
      ]
    );

  }

}