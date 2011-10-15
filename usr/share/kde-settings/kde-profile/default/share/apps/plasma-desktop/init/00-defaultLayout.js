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

var topLeftScreen = 0
var rect = screenGeometry(0)

// find our "top left" screen to put the folderview on it
for (var i = 1; i < screenCount; ++i) {
    var g = screenGeometry(i)

    if (g.x <= rect.x && g.top >= rect.top) {
        rect = g
        topLeftScreen = i
    }
}

var hasFolderview = widgetExists("folderview");

for (var i = 0; i < screenCount; ++i) {
    var desktop = new Activity
    desktop.name = i18n("Desktop")
    desktop.screen = i
    desktop.wallpaperPlugin = 'image'
    desktop.wallpaperMode = 'SingleImage'

    if (hasFolderview && i == topLeftScreen) {
        var folderview = desktop.addWidget("folderview")
        folderview.writeConfig("url", "desktop:/")
    }

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
