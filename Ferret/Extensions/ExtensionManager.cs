using System.Collections.Generic;
using System.Linq;

namespace Ferret.Extensions;

public class ExtensionManager
{
    public List<IExtension> extensions { get; } = new();

    public void Add(IExtension extension) => extensions.Add(extension);

    public IEnumerable<IExtension> Enabled() => extensions.Where(e => e.enabled);

    public IEnumerable<IExtension> Changed() => Enabled().Where(e => e.hasChanged);

    public IEnumerable<IExtension> Unchanged() => Enabled().Where(e => !e.hasChanged);
}
