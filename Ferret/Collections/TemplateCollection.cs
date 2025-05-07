using Ferret.Models.Templates;

namespace Ferret.Collections;

public class TemplateCollection : AutoCollection<Template, string>
{
    public TemplateCollection()
        : base(v => v.name) { }
}
