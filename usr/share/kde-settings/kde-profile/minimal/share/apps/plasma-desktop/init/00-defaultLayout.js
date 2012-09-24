loadTemplate("org.kde.plasma-desktop.defaultPanel")

function noDisplayEvents(widget, containment)
{
    widget.writeConfig("displayEvents", false);
}

var findWidgetsTemplate = loadTemplate("org.kde.plasma-desktop.findWidgets");
findWidgetsTemplate.findWidgets("digital-clock", noDisplayEvents);

function widgetExists(name)
{
    var widgets = knownWidgetTypes;
    for (i in widgets) {
        if (widgets[i] == name) {
            return true;
        }
    }

    return false;
}

for (var i = 0; i < screenCount; ++i) {
    var desktop = new Activity
    desktop.name = i18n("Desktop")
    desktop.screen = i
    desktop.wallpaperPlugin = 'image'
    desktop.wallpaperMode = 'SingleImage'

    //Create more panels for other screens
    if (i > 0){
        var panel = new Panel
        panel.screen = i
        panel.location = 'bottom'
        panel.height = panels()[i].height = screenGeometry(0).height > 1024 ? 35 : 27
        var tasks = panel.addWidget("tasks")
        tasks.writeConfig("showOnlyCurrentScreen", true);
    }

}

// Replace existing launcher with simplelauncher

var pids = panelIds;

for (var i = 0; i < pids.length; ++i) {
  var p = panelById(pids[i]);
  if (!p) continue;
  var ids = p.widgetIds;

  for (var j = 0; j < ids.length; ++j) {
       var w = p.widgetById(ids[j]);
       if (!w || w.type != "launcher") continue;

       w.remove();
       var launcher = p.addWidget("simplelauncher");
       launcher.index = 0;
       launcher.writeConfig("icon", "start-here-kde-fedora");
       break;
  }

}
